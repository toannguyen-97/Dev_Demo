//
//  CountryListRouter.swift
//  GMA
//
//  Created by Saven Developer on 1/21/22.
//

import Foundation
import Alamofire

enum AspireRouter: RequestProtocol{
    
    case getCountryList(String)
    case generateJWT
    case getFlightInfo(flightNumber: String, flightDate: String)
    case getSupportAirports
    
    var baseURLString: String{
        switch self {
        case .getCountryList:
            return NetworkConstants.countryListBaseURL
        case .generateJWT:
            return NetworkConstants.jwtGeneratorBaseURL
        case .getFlightInfo:
            return NetworkConstants.flightInfoBaseURL
        case .getSupportAirports:
            return NetworkConstants.airportListBaseURL
        }
    }
    
    var path: String{
        return ""
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCountryList, .getFlightInfo, .getSupportAirports:
            return .get
        default:
            return .post
        }
    }
    
    var headers: HTTPHeaders?{
        switch self {
        case .generateJWT:
            let authValue = CurrentSession.share.serviceToken!.tokenType + " " + CurrentSession.share.serviceToken!.accessToken
            return [ "Authorization": authValue,
                     "X-Organization" : NetworkConstants.organizationString,
                     "X-Subscription-Key": NetworkConstants.subscriptionKey
            ]
        default:
            return nil
        }
    }
    
    var params: Parameters?{
        switch self {
        case .getFlightInfo(let flightNumber,let flightDate):
            return [ "a": "AspireLifeStyleTest",
                     "b" : "Thenhfskjm$AB88",
                     "acid": flightNumber,
                     "depdate": flightDate
            ]
        default:
            return nil
        }
    }
    
    
    var body: Parameters?{
        switch self {
        case .generateJWT:
            if let aspireProfile = CurrentSession.share.aspireProfile, let fName = aspireProfile.firstName, let lName = aspireProfile.lastName, let email = aspireProfile.emails?.first?.emailAddress, let phoneN = aspireProfile.phones?.first?.phoneNumber, let phoneCode = aspireProfile.phones?.first?.phoneCountryCode {
                return [
                    "partyId": aspireProfile.partyID,
                    "firstName": fName,
                    "lastName": lName,
                    "email": email,
                    "phoneNumber": phoneCode + phoneN
                ]
            }else {
                return nil
            }
        default:
            return nil
        }
    }
    
    var paramsEncoding: ParameterEncoding{
        return JSONEncoding.default
    }
    
    var cacheConfig: CacheConfig {
        switch self {
        case .getCountryList:
            return CacheConfig(cacheTime: 7*24, needRemoveWhenLogout: false)
        case .generateJWT,.getFlightInfo,.getSupportAirports:
            return CacheConfig(cacheTime: 0, needRemoveWhenLogout: false)
        }
    }
    
}

