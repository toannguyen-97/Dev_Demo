//
//  ActivateSMSFactor.swift
//  GMA
//
//  Created by Saven Developer on 2/16/22.
//

import Foundation

// MARK: - Model
struct ActivateSMSFactor: Codable {
    let id, factorType, provider, vendorName: String
    let status, created, lastUpdated: String
    let profile: ActivateSMSFactorProfile
    let links: ActivateSMSFactorLinks

    enum CodingKeys: String, CodingKey {
        case id, factorType, provider, vendorName, status, created, lastUpdated, profile
        case links = "_links"
    }
}

// MARK: - Links
struct ActivateSMSFactorLinks: Codable {
    let linksSelf, verify, user: ActivateSMSFactorSelfClass

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case verify, user
    }
}

// MARK: - SelfClass
struct ActivateSMSFactorSelfClass: Codable {
    let href: String
    let hints: ActivateSMSFactorHints
}

// MARK: - Hints
struct ActivateSMSFactorHints: Codable {
    let allow: [String]
}

// MARK: - Profile
struct ActivateSMSFactorProfile: Codable {
    let phoneNumber: String
}
