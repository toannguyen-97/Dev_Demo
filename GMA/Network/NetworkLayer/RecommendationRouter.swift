//
//  RecommendationRouter.swift
//  GMA
//
//  Created by Hoan Nguyen on 12/04/2022.
//

import Foundation
import Alamofire


enum RecommendationRouter: RequestProtocol {
    
    case getContent(filterDic:[String:Any])
    
    
    
    var baseURLString: String {
        return  NetworkConstants.azureContentPrioritizationURL
    }
    
    var path: String {
        switch self {
        case .getContent:
           return  "recommendation"
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
        case .getContent(let filterDic):
            var dic =  filterDic
            dic["ClientId"] = NetworkConstants.organizationString
            dic["lang_code"] = CurrentSession.share.currentLanguage
            dic["SourceSystem"] = "API"
            return dic
        default:
            return nil
        }
    }
    
    var cacheConfig: CacheConfig {
        var cacheTime = 24
        if NetworkConstants.isDisableCache {
            cacheTime = 0
        }
        return CacheConfig(cacheTime: cacheTime, needRemoveWhenLogout: false)
    }
}
