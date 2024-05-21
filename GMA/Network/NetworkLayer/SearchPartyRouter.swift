//
//  PMARouter.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/25/22.
//

import Foundation
import Alamofire


enum SearchPartyRouter: RequestProtocol {
    
    case findPMAPartyID(email:String)
    case getPMAUserProfile(partyID:String)
    
    var baseURLString: String {
        return NetworkConstants.azureSearchPartyURL
    }
    var path: String {
        return ""
    }

    
    var headers: HTTPHeaders? {
        let authValue = CurrentSession.share.serviceToken!.tokenType + " " + CurrentSession.share.serviceToken!.accessToken
        switch self {
        case .findPMAPartyID:
            return [ "Authorization": authValue,
                     "X-Organization" : NetworkConstants.organizationString,
                     "X-Subscription-Key": NetworkConstants.subscriptionKey,
                     "Content-Type": "application/json"]
        case .getPMAUserProfile:
            return [ "Authorization": authValue,
                     "X-Organization" : NetworkConstants.organizationString,
                     "X-Subscription-Key": NetworkConstants.subscriptionKey,
                     "Content-Type": "application/json"]
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var paramsEncoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
    var body: Parameters? {
        return nil
    }
    
    var params: Parameters? {
        switch self {
        case .findPMAPartyID(let email):
            return [
                "emailAddress": email
            ]
        case .getPMAUserProfile(let partyID):
            return [
                "id": partyID
            ]
        }
    }
    
    var cacheConfig: CacheConfig {
        return CacheConfig(cacheTime: 0, needRemoveWhenLogout: true)
    }
}
