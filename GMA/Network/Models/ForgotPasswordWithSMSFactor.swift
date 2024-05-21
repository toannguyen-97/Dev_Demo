//
//  ForgotPasswordWithSMSFactor.swift
//  GMA
//
//  Created by Saven Developer on 2/16/22.
//

import Foundation

// MARK: - Model
struct ForgotPasswordWithSMSFactor: Codable {
    let expiresAt, status, relayState: String?
    let stateToken, factorType, recoveryType: String

    enum CodingKeys: String, CodingKey {
        case stateToken, expiresAt, status, relayState, factorType, recoveryType
    }
}

// MARK: - Links
struct ForgotPasswordWithSMSFactorLinks: Codable {
    let next: ForgotPasswordWithSMSFactorNext
    let cancel: ForgotPasswordWithSMSFactorCancel
    let resend: ForgotPasswordWithSMSFactorNext
}

// MARK: - Cancel
struct ForgotPasswordWithSMSFactorCancel: Codable {
    let href: String
    let hints: ForgotPasswordWithSMSFactorHints
}

// MARK: - Hints
struct ForgotPasswordWithSMSFactorHints: Codable {
    let allow: [String]
}

// MARK: - Next
struct ForgotPasswordWithSMSFactorNext: Codable {
    let name: String
    let href: String
    let hints: ForgotPasswordWithSMSFactorHints
}

