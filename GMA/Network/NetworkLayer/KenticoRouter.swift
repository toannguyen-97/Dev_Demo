//
//  KenticoRouter.swift
//  GMA
//
//  Created by Saven Developer on 3/7/22.
//

import Foundation
import Alamofire


enum KenticoRouter: RequestProtocol {
    
    case getContent(codeName: String, depth: Int)
    
    
    var baseURLString: String {
        return NetworkConstants.kenticoBaseURL
    }

    var path: String {
        switch self {
        case .getContent(let codeName, _):
            return "\(NetworkConstants.kenticoProjectID)/items/\(codeName)"
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .getContent:
            let authValue = "Bearer ew0KICAiYWxnIjogIkhTMjU2IiwNCiAgInR5cCI6ICJKV1QiDQp9.ew0KICAianRpIjogIjAzYjVkYjNjZjc2YTQxOWU5ZTEwNTQ3YzIzM2ZiZjM0IiwNCiAgImlhdCI6ICIxNjQwNjE0MTU5IiwNCiAgImV4cCI6ICIxOTg2MjE0MTU5IiwNCiAgInZlciI6ICIxLjAuMCIsDQogICJwcm9qZWN0X2lkIjogImEyZWNlMzY5ZWFkNjAwZDJmZmEzMmI5ZmNhMzM0NGUwIiwNCiAgImF1ZCI6ICJkZWxpdmVyLmtlbnRpY29jbG91ZC5jb20iDQp9.qQ9pTcFj43ZobI2K0wIjEECEG4NENfoAluANTNYaqfY"
            return [ "Authorization": authValue]
        }
    }
    
    

    var method: HTTPMethod {
        switch self {
        case .getContent:
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
        case .getContent(_, let depth):
            return ["language": CurrentSession.share.currentLanguage, "depth": "\(depth)"]
        }
    }
    
    var cacheConfig: CacheConfig {
        var cacheTime: Int = 24
        switch self {
        case.getContent(let codeName, _):
            if codeName == "app___splash_screen" {
                cacheTime = 0
            }
        }
        return CacheConfig(cacheTime: cacheTime, needRemoveWhenLogout: false)
    }
}

