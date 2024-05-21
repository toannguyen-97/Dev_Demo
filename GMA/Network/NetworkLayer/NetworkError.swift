//
//  NetworkError.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/12/22.
//

import Foundation

let COMMON_ERROR  = "An error has occurred. Check your internet settings or try again."

enum NetworkError : Error{
  
    case unauthorized
    case sessionExpired
    case noInternet
    case badAPIRequest
    case unknown
    
    
    var localizedDescription: String{
        switch self{
        case .unauthorized:
            return  NSLocalizedString("Unauthorized", comment: "NetworkError")
            
        case .sessionExpired:
            return  NSLocalizedString("Session Expired. Login again from Auth", comment: "NetworkError")
            
        case .noInternet:
            return NSLocalizedString("Turn on cellular data or use Wi-Fi to access Mobile Concierge.", comment: "NetworkError")
            
        case .badAPIRequest:
            return NSLocalizedString("Bad API request", comment: "NetworkError")

        case .unknown:
            return  NSLocalizedString("An error has occurred. Check your internet settings or try again.", comment: "NetworkError")
        }
    }
}


enum BiometricError : Error{
    
    case deniedAccess
    case noFaceIdEnrolled
    case noFingerPrintEnrolled
    case biometricError
    case userCancel
    case authenFailed
    case authenLock
    
    var localizedDescription: String{
        switch self{
        case .deniedAccess:
            return NSLocalizedString("Access denied", comment: "")
        case .noFaceIdEnrolled:
            return  NSLocalizedString("You have not registered any Face ID", comment: "")
        case .noFingerPrintEnrolled:
            return  NSLocalizedString("You have not registered any Fingerprints", comment: "")
        case .biometricError:
            return  NSLocalizedString("Your FaceID or fingerprint were not recognized", comment: "")
        case .userCancel:
            return  NSLocalizedString("You pressed cancel.", comment: "")
        case .authenFailed:
            return  NSLocalizedString("There was a problem verifying your identity.", comment: "")
        case .authenLock:
            return  NSLocalizedString("Face ID/Touch ID is locked.", comment: "")
        }
    }
}


enum APIError : Error{
    case email_not_exits_pma
    case accesscodeInvalid
    case account_locked_out
    case invalid_grant
    case email_not_exits_okta
    case password_too_recently
    case password_contains_part_email_fullName
    case old_password_not_correct
    case invalid_Phone_number
    case SuccessWithEmptyData
    case DiningTimeSlotNotAvailable
    case OTPWasRecentlySent
    var localizedDescription: String{
        switch self {
        case .email_not_exits_pma:
            return ""
        case .accesscodeInvalid:
            return ""
        case .account_locked_out:
            return "Account Locked Out"
        case .invalid_grant:
            return ""
        case .email_not_exits_okta:
            return ""
        case .password_too_recently:
            return "You cannot use the same password as the last 10 passwords"
        case .old_password_not_correct:
            return "The current password is incorrect. Please try again"
        case .password_contains_part_email_fullName:
            return "The password should not be parts of your username, not include your first name and last name. Please try again."
        case .invalid_Phone_number:
            return "This phone number is invalid."
        case .SuccessWithEmptyData:
            return "Api successful but no data"
        case .DiningTimeSlotNotAvailable:
            return "The requested hold time is not available. Please select a different time."
        case .OTPWasRecentlySent:
            return "An SMS message was recently sent. Please wait 30 seconds before trying again"
        }
    }
}


public struct CustomError: Error {
    let msg: String

    
    var isInvalidPhoneNumber: Bool {
        if msg == "customer.phoneNumber is invalid" {
            return true
        }
        return false
    }
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
            return NSLocalizedString(msg, comment: "")
    }
}
