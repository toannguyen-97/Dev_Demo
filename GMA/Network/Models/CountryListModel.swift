//
//  CountryListModel.swift
//  GMA
//
//  Created by Saven Developer on 1/21/22.
//

import Foundation

struct CountryListModel: Codable {
    let codes: [CountryDetail]

    enum CodingKeys: String, CodingKey {
        case codes = "Codes"
    }
}


struct CountryDetail: Codable {
    let alpha2Code, alpha3Code, phoneCountryCode: String?
    let countryCode: Int?
    let countryName, phoneCode: String?
    let flag: String?
    let key: Int?
    let value: String?
}


struct CountryGroupModel: Codable{
    let groupName: String
    let groupDetail: [CountryDetail]
}





