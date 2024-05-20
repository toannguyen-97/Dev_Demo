//
//  NetworkConstants+Extensions.swift
//  GMA
//
//  Created by Hoan Nguyen on 06/05/2022.
//

import Foundation

extension NetworkConstants {
    static var programName:  String {
        if let programDetail = CurrentSession.share.programDetail, let crmProgramName = programDetail.crmProgramName {
            return crmProgramName
        } else {
            return defaultProgramName
        }
    }
    
    static var organizationString:  String {
        if let programDetail = CurrentSession.share.programDetail, let crmCompanyID = programDetail.crmCompanyID {
            return crmCompanyID
        } else {
            return defaultOrganization
        }
    }
    
    static var oktaClientAuthorization : String {
        let authStr = oktaClientId + ":" + oktaClientSecret
        let utf8str = authStr.data(using: .utf8)
        if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
            return "Basic " + base64Encoded
        }
        return ""
    }
    
    static var pmaAuthorization : String {
        let authStr = pmaAuthAccID + ":" + pmaAuthPas
        let utf8str = authStr.data(using: .utf8)
        if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
            return "Basic " + base64Encoded
        }
        return ""
    }
}
