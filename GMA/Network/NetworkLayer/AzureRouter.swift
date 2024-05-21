//
//  AzureRouter.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/13/22.
//

import Foundation
import Alamofire
import Adyen

enum AzureRouter: RequestProtocol {
    case getProgramInfo(bin: String)
    case createCustomer(customerInfo: [String: Any])
    case getProfile
    case updateProfile(AspireProfile)
    case getT
    case generateEmailOTP(email: String, type: String)
    case validateOTP(email: String, otp: String)
    case getRequestHistory
    case createRequest(requestdata: CreateRequest)
    case updateRequest(requestdata: CreateRequest)
    case cancelRequest(request: RequestItem)
    case limoGetQuote(request: GetQuoteRequest)
    case limoMakeBooking(request: MakeBookingRequest)
    case limoGetBooking(bookingId: String)
    var baseURLString: String {
        switch self {
        case .getProgramInfo:
            return NetworkConstants.azureProgramInfoURL
        case .createCustomer:
            return NetworkConstants.azurecreateCustomerURL
        case .generateEmailOTP:
            return NetworkConstants.azureGenerateEmailOTPURL
        case.validateOTP:
            return NetworkConstants.azureValidateOTPURL
        case .getProfile, .updateProfile:
            return NetworkConstants.azureUserProfileURL
        case .getRequestHistory:
            return NetworkConstants.azureRequestHistoryURL
        case .createRequest, .cancelRequest, .updateRequest:
            return NetworkConstants.azureCaseURL
        case .limoGetQuote:
            return NetworkConstants.azureLimoQuoteURL
        case .limoMakeBooking:
            return NetworkConstants.azureLimoMakebookingURL
        case .limoGetBooking:
            return NetworkConstants.azureLimoGetBookingURL

        default:
            return NetworkConstants.azureBaseURL
        }
    }
    
    var path: String {
        switch self {
        default:
            return ""
        }
    }
    
    var headers: HTTPHeaders? {
        
        switch self {
            case .getRequestHistory:
                let authValue = CurrentSession.share.userToken!.tokenType + " " + CurrentSession.share.userToken!.accessToken
                let subkey = NetworkConstants.isProduction ? NetworkConstants.subscriptionKey : "5a9e31bbaa5d481aba34482220a75517"
                return ["Authorization": authValue,
                        "X-Program-Id": NetworkConstants.programName,
                        "Content-Type": "application/json",
                        "X-Organization": NetworkConstants.defaultOrganization,
                        "X-Subscription-Key": subkey]
            case .getProgramInfo:
                let authValue = CurrentSession.share.serviceToken!.tokenType + " " + CurrentSession.share.serviceToken!.accessToken
                return ["Authorization": authValue,
                        "Content-Type": "application/json",
                        "X-Organization": NetworkConstants.defaultOrganization,
                        "X-Subscription-Key": NetworkConstants.subscriptionKey]
                
            case .createCustomer:
                let authValue = CurrentSession.share.serviceToken!.tokenType + " " + CurrentSession.share.serviceToken!.accessToken
                return ["Authorization": authValue,
                        "X-Organization": NetworkConstants.organizationString,
                        "Content-Type": "application/json",
                        "X-Program-Id": NetworkConstants.programName,
                        "X-Subscription-Key": NetworkConstants.subscriptionKey]
                
            case .generateEmailOTP:
                let authValue = CurrentSession.share.serviceToken!.tokenType + " " + CurrentSession.share.serviceToken!.accessToken
                return ["Authorization": authValue,
                        "X-Organization": NetworkConstants.organizationString,
                        "Content-Type": "application/json",
                        "X-Program-Id": NetworkConstants.programName,
                        "X-Subscription-Key": NetworkConstants.subscriptionKey]
                
            case .validateOTP:
                let authValue = CurrentSession.share.serviceToken!.tokenType + " " + CurrentSession.share.serviceToken!.accessToken
                return ["Authorization": authValue,
                        "X-Organization": NetworkConstants.organizationString,
                        "Content-Type": "application/json",
                        "X-Subscription-Key": NetworkConstants.subscriptionKey]
            case .getProfile:
                let authValue = CurrentSession.share.userToken!.tokenType + " " + CurrentSession.share.userToken!.accessToken
                return ["Authorization": authValue,
                        "Content-Type": "application/json",
                        "X-Organization": NetworkConstants.organizationString,
                        "X-Program-Id": NetworkConstants.programName,
                        "X-Subscription-Key": NetworkConstants.subscriptionKey]
            case .updateProfile(let profile):
                let authValue = CurrentSession.share.userToken!.tokenType + " " + CurrentSession.share.userToken!.accessToken
                return ["Authorization": authValue,
                        "Content-Type": "application/json",
                        "X-Organization": NetworkConstants.organizationString,
                        "X-Program-Id": NetworkConstants.programName,
                        "X-Subscription-Key": NetworkConstants.subscriptionKey,
                        "X-Party-Id": profile.partyID]
            case .createRequest:
                let authValue = CurrentSession.share.userToken!.tokenType + " " + CurrentSession.share.userToken!.accessToken
                return ["Authorization": authValue,
                        "X-Program-Id": NetworkConstants.programName,
                        "X-Organization": NetworkConstants.organizationString,
                        "X-Subscription-Key": NetworkConstants.contentSubscriptionKey,
                        "Action": "New"]
            case .updateRequest:
                let authValue = CurrentSession.share.userToken!.tokenType + " " + CurrentSession.share.userToken!.accessToken
                return ["Authorization": authValue,
                        "X-Program-Id": NetworkConstants.programName,
                        "X-Organization": NetworkConstants.organizationString,
                        "X-Subscription-Key": NetworkConstants.contentSubscriptionKey,
                        "Action": "Update"]
            case .cancelRequest:
                let authValue = CurrentSession.share.userToken!.tokenType + " " + CurrentSession.share.userToken!.accessToken
                return ["Authorization": authValue,
                        "X-Program-Id": NetworkConstants.programName,
                        "X-Organization": NetworkConstants.organizationString,
                        "X-Subscription-Key": NetworkConstants.contentSubscriptionKey,
                        "Action": "Cancel"]
            case .limoGetQuote:
                let subkey = NetworkConstants.subscriptionKey
                let authValue = CurrentSession.share.userToken!.tokenType + " " + CurrentSession.share.userToken!.accessToken
                return ["Authorization": authValue,
                        "X-App-Id": subkey,
                        "X-Organization": NetworkConstants.organizationString,
                        "X-Program-Id": NetworkConstants.programName,
                        "Content-Type": "application/json"]
            case .limoMakeBooking:
                let subkey = NetworkConstants.subscriptionKey
                let authValue = CurrentSession.share.userToken!.tokenType + " " + CurrentSession.share.userToken!.accessToken
                return ["Authorization": authValue,
                        "Content-Type": "application/json",
                        "X-App-Id": subkey,
                        "X-Organization": NetworkConstants.organizationString,
                        "X-Program-Id": NetworkConstants.programName,
                        "X-PartyId": "",
                        "X-CaseId": "",
                        "X-RequestId": ""]
        case .limoGetBooking:
            let subkey = NetworkConstants.subscriptionKey
            let authValue = "\(CurrentSession.share.userToken?.tokenType ?? "") \(CurrentSession.share.userToken?.accessToken ?? "")"
            return ["Authorization": authValue,
                    "Content-Type": "application/json",
                    "X-App-Id": subkey,
                    "X-Organization": NetworkConstants.organizationString,
                    "X-Program-Id": NetworkConstants.programName,]
        
            default:
                return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .getProgramInfo, .createCustomer, .generateEmailOTP, .validateOTP:
                return .post
            case .getProfile:
                return .get
            case .updateProfile, .cancelRequest, .updateRequest:
                return .put
            case .limoGetBooking:
                return .get
            default:
                return .post
        }
    }
    
    var paramsEncoding: ParameterEncoding {
        switch self {
            case .getProgramInfo:
                return URLEncoding.default
            default:
                return JSONEncoding.default
        }
    }
    
    var body: Parameters? {
        switch self {
            case .getProgramInfo(let bin):
                return ["verification": bin, "verificationType": "BIN"]
            case .createCustomer(let customerInfo):
                return customerInfo
            case .generateEmailOTP(let email, let type):
//                return ["secretKey": RegisterData.share.secretKey!, "type": type, "email": email, "localeId": CurrentSession.share.currentLanguage]
            return [:]
            case .validateOTP(let email, let otp):
//                return ["secretKey": RegisterData.share.secretKey!, "OTP": otp, "email": email]
            return [:]
            case .updateProfile(let profile):
                return aspireProfileToPostJson(profile: profile)
            case .getRequestHistory:
                guard let partyID = CurrentSession.share.aspireProfile?.partyID else { return [:] }
                return ["partyId": partyID]
            case .createRequest(let requestData), .updateRequest(let requestData):
                do {
                    requestData.dropAddress = requestData.address
                    let data = try JSONEncoder().encode(requestData)
                    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return [:] }
                    print("Booking  ============================================================ \n")
                    print("Request Type  ============================================================ \(requestData.requestType ?? "")")
                    print(dictionary)
                    return dictionary
                } catch {
                    print(error)
                    return [:]
                }
            case .cancelRequest(let requestItem):
                return ["partyId": CurrentSession.share.aspireProfile?.partyID ?? "",
                        "caseId": requestItem.caseID ?? "",
                        "requestId": requestItem.requestID ?? "",
                        "sourceSystem": "Concierge",
                        "contactMethod": "Digital",
                        "contactSource": "Website & Phone"]
            case .limoGetQuote(let request):
                return request.toJsonString()
            case .limoMakeBooking(let request):
                return request.toJsonString()
            default:
                return nil
        }
    }
    
    var params: Parameters? {
        switch self {
        case .limoGetBooking(let bookingId):
            return ["requestReferenceId": bookingId]
            default:
                return nil
        }
    }
    
    var cacheConfig: CacheConfig {
        return CacheConfig(cacheTime: 0, needRemoveWhenLogout: true)
    }
}


fileprivate extension AzureRouter {
    
    func aspireProfileToPostJson(profile: AspireProfile) -> Parameters {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(profile)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return [:] }
            let mutableDic = NSMutableDictionary(dictionary: dictionary)
            dictionary.keys.forEach { key in
                if let str = dictionary[key] as? String, str == "" {
                    mutableDic.removeObject(forKey: key)
                }
                if let dics = dictionary[key] as? [[String: Any]] {
                    let temarray = NSMutableArray()
                    dics.forEach { (item) in
                        var dic = item
                        dic.keys.forEach { subKey in
                            if let str = dic[subKey] as? String, str == "" {
                                dic.removeValue(forKey: subKey)
                            }
                        }
                        if dic.keys.count > 0 {
                            temarray.add(dic)
                        }
                    }
                    
                    mutableDic.removeObject(forKey: key)
                    mutableDic.setValue(temarray, forKey: key)
                }
            }
            let verificationMetadata = ["verificationMetadata": ["accessCode": CurrentSession.share.aspireProfile!.getAccessCode()]]
            mutableDic.addEntries(from: verificationMetadata)
            return mutableDic as! Parameters
        } catch {
            print(error)
            return [:]
        }
    }
}
