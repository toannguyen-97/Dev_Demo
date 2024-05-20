//
//  ContentAKRouter.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 3/6/22.
//

import Foundation
import Alamofire
import FirebaseCrashlytics


enum ContentAKRouter: RequestProtocol {
    
    case search(filterDic:[String:Any])
    
    
    var baseURLString: String {
        return NetworkConstants.azureContentURL
    }

    var path: String {
        switch self {
        case .search:
            if CurrentSession.share.currentLanguage == "en-UK" {
                return "en-GB" +  "/search"
            }else {
                return CurrentSession.share.currentLanguage +  "/search"
            }
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        default:
            let authValue = CurrentSession.share.serviceToken!.tokenType + " " + CurrentSession.share.serviceToken!.accessToken
            return [ "Authorization": authValue,
                     "Content-Type": "application/json",
                     "X-Organization": NetworkConstants.defaultOrganization,
                     "X-Subscription-Key": NetworkConstants.contentSubscriptionKey,
                     "X-Program-ID": NetworkConstants.programName ]
        }
    }
    
    

    var method: HTTPMethod {
        switch self {
        default:
            return .post
        }
    }

    var paramsEncoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
    var body: Parameters? {
        switch self {
        case .search(let filterDic):
            var noCoordinate = false
            var params = filterDic
//            if let centerLocation = CurrentSession.share.citySelected?.coordinate, !LocationManager.shared.locationIsCity(asCity: CurrentSession.share.citySelected) {
//                if var filters = params["filters"] as? [[String:Any]] {
//                    if let _ = filters.filter({$0["name"] as! String == "Major Market"}).first {
//                        filters.removeAll(where: {$0["name"] as! String == "Major Market"})
//                        if let city = CurrentSession.share.citySelected?.getValueToSendRequest() {
//                            filters.append(contentsOf: [
//                                [
//                                    "name": "Major Market",
//                                    "values": [city]
//                                ]
//                            ])
//                        }
//                    }
//                    params["filters"] = filters
//                    if let comA =  filters.filter({$0["name"] as! String == "Content Type"}).first, let value = comA["values"] as? [String] {
//                        if value == [offerCategoryType] || value == [cruisesCategory] || value == [experiencesCategory] || value == [vacationPackagesCategory] {
//                            noCoordinate = true
//                        }
//                    }
//                }
//                if !noCoordinate {
//                    params["latitude"] = "\(centerLocation.latitude)"
//                    params["longitude"] = "\(centerLocation.longitude)"
//                }
//            }
            
          return params
        }
      }
    

    var params: Parameters? {
        switch self {
        default:
            return nil
        }
    }
    
    var cacheConfig: CacheConfig {
        var cacheTime = 24
        if NetworkConstants.isDisableCache {
            cacheTime = 0
        }
        return CacheConfig(cacheTime: cacheTime, needRemoveWhenLogout: true)
    }
}




