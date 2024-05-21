//
//  Session.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/12/22.
//

import Foundation
import Alamofire
import ACProgressHUD_Swift
import FirebaseCrashlytics





class AspireConnection {
    static var shared = AspireConnection()
    let managerSession : Session
    let requestTimeoutInterval: TimeInterval = 60
    
    
    init() {
        URLCache.shared.removeAllCachedResponses()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = requestTimeoutInterval
        configuration.urlCache = nil
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        // MARK: - SSL Pinning
        if !NetworkConstants.isDisableProtections {
            var evaluators: [String: ServerTrustEvaluating] = [:]
            let disabledTrustEvaluator = DisabledTrustEvaluator()
            let pinnedCertificatesTrustEvaluator = PublicKeysTrustEvaluator()
            NetworkConstants.domainsToVerifyCertificate.forEach { evaluators[$0] = pinnedCertificatesTrustEvaluator }
            NetworkConstants.domainsToSkipCertificateVerification.forEach { evaluators[$0] = disabledTrustEvaluator }
            let serverTrustManager = AspireServerTrustManager(evaluators: evaluators)
            managerSession = Session(configuration: configuration, interceptor: nil, serverTrustManager: serverTrustManager)
        } else {
            managerSession = Session(configuration: configuration)
        }
    }
    
    private func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func request(_ urlConvertible: RequestProtocol, handleComplete: ((Data?, Error?)->())?) {
        if urlConvertible.cacheConfig.cacheTime > 0 {
            let cacheKey = self.createKeyToCache(urlConvertible: urlConvertible)
            if let responseData = self.getDataFromCache(cacheKey: cacheKey) {
                handleComplete?(responseData, nil)
                return;
            }
        }
        
        if(!isConnectedToInternet()){
            let message = "The Internet connection appears to be offline."
            Crashlytics.crashlytics().log(message)
            Crashlytics.crashlytics().record(error: message.asError)
            handleComplete?(nil, NetworkError.noInternet)
            UtilServices.shared.noInternetProcess()
            return
        }
        Crashlytics.crashlytics().setCustomValue("Method: \(urlConvertible.method.rawValue) \nurl request:\(urlConvertible.baseURLString)/\(urlConvertible.path)", forKey: "Lastes request action")
        Crashlytics.crashlytics().setCustomKeysAndValues((urlConvertible.params ?? [:]))
        managerSession.request(urlConvertible).responseJSON(completionHandler: { (response) in
            // Check result from response and map it the the promise
            switch response.result {
            case .success:
                if let data = response.data {
                    if urlConvertible.cacheConfig.cacheTime > 0 {
                        let cacheKey = self.createKeyToCache(urlConvertible: urlConvertible)
                        self.cacheData(cacheKey: cacheKey, cacheConfig: urlConvertible.cacheConfig, data: data)
                    }
                    handleComplete?(data, nil)
                } else {
                    handleComplete?(nil, APIError.SuccessWithEmptyData)
                }
                
                break
            case .failure(let error):
                // If it's a failure, check status code and map it to my error
                Crashlytics.crashlytics().record(error: error, userInfo: urlConvertible.params)
                switch response.response?.statusCode {
                case 400:
                    handleComplete?(nil, NetworkError.badAPIRequest)
                    break
                case 401:
                    handleComplete?(nil, NetworkError.unauthorized)
                    break
                default:
                    guard NetworkReachabilityManager()?.isReachable ?? false else {
                        handleComplete?(nil, NetworkError.noInternet)
                        return
                    }
                    handleComplete?(nil, error)
                }
                // Firebase tracking
                if response.response?.statusCode == 503 {
//                    FirebaseTracking.share.logEventScreenError(errorType: .server_down, errorCode: 503, errorURL: urlConvertible.urlRequest?.url?.absoluteString)
                }else {
//                    FirebaseTracking.share.logEventScreenError(errorType: .server_error, errorCode: response.response == nil ? 400 : response.response!.statusCode , errorURL: urlConvertible.urlRequest?.url?.absoluteString)
                }
            }
        })
    }
}

extension AspireConnection{
    func  removeExpiredCacheToSignout() {
           if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
               let fileURL =  dir.appendingPathComponent("data_cache")
               do{
                   let files = try FileManager.default.contentsOfDirectory(atPath: fileURL.path)
                   for name in files {
                       if let dic = NSDictionary(contentsOf: fileURL.appendingPathComponent(name)) as? [String : AnyObject] {
                           if let timeInteval = dic["expiredTime"] as? TimeInterval , let needToRemove = dic["needRemoveWhenLogout"] as? Bool {
                               let expiredDate = Date(timeIntervalSince1970: timeInteval)
                               if Date() > expiredDate || needToRemove {
                                   do{
                                       try FileManager.default.removeItem(at: fileURL.appendingPathComponent(name))
                                   }catch{ }
                               }
                           }
                       }
                   }
               }catch{
                print(error)
               }
           }
       }
}

fileprivate extension AspireConnection {
    
    func cacheData(cacheKey:String, cacheConfig: CacheConfig, data:Data){
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if json.keys.contains("errorCode") || json.keys.contains("errorSummary") ||  json.keys.contains("error_description"){
                    return
                }
            }
        } catch {
            Crashlytics.crashlytics().record(error: error)
            return
        }
        
        if cacheConfig.cacheTime > 0 {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let cacheFolder = dir.appendingPathComponent("data_cache")
                if !FileManager.default.fileExists(atPath: cacheFolder.path) {
                    try? FileManager.default.createDirectory(atPath: cacheFolder.path, withIntermediateDirectories: false, attributes: nil)
                }
                let fileURL = cacheFolder.appendingPathComponent(cacheKey)
                let expiredTime = Date().addingTimeInterval(TimeInterval(cacheConfig.cacheTime*60*60)).timeIntervalSince1970
                let jsonCache = ["expiredTime": expiredTime,
                                 "data": data,
                                 "needRemoveWhenLogout": cacheConfig.needRemoveWhenLogout] as [String : Any]
                do {
                    try NSMutableDictionary(dictionary: jsonCache).write(to: fileURL)
                } catch {
                    Crashlytics.crashlytics().record(error: error)
                }
            }
        }
    }
    
    func getDataFromCache(cacheKey:String) -> Data?{
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("data_cache").appendingPathComponent(cacheKey)
            if let dic = NSDictionary(contentsOf: fileURL) as? [String : AnyObject] {
                if let timeInteval = dic["expiredTime"] as? TimeInterval , let data = dic["data"] as? Data {
                    let expiredDate = Date(timeIntervalSince1970: timeInteval)
                    if Date() > expiredDate {
                        do{
                            try FileManager.default.removeItem(at: fileURL)
                            return nil
                        }catch{
                            return nil
                        }
                    }else {
                        return data
                    }
                }
                return nil
            }
        }
        return nil
    }
    
    func createKeyToCache(urlConvertible: RequestProtocol) -> String {
        var keyStr = ""
        if let endPoint = urlConvertible.urlRequest?.url?.absoluteString {
            keyStr = endPoint
        }
        keyStr = keyStr + urlConvertible.method.rawValue
        if let body = urlConvertible.body {
            let sortOne = body.sorted { return $0.key < $1.key }
            keyStr = keyStr + sortOne.description
        }
        if let params = urlConvertible.params {
            let sortOne = params.sorted { return $0.key < $1.key }
            keyStr = keyStr + sortOne.description
        }
        keyStr = keyStr.replacingOccurrences(of: ")", with: "")
        keyStr = keyStr.replacingOccurrences(of: "(", with: "")
        keyStr = keyStr.replacingOccurrences(of: "]", with: "")
        keyStr = keyStr.replacingOccurrences(of: "[", with: "")
        keyStr = keyStr.replacingOccurrences(of: "\\\"", with: "")
        let arr = keyStr.split(separator: " ")
        let str = arr.sorted().joined(separator: " ")
        return str.MD5
    }
}


final class AspireServerTrustManager: ServerTrustManager {
    override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
        if let evaluator = evaluators[host] {
            return evaluator
        }
        
        var domainComponents = host.split(separator: ".")
        if domainComponents.count > 2 {
            domainComponents[0] = "*"
            let wildcardHost = domainComponents.joined(separator: ".")
            return evaluators[wildcardHost]
        }
        
        if allHostsMustBeEvaluated {
            Crashlytics.crashlytics().record(error: AFError.serverTrustEvaluationFailed(reason: .noRequiredEvaluator(host: host)))
            throw AFError.serverTrustEvaluationFailed(reason: .noRequiredEvaluator(host: host))
        }
        
        return nil
    }
    
}


