//
//  PMAProfile.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/25/22.
//

import Foundation

import Foundation


typealias PMAProfiles = [PMAProfile]
// MARK: - UserElement
class PMAProfile: Codable {
    var phoneNumber, firstName, homeCountry: String?
    var pdiRecord: Bool?
    var emailAddress, phoneCountryCode: String?
    var partyVerifications: [PMAPartyVerification]?
    var salutation: String?
    var partyID, lastName: String?

    enum CodingKeys: String, CodingKey {
        case phoneNumber, firstName, homeCountry
        case pdiRecord = "PDIRecord"
        case emailAddress, phoneCountryCode, partyVerifications, salutation
        case partyID = "PartyId"
        case lastName
    }

    init(phoneNumber: String?, firstName: String?, homeCountry: String?, pdiRecord: Bool?, emailAddress: String?, phoneCountryCode: String?, partyVerifications: [PMAPartyVerification]?, salutation: String?, partyID: String?, lastName: String?) {
        self.phoneNumber = phoneNumber
        self.firstName = firstName
        self.homeCountry = homeCountry
        self.pdiRecord = pdiRecord
        self.emailAddress = emailAddress
        self.phoneCountryCode = phoneCountryCode
        self.partyVerifications = partyVerifications
        self.salutation = salutation
        self.partyID = partyID
        self.lastName = lastName
    }
    func getLast4Digit() -> String? {
        var digit: String?
        if let parties = self.partyVerifications, parties.count > 0 {
            parties.forEach { party in
                if party.verificationKey == last4Digits {
                    digit = party.verificationValue
                }
            }
        }
        return digit
    }
}

// MARK: - PartyVerification
class PMAPartyVerification: Codable {
    var pdiRecord: Bool?
    var partyVerificationID: String?
    var recordEffectiveFrom, recordEffectiveTo: String?
    var verificationValue, verificationKey: String?

    enum CodingKeys: String, CodingKey {
        case pdiRecord = "PDIRecord"
        case partyVerificationID = "partyVerificationId"
        case recordEffectiveFrom, recordEffectiveTo, verificationValue, verificationKey
    }

    init(pdiRecord: Bool?, partyVerificationID: String?, recordEffectiveFrom: String?, recordEffectiveTo: String?, verificationValue: String?, verificationKey: String?) {
        self.pdiRecord = pdiRecord
        self.partyVerificationID = partyVerificationID
        self.recordEffectiveFrom = recordEffectiveFrom
        self.recordEffectiveTo = recordEffectiveTo
        self.verificationValue = verificationValue
        self.verificationKey = verificationKey
    }
}
