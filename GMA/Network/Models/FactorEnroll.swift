//
//  FactorEnroll.swift
//  GMA
//
//  Created by Hoan Nguyen on 16/02/2022.
//

import Foundation

struct FactorEnrolls : Codable {
    let factorEnrolls : [FactorEnroll]
}

// MARK: - Welcome
struct FactorEnroll: Codable {
    let enrollment, provider, vendorName: String?
    let status, factorType: String
    let embedded: Embedded?

    enum CodingKeys: String, CodingKey {
        case enrollment, provider, vendorName
        case status,  factorType
        case embedded = "_embedded"
    }
}

// MARK: - Embedded
struct Embedded: Codable {
    let phones: [FactorPhone]?
}

// MARK: - Phone
struct FactorPhone: Codable {
    let id: String
    let profile: FactorProfile?
    let status: String
}

// MARK: - Profile
struct FactorProfile: Codable {
    let phoneNumber: String
}
