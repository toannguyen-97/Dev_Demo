//
//  EnrollEmailFactor.swift
//  GMA
//
//  Created by Saven Developer on 2/15/22.
//

import Foundation


// MARK: - Model
struct EnrollEmailFactor: Codable {
    let id, factorType, provider, vendorName: String
    let status: String
    let profile: EnrollEmailProfile
    let links: Links

    enum CodingKeys: String, CodingKey {
        case id, factorType, provider, vendorName, status, profile
        case links = "_links"
    }
}

// MARK: - Links
struct Links: Codable {
    let linksSelf, verify, user: SelfClass

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case verify, user
    }
}

// MARK: - SelfClass
struct SelfClass: Codable {
    let href: String
    let hints: Hints
}

// MARK: - Hints
struct Hints: Codable {
    let allow: [String]
}

// MARK: - Profile
struct EnrollEmailProfile: Codable {
    let email: String
}

