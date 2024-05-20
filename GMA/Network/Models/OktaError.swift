//
//  OktaError.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 3/3/22.
//

import Foundation


// MARK: - Temperatures
struct OktaError: Codable {
    static let errorOldPasswordNotCorrect = "Old Password is not correct"
    static let errorNewPasswordIsCurrentPassword = "Password cannot be your current password"
    static let errorPasswordContainsPartOfEmailORFullName = "Password requirements were not met"
    static let errorPasswordUsedTooRecently  = "Password has been used too recently"
    
    let errorCode, errorSummary, errorLink, errorID: String
    let errorCauses: [ErrorCause]

    enum CodingKeys: String, CodingKey {
        case errorCode, errorSummary, errorLink
        case errorID = "errorId"
        case errorCauses
    }
}

// MARK: - ErrorCause
struct ErrorCause: Codable {
    let errorSummary: String
}
