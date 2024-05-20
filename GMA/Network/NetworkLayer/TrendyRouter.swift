//
//  TrendyRouter.swift
//  GMA
//
//  Created by Hoan Nguyen on 16/03/2022.
//

import Foundation
import Alamofire


enum TrendyRouter: RequestProtocol {
    
    case getTrendyCities
    case getTrendyContent(city:String)
    
    
    var baseURLString: String {
        return NetworkConstants.azureContentPrioritizationURL
    }
    
    var path: String {
        switch self {
        case .getTrendyCities:
            return "trendy-city"
        case .getTrendyContent:
            return "trendy-api"
        }
    }
    
    var headers: HTTPHeaders? {
        let authValue = CurrentSession.share.serviceToken!.tokenType + " " + CurrentSession.share.serviceToken!.accessToken
        return [ "Authorization": authValue,
                 "Content-Type": "application/json",
                 "X-Organization": NetworkConstants.defaultOrganization,
                 "X-Subscription-Key": NetworkConstants.contentSubscriptionKey,
                 "X-Program-ID": NetworkConstants.programName ]
    }
    
    var method: HTTPMethod {
        switch self {
        case .getTrendyContent:
            return .get
        default:
            return .get
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
        default:
            return nil
        }
    }
    
    
    var params: Parameters? {
        switch self {
        case .getTrendyCities:
            return ["lang_code":  CurrentSession.share.currentLanguage, "duration": 6, "category": "Default"]
        case .getTrendyContent(let cityName):
            return [
                "req_city": cityName,
                "lang_code": CurrentSession.share.currentLanguage,
                "ak_category": "Dining,Hotels,Nightlife,Attractions,Cruises,Experiences,Vacation Packages,Spas"
            ]
        }
    }
    
    var cacheConfig: CacheConfig {
        var cacheTime = 24
        if NetworkConstants.isDisableCache {
            cacheTime = 0
        }
        switch self {
        default:
            return CacheConfig(cacheTime: cacheTime, needRemoveWhenLogout: false)
        }
    }
}
