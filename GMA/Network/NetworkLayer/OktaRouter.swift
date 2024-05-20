//
//  NetworkRouter.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/12/22.
//

import Foundation
import Alamofire


enum OktaRouter: RequestProtocol {
    
    case verifyPhone(String)
    case verifyEmail(String)
    case getToken(username:String, password:String)
    case refreshToken(refreshToken:String)
    case revokeToken(String)
    case getProfile(email:String)
    case setPassword(email:String, Password: String)
    case enrollEmailFactorAutomatically(userID: String, email: String)
    case getListFactorEnroll(userID: String)
    case enrollOktaSMSFactor(userID: String, phoneNumber: String)
    case forgotPasswordWithSMSFactor(userName: String)
    case resetPassword(password: String, stateToken: String) //Forgot password by sms
    case activateSmsFactor(userID: String, factorID: String, passcode: String)
    case resendOTP(stateToken: String)
    case verifySMSRecoveryFactor(stateToken: String, passcode: String)
    case resend(phoneNumber: String, userID: String, factorID: String)
    case changePassword(email:String, newP:String, oldP: String)
    case updatePhone(userID: String, phoneNumber: String)
    case deleteFactor(userID: String, factorID: String)
    
    var baseURLString: String {
        return NetworkConstants.oktaBaseURL
    }

    var path: String {
        switch self {
        case .getToken, .refreshToken:
            return "oauth2/default/v1/token"
        case .revokeToken:
            return "oauth2/default/v1/revoke"
        case .verifyEmail:
            return "/verification/username/"
        case .verifyPhone:
            return "/verification/phone/"
        case .getProfile(let email):
            return "api/v1/users/[@email]".withReplacedCharacters("[@email]", by: NetworkConstants.organizationString + "_" + email)
        case .setPassword(let email,  _):
            return "api/v1/users/[@email]".withReplacedCharacters("[@email]", by: NetworkConstants.organizationString + "_" + email) + "?strict=true"
        case .enrollEmailFactorAutomatically(let userID, _):
            return "api/v1/users/[@user_id]/factors?activate=true".withReplacedCharacters("[@user_id]", by: userID)
        case .getListFactorEnroll(let userId):
            return "/api/v1/users/\(userId)/factors/catalog"
        case .enrollOktaSMSFactor(let userId, _):
            return "api/v1/users/\(userId)/factors"
        case .forgotPasswordWithSMSFactor(_):
            return "api/v1/authn/recovery/password"
        case .resetPassword(_, _):
            return "api/v1/authn/credentials/reset_password?strict=true"
        case .activateSmsFactor(userID: let userID, factorID: let factorID, _):
            return "api/v1/users/\(userID)/factors/\(factorID)/lifecycle/activate"
        case .resendOTP:
            return "api/v1/authn/recovery/factors/SMS/resend"
        case .verifySMSRecoveryFactor:
            return "api/v1/authn/recovery/factors/sms/verify"
        case .resend( _ ,let userID ,let factorID):
            return "api/v1/users/\(userID)/factors/\(factorID)/resend"
        case .changePassword(let email, _, _):
            return "api/v1/users/[@email]/credentials/change_password".withReplacedCharacters("[@email]", by: NetworkConstants.organizationString + "_" + email)
        case .updatePhone(let userID, _):
            return "api/v1/users/[@user_id]/factors?updatePhone=true".withReplacedCharacters("[@user_id]", by: userID)
        case .deleteFactor(let userID, let factorID):
            return "api/v1/users/\(userID)/factors/\(factorID)"
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .getToken, .refreshToken, .revokeToken:
            return [
                "Authorization": NetworkConstants.oktaClientAuthorization,
                "Content-Type": "application/x-www-form-urlencoded"]
        case .getProfile, .setPassword, .enrollEmailFactorAutomatically, .enrollOktaSMSFactor, .activateSmsFactor, .resendOTP, .resend, .updatePhone:
            return [
                "Authorization": NetworkConstants.oktaTokenType + " " + NetworkConstants.oktaTokenSecret,
                "Content-Type": "application/json"]
        case .deleteFactor:
            return [ "Authorization": NetworkConstants.oktaTokenType + " " + NetworkConstants.oktaTokenSecret,"Accept": "application/json", "Content-Type": "application/json"]
        case .forgotPasswordWithSMSFactor, .resetPassword, .verifySMSRecoveryFactor:
            return ["Accept": "application/json", "Content-Type": "application/json"]
        default:
            return [
                "Authorization": NetworkConstants.oktaTokenType + " " + NetworkConstants.oktaTokenSecret,
                "Content-Type": "application/json"]
        }
    }
    
    

    var method: HTTPMethod {
        switch self {
        case .getToken, .refreshToken, .setPassword, .enrollEmailFactorAutomatically, .enrollOktaSMSFactor,.updatePhone, .forgotPasswordWithSMSFactor, .resetPassword, .activateSmsFactor, .resendOTP, .verifySMSRecoveryFactor, .resend:
            return .post
        case .getProfile, .getListFactorEnroll:
            return .get
        case .deleteFactor:
            return .delete
        default:
            return .post
        }
    }

    var paramsEncoding: ParameterEncoding {
        switch self {
        case .verifyPhone:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var body: Parameters? {
        switch self {
        case .setPassword( _, let password):
          return ["credentials": ["password" : [ "value": password]]]
        case .enrollEmailFactorAutomatically( _, let email):
            return ["factorType": "email","provider": "OKTA","profile": [  "email": email]]
        case .enrollOktaSMSFactor(_, let phoneNumber), .updatePhone(_, let phoneNumber):
            return ["factorType": "sms","provider": "OKTA","profile": ["phoneNumber": phoneNumber]]
        case .forgotPasswordWithSMSFactor(let userName):
            return [
                "username": userName,
                "factorType": "SMS",
                "relayState": "/myapp/some/deep/link/i/want/to/return/to"
              ]
        case .resetPassword(let password, let stateToken):
            return [
                "stateToken": stateToken,
                "newPassword": password
              ]
        case .activateSmsFactor( _, _, let passcode):
            return [ "passCode": passcode]
        case .resendOTP(let stateToken):
            return ["stateToken" : stateToken]
        case .verifySMSRecoveryFactor(let stateToken, let passcode):
            return ["stateToken": stateToken,"passCode": passcode]
        case .resend(let phoneNumber,_,_):
            return ["factorType": "sms","provider": "OKTA","profile": ["phoneNumber": phoneNumber]]
        case .changePassword(_,let newP,let  oldP):
            return [
                "oldPassword": [
                    "value":  oldP
                ],
                "newPassword": [
                    "value": newP
                ]
            ]
        case .revokeToken(let token):
            return ["token": token]
        case .getToken(let username, let password):
            return ["username": username, "password": password, "grant_type":"password", "scope": "openid offline_access"]
        case .refreshToken(let refreshTk):
            return ["grant_type":"refresh_token", "scope":"openid offline_access", "refresh_token": refreshTk]
        default:
          return nil
        }
      }
    

    var params: Parameters? {
        return nil
    }
    
    var cacheConfig: CacheConfig {
        return CacheConfig(cacheTime: 0, needRemoveWhenLogout: true)
    }
}




