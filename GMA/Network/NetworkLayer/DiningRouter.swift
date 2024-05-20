//
//  DiningRouter.swift
//  GMA
//
//  Created by Saven Developer on 6/15/22.
//

import Foundation
import Alamofire


enum DiningRouter: RequestProtocol {
    
    case diningList(filterDic:[String:Any])
    case diningDetail(diningID: String)
    case diningCreateReservation(dic:[String:Any])
    case diningUpdateReservation(caseId: String, requestId: String, dic:[String:Any])
    case cancelReservation(item: RequestItem)
   
    var baseURLString: String {
        switch self {
        case .diningList, .diningDetail:
            return NetworkConstants.azureDiningContentURL
        case .diningCreateReservation, .diningUpdateReservation, .cancelReservation:
            return NetworkConstants.azureDiningReservationURL
        }
    }

    var path: String {
        switch self {
        case .diningList(let dic):
            if dic.keys.contains("date") && dic.keys.contains("time") {
                return "RestaurantsAndAvailability"
            }
            return "Restaurants"
        case .diningDetail(let diningID):
            return "restaurantDetails/\(diningID)"
        case .diningCreateReservation, .diningUpdateReservation:
            return ""
        case .cancelReservation(let item):
            let reservationId = (item.popularVendor ?? "") + "_" + (item.confirmationNo ?? "")
            return "\(reservationId)"
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .diningCreateReservation:
            let authValue = CurrentSession.share.userToken!.tokenType + " " + CurrentSession.share.userToken!.accessToken
            let partyID = CurrentSession.share.aspireProfile?.partyID ?? ""
            return [
                "Authorization": authValue,
                "Content-Type": "application/json",
                "X-App-Id": NetworkConstants.xAppId,
                "X-Organization" : NetworkConstants.organizationString,
                "X-Program-Id": NetworkConstants.programName,
                "X-PartyId": partyID,
                "Locale": CurrentSession.share.currentLanguage
            ]
        case .diningUpdateReservation(let caseId, let requestId, _):
            let authValue = CurrentSession.share.userToken!.tokenType + " " + CurrentSession.share.userToken!.accessToken
            let partyID = CurrentSession.share.aspireProfile?.partyID ?? ""
            return [
                "Authorization": authValue,
                "Content-Type": "application/json",
                "X-App-Id": NetworkConstants.xAppId,
                "X-Organization" : NetworkConstants.organizationString,
                "X-Program-Id": NetworkConstants.programName,
                "X-PartyId": partyID,
                "Locale": CurrentSession.share.currentLanguage,
                "X-CaseId": caseId,
                "X-RequestId": requestId
            ]
        case .cancelReservation(let item):
            let authValue = CurrentSession.share.userToken!.tokenType + " " + CurrentSession.share.userToken!.accessToken
            let partyID = CurrentSession.share.aspireProfile?.partyID ?? ""
            return [
                "Authorization": authValue,
                "Content-Type": "application/json",
                "X-App-Id": NetworkConstants.xAppId,
                "X-Organization" : NetworkConstants.organizationString,
                "X-Program-Id": NetworkConstants.programName,
                "X-PartyId": partyID,
                "X-CaseId": item.caseID ?? "",
                "X-RequestId": item.requestID ?? ""
            ]
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
        case .diningDetail:
            return .get
        case .diningUpdateReservation:
            return .put
        case .cancelReservation:
            return .delete
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
        case .diningList(let filterDic):
            var params = filterDic
//            if let centerLocation = CurrentSession.share.citySelected?.coordinate, !LocationManager.shared.locationIsCity(asCity: CurrentSession.share.citySelected) {
//                params.removeValue(forKey: "city")
//                var distance = 100
//                var unitStr = "miles"
//                if let dics = params["distance"] as? [String: Any] {
//                    if let dist = dics["unit"] as? Int {
//                        distance = dist
//                    }
//                    if let measurement = dics["measurement"] as? String {
//                        unitStr = measurement
//                    }
//                }
//                params["distance"] = [
//                    "longitude" : "\(centerLocation.longitude)",
//                    "latitude" : "\(centerLocation.latitude)",
//                    "unit" : distance,
//                    "measurement": unitStr
//                ]
//                if let locationCity = CurrentSession.share.citySelected?.getValueToSendRequest(), (params.keys.contains("date") && params.keys.contains("time")) {
//                    params["city"] = locationCity
//                }
//            }
            params["locale"] = [CurrentSession.share.currentLanguage]
            return params
        case .diningCreateReservation(let dic), .diningUpdateReservation(_, _, let dic):
            return dic
        default:
            return nil
        }
      }
    

    var params: Parameters? {
        switch self {
        case .cancelReservation:
            return [
                "sourceSystem": "Self-Serve",
                "contactMethod": "Phone",
                "contactSource": "Website",
                "notificationPreferences": "Email",
                "localeId": CurrentSession.share.currentLanguage,
            ]
            
        default:
            return nil
        }
    }
    
    var cacheConfig: CacheConfig {
        var cacheTime = 24
        if NetworkConstants.isDisableCache {
            cacheTime = 0
        }
        switch self {
        case .diningCreateReservation, .cancelReservation, .diningUpdateReservation :
            return CacheConfig(cacheTime: 0, needRemoveWhenLogout: false)
        case .diningList(let dic):
            if dic.keys.contains("date") && dic.keys.contains("time") {
                return CacheConfig(cacheTime: 0, needRemoveWhenLogout: false)
            }
            return CacheConfig(cacheTime: cacheTime, needRemoveWhenLogout: false)
        default:
            return CacheConfig(cacheTime: 0, needRemoveWhenLogout: false)
        }
    }
}





