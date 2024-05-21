//
//  EnrollOktaSMSFactor.swift
//  GMA
//
//  Created by Saven Developer on 2/16/22.
//

import Foundation


// MARK: - Model
struct EnrollOktaSMSFactor: Codable {
    let id, factorType, provider, vendorName: String
    let status, created, lastUpdated: String
    let profile: EnrollOktaSMSFactorProfile
    let links: EnrollOktaSMSFactorLinks?

    enum CodingKeys: String, CodingKey {
        case id, factorType, provider, vendorName, status, created, lastUpdated, profile
        case links = "_links"
    }
}

// MARK: - Links
struct EnrollOktaSMSFactorLinks: Codable {
    let resend: [Resend]?
    let activate, linksSelf, user: EnrollOktaSMSFactorActivate?

    enum CodingKeys: String, CodingKey {
        case resend, activate
        case linksSelf = "self"
        case user
    }
}

// MARK: - Activate
struct EnrollOktaSMSFactorActivate: Codable {
    let href: String?
    let hints: EnrollOktaSMSFactorHints?
}

// MARK: - Hints
struct EnrollOktaSMSFactorHints: Codable {
    let allow: [String]?
}

// MARK: - Resend
struct Resend: Codable {
    let name: String
    let href: String
    let hints: EnrollOktaSMSFactorHints
}

// MARK: - Profile
struct EnrollOktaSMSFactorProfile: Codable {
    let phoneNumber: String
}

