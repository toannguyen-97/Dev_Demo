//
//  TrendyServices.swift
//  GMA
//
//  Created by Hoan Nguyen on 16/03/2022.
//

import Foundation

class TrendyServices{
    
    func getTrendyCities(completion:@escaping(Result<[TrendCity], Error>) -> Void){
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.trendycities" + "\(NSDate().timeIntervalSince1970)")
        var totalError: Error?
        
        serialQueue.async {
            serialQueue.suspend()
            OktaServices().getServiceTokenWith { (results) in
                switch results{
                case .success(_):
                    break
                case.failure(let err):
                    totalError = err
                }
                serialQueue.resume()
            }
        }
        serialQueue.async {
            if totalError == nil {
                serialQueue.suspend()
                AspireConnection.shared.request(TrendyRouter.getTrendyCities) { (data, error) in
                    if error != nil{
                        print(error!)
                        completion(.failure(error!))
                    }else{
                        if let dataJson = data{
                            do {
                                let jsonResponse = try JSONDecoder().decode(TrendyCities.self, from: dataJson)
                                completion(.success(jsonResponse.topTrends.trendCity))
                            } catch {
                                print(error)
                                completion(.failure(error))
                            }
                        }else {
                            completion(.failure(NetworkError.unknown))
                        }
                    }
                    serialQueue.resume()
                }
            }else {
                completion(.failure(totalError!))
            }
        }
    }
    
    func getTrendyContent(city: String, completion:@escaping(Result<[Trend], Error>) -> Void){
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.trendycontent" + "\(NSDate().timeIntervalSince1970)")
        var totalError: Error?
        
        serialQueue.async {
            serialQueue.suspend()
            OktaServices().getServiceTokenWith { (results) in
                switch results{
                case .success(_):
                    break
                case.failure(let err):
                    totalError = err
                }
                serialQueue.resume()
            }
        }
        serialQueue.async {
            if totalError == nil {
                serialQueue.suspend()
                AspireConnection.shared.request(TrendyRouter.getTrendyContent(city: city)) { (data, error) in
                    if error != nil{
                        print(error!)
                        completion(.failure(error!))
                    }else{
                        if let dataJson = data{
                            do {
                                let jsonResponse = try JSONDecoder().decode(TrendyContent.self, from: dataJson)
                                completion(.success(jsonResponse.topTrends.trend))
                            } catch {
                                print(error)
                                completion(.success([]))
                            }
                        }else {
                            completion(.failure(NetworkError.unknown))
                        }
                    }
                    serialQueue.resume()
                }
            }else {
                completion(.failure(totalError!))
            }
        }
    }
}
