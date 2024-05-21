//
//  ResetPassword.swift
//  GMA
//
//  Created by Saven Developer on 2/16/22.
//

import Foundation

// MARK: - Model
struct ResetPassword: Codable {
    let expiresAt, status, relayState, sessionToken: String
    let embedded: ResetPasswordEmbedded
    let links: ResetPasswordLinks

    enum CodingKeys: String, CodingKey {
        case expiresAt, status, relayState, sessionToken
        case embedded = "_embedded"
        case links = "_links"
    }
}

// MARK: - Embedded
struct ResetPasswordEmbedded: Codable {
    let user: ResetPasswordUser
}

// MARK: - User
struct ResetPasswordUser: Codable {
    let id, passwordChanged: String
    let profile: ResetPasswordProfile
}

// MARK: - Profile
struct ResetPasswordProfile: Codable {
    let login, firstName, lastName, locale: String
    let timeZone: String
}

// MARK: - Links
struct ResetPasswordLinks: Codable {
    let cancel: ResetPasswordCancel
}

// MARK: - Cancel
struct ResetPasswordCancel: Codable {
    let href: String
    let hints: ResetPasswordHints
}

// MARK: - Hints
struct ResetPasswordHints: Codable {
    let allow: [String]
}
