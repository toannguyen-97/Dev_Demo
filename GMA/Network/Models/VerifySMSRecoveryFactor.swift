//
//  VerifySMSRecoveryFactor.swift
//  GMA
//
//  Created by Saven Developer on 2/16/22.
//

import Foundation

// MARK: - Model
struct VerifySMSRecoveryFactor: Codable {
    let stateToken, expiresAt, status, relayState: String
    let recoveryType: String
    let embedded: VerifySMSRecoveryFactorEmbedded
    let links: VerifySMSRecoveryFactorLinks

    enum CodingKeys: String, CodingKey {
        case stateToken, expiresAt, status, relayState, recoveryType
        case embedded = "_embedded"
        case links = "_links"
    }
}

// MARK: - Embedded
struct VerifySMSRecoveryFactorEmbedded: Codable {
    let user: VerifySMSRecoveryFactorUser
    let policy: VerifySMSRecoveryFactorPolicy
}

// MARK: - Policy
struct VerifySMSRecoveryFactorPolicy: Codable {
    let complexity: VerifySMSRecoveryFactorComplexity
    let age: VerifySMSRecoveryFactorAge
}

// MARK: - Age
struct VerifySMSRecoveryFactorAge: Codable {
    let minAgeMinutes, historyCount: Int
}

// MARK: - Complexity
struct VerifySMSRecoveryFactorComplexity: Codable {
    let minLength, minLowerCase, minUpperCase, minNumber: Int
    let minSymbol: Int
    let excludeUsername: Bool
    let excludeAttributes: [String]
}

// MARK: - User
struct VerifySMSRecoveryFactorUser: Codable {
    let id, passwordChanged: String
    let profile: VerifySMSRecoveryFactorProfile
}

// MARK: - Profile
struct VerifySMSRecoveryFactorProfile: Codable {
    let login, firstName, lastName, locale: String
    let timeZone: String
}

// MARK: - Links
struct VerifySMSRecoveryFactorLinks: Codable {
    let next: VerifySMSRecoveryFactorNext
    let cancel: VerifySMSRecoveryFactorCancel
}

// MARK: - Cancel
struct VerifySMSRecoveryFactorCancel: Codable {
    let href: String
    let hints: VerifySMSRecoveryFactorHints
}

// MARK: - Hints
struct VerifySMSRecoveryFactorHints: Codable {
    let allow: [String]
}

// MARK: - Next
struct VerifySMSRecoveryFactorNext: Codable {
    let name: String
    let href: String
    let hints: VerifySMSRecoveryFactorHints
}

