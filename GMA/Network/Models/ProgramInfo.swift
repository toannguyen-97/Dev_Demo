//
//  ProgramInfo.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/21/22.
//

import Foundation


struct ProgramInfo: Codable {
    let programDetails: [ProgramDetail]
}

// MARK: - ProgramDetail
struct ProgramDetail: Codable {
    let clientName, phoneNumber, emailAddress, subClientName: String?
    let crmCompanyID, crmProgramName: String?
    let status: Int
    let tier, expiryDate, conciergeContactEmailAddress, country: String?
    let websiteLogoURL: String?
    let websiteFaviconURL: String?
    let liveChatAccountNumber: String?
    let extraInfo: ExtraInfo?

    enum CodingKeys: String, CodingKey {
        case clientName, phoneNumber, emailAddress, subClientName
        case crmCompanyID = "crmCompanyId"
        case crmProgramName, status, tier, expiryDate, conciergeContactEmailAddress, country
        case websiteLogoURL = "websiteLogoUrl"
        case websiteFaviconURL = "websiteFaviconUrl"
        case liveChatAccountNumber, extraInfo
    }
    
    func getTemperatureUnit()-> String {
        if let temp = self.extraInfo?.temperature{
            return temp
        }
        return TemperatureUnit.C.stringValue
    }
    
    func getDistanceUnit()-> String {
        if let distanceUnit = self.extraInfo?.distanceUnit {
            return distanceUnit
        }
        return DistanceUnit.Km.stringValue
    }
    
    func getTopCategories() -> [[String:Any]] {
        if let dic = self.websiteLogoURL?.toDictionary() {
            if let top_categories = dic["top_categories"] as? [[String:Any]] {
                return top_categories
            }
        }
        return []
    }
}

// MARK: - ExtraInfo
struct ExtraInfo: Codable {
    let temperature, distanceUnit, language, reportGroupProgramName: String?
    let entryPoint, appInstallationID, currency: String?

    enum CodingKeys: String, CodingKey {
        case temperature, distanceUnit, language, reportGroupProgramName, entryPoint, currency
        case appInstallationID = "appInstallationId"
    }
}
