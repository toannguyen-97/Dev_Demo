//
//  ChangePassword.swift
//  GMA
//
//  Created by Saven Developer on 3/9/22.
//

struct ChangePassword: Codable {
    let password: ChangePasswordPassword
    let provider: ChangePasswordProvider
}

// MARK: - Password
struct ChangePasswordPassword: Codable {
}

// MARK: - Provider
struct ChangePasswordProvider: Codable {
    let type, name: String
}
