//
//  generateOTP.swift
//  GMA
//
//  Created by Saven Developer on 1/31/22.
//

import Foundation

// MARK: - Model
struct generateOTP: Codable {
    let message, correlationID: String

    enum CodingKeys: String, CodingKey {
        case message
        case correlationID = "correlationId"
    }
    
    func OTPWasRecentlySentError() -> Bool{
        if message.contains("Successive OTP should be generated after") {
            return true
        }
        return false
    }
}
