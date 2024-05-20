//
//  AspireProfile.swift
//  GMA
//
//  Created by Hoan Nguyen on 10/02/2022.
//

import Foundation

let citySelectedAppUserPreferencesKey = "CitySelected"
let categorySelectedAppUserPreferencesKey = "CategorySelected"
let languageSelectedAppUserPreferencesKey = "PreferenceLanguage"
let TemperatureSelectedAppUserPreferencesKey = "Temperature"
let DistanceUnitSelectedAppUserPreferencesKey = "DistanceUnit"


class AspireProfile: Codable {
    var partyID: String
    var lastName, displayName, aliasName, welcomePrefix, fullName, firstName, middleName: String?
    let suffix, salutation, gender, maritalStatus: String?
    var dateOfBirth, residentCountry, homeCountry, nationality: String?
    let signature, profilePic, disabilityStatus, placeOfBirth: String?
    let vip, personType, employmentStatus: String?
    let locations: [UserLocation]?
    let phones: [Phone]?
    let emails: [Email]?
//    let faxes, websites, socialMedias: [String]?
    var memberships: [Membership]?
    var appUserPreferences: [AppUserPreference]?
    var identifications: [Identification]?
    let partyVerifications: [PartyVerification]?
    let relationShips: [RelationShip]?
    var preferences: [Preference]?
    
    enum CodingKeys: String, CodingKey {
        case partyID = "partyId"
        case fullName, firstName, middleName, lastName, displayName, aliasName
        case welcomePrefix = "prefix"
        case suffix, salutation, gender, maritalStatus, dateOfBirth, residentCountry, homeCountry, nationality, signature, profilePic, disabilityStatus, placeOfBirth, vip, personType, employmentStatus, locations, phones, emails, preferences, memberships, appUserPreferences, identifications, partyVerifications, relationShips
    }
    
    init(partyID: String, fullName: String, firstName: String, middleName: String, lastName: String, displayName: String, aliasName: String, welcomePrefix: String, suffix: String, salutation: String, gender: String, maritalStatus: String, dateOfBirth: String, residentCountry: String, homeCountry: String, nationality: String, signature: String, profilePic: String, disabilityStatus: String, placeOfBirth: String, vip: String, personType: String, employmentStatus: String, locations: [UserLocation], phones: [Phone], emails: [Email], preferences: [Preference], memberships: [Membership], appUserPreferences: [AppUserPreference], identifications: [Identification], partyVerifications: [PartyVerification], relationShips: [RelationShip]) {
        self.partyID = partyID
        self.fullName = fullName
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.displayName = displayName
        self.aliasName = aliasName
        self.welcomePrefix = welcomePrefix
        self.suffix = suffix
        self.salutation = salutation
        self.gender = gender
        self.maritalStatus = maritalStatus
        self.dateOfBirth = dateOfBirth
        self.residentCountry = residentCountry
        self.homeCountry = homeCountry
        self.nationality = nationality
        self.signature = signature
        self.profilePic = profilePic
        self.disabilityStatus = disabilityStatus
        self.placeOfBirth = placeOfBirth
        self.vip = vip
        self.personType = personType
        self.employmentStatus = employmentStatus
        self.locations = locations
        self.phones = phones
        self.emails = emails
        self.preferences = preferences
        self.memberships = memberships
        self.appUserPreferences = appUserPreferences
        self.identifications = identifications
        self.partyVerifications = partyVerifications
        self.relationShips = relationShips
    }
    
    func getAccessCode() -> String {
        if let ap = self.partyVerifications, ap.count > 0 {
            var ac: String?
            ap.forEach { partyV in
                if  partyV.verificationKey?.lowercased() == "accesscode" {
                    ac = partyV.verificationValue
                }
            }
            if let accessCode = ac {
                return accessCode
            }
        }
        if let am = self.memberships?.first?.referenceNumber {
            return am
        }
        return ""
    }
    
   static func getTemperatureUnit() -> String {
       if let appUsrs = CurrentSession.share.aspireProfile?.appUserPreferences {
            let temperatureItems = appUsrs.filter{ (aup) -> Bool in
                return aup.preferenceKey == TemperatureSelectedAppUserPreferencesKey
            }
            if let temp = temperatureItems.first?.preferenceValue {
                return temp
            }
        }
        return TemperatureUnit.C.stringValue
    }
    
    static func getDistanceUnit() -> String {
        if let appUsrs = CurrentSession.share.aspireProfile?.appUserPreferences  {
            let distanceItems = appUsrs.filter{ (aup) -> Bool in
                return aup.preferenceKey == DistanceUnitSelectedAppUserPreferencesKey
            }
            if let temp = distanceItems.first?.preferenceValue {
                return temp
            }
        }
        return DistanceUnit.Km.stringValue
    }
    
    static func getCitySelected() -> String? {
        if let appUsrs = CurrentSession.share.aspireProfile?.appUserPreferences  {
            let cityItems = appUsrs.filter{ (aup) -> Bool in
                return aup.preferenceKey == citySelectedAppUserPreferencesKey
            }
            if let temp = cityItems.first?.preferenceValue {
                return temp
            }
        }
        return nil
    }
}

// MARK: - AppUserPreference
class AppUserPreference: Codable {
    var appUserPreferenceID, preferenceKey, preferenceValue: String?

    enum CodingKeys: String, CodingKey {
        case appUserPreferenceID = "appUserPreferenceId"
        case preferenceKey, preferenceValue
    }

    init(appUserPreferenceID: String?, preferenceKey: String, preferenceValue: String) {
        self.appUserPreferenceID = appUserPreferenceID
        self.preferenceKey = preferenceKey
        self.preferenceValue = preferenceValue
    }
}

// MARK: - Email
class Email: Codable {
    let emailID, emailType, emailAddress: String?

    enum CodingKeys: String, CodingKey {
        case emailID = "emailId"
        case emailType, emailAddress
    }

    init(emailID: String, emailType: String, emailAddress: String) {
        self.emailID = emailID
        self.emailType = emailType
        self.emailAddress = emailAddress
    }
}

// MARK: - Membership
class Membership: Codable {
    var membershipID, membershipCategory, programName, referenceName: String?
    var referenceNumber, externalReferenceNumber, uniqueIdentifier, otherType: String?
    var accountType, startDate, endDate, productCode: String?
    var program, level: String?

    enum CodingKeys: String, CodingKey {
        case membershipID = "membershipId"
        case membershipCategory, programName, referenceName, referenceNumber, externalReferenceNumber, uniqueIdentifier, otherType, accountType, startDate, endDate, productCode, program, level
    }

    init(membershipID: String, membershipCategory: String, programName: String, referenceName: String, referenceNumber: String, externalReferenceNumber: String, uniqueIdentifier: String, otherType: String, accountType: String, startDate: String, endDate: String, productCode: String, program: String, level: String) {
        self.membershipID = membershipID
        self.membershipCategory = membershipCategory
        self.programName = programName
        self.referenceName = referenceName
        self.referenceNumber = referenceNumber
        self.externalReferenceNumber = externalReferenceNumber
        self.uniqueIdentifier = uniqueIdentifier
        self.otherType = otherType
        self.accountType = accountType
        self.startDate = startDate
        self.endDate = endDate
        self.productCode = productCode
        self.program = program
        self.level = level
    }
}

// MARK: - PartyVerification
class PartyVerification: Codable {
    var partyVerificationID, verificationKey, verificationValue, recordEffectiveFrom: String?
    let recordEffectiveTo: String?

    enum CodingKeys: String, CodingKey {
        case partyVerificationID = "partyVerificationId"
        case verificationKey, verificationValue, recordEffectiveFrom, recordEffectiveTo
    }

    init(partyVerificationID: String, verificationKey: String, verificationValue: String, recordEffectiveFrom: String, recordEffectiveTo: String) {
        self.partyVerificationID = partyVerificationID
        self.verificationKey = verificationKey
        self.verificationValue = verificationValue
        self.recordEffectiveFrom = recordEffectiveFrom
        self.recordEffectiveTo = recordEffectiveTo
    }
}

// MARK: - Phone
class Phone: Codable {
    var phoneID, phoneType, phoneCountryCode, phoneAreaCode: String?
    var phoneNumber, phoneExtension: String?

    enum CodingKeys: String, CodingKey {
        case phoneID = "phoneId"
        case phoneType, phoneCountryCode, phoneAreaCode, phoneNumber, phoneExtension
    }

    init(phoneID: String, phoneType: String, phoneCountryCode: String, phoneAreaCode: String, phoneNumber: String, phoneExtension: String) {
        self.phoneID = phoneID
        self.phoneType = phoneType
        self.phoneCountryCode = phoneCountryCode
        self.phoneAreaCode = phoneAreaCode
        self.phoneNumber = phoneNumber
        self.phoneExtension = phoneExtension
    }
}

// MARK: - RelationShip
class RelationShip: Codable {
    let relationshipID, relationshipType, partyID, partyType: String?
    let partyName: String?

    enum CodingKeys: String, CodingKey {
        case relationshipID = "relationshipId"
        case relationshipType
        case partyID = "partyId"
        case partyType, partyName
    }

    init(relationshipID: String, relationshipType: String, partyID: String, partyType: String, partyName: String) {
        self.relationshipID = relationshipID
        self.relationshipType = relationshipType
        self.partyID = partyID
        self.partyType = partyType
        self.partyName = partyName
    }
}

// MARK: - Preferences
class Preference: Codable {
    let preferenceType, preferenceValue: String

        enum CodingKeys: String, CodingKey {
            case preferenceType, preferenceValue
        }

    init(preferenceType: String, preferenceValue: String) {
        self.preferenceType = preferenceType
        self.preferenceValue = preferenceValue
    }
}

// MARK: - Identification
class Identification: Codable {
    let identificationNumber, identificationType, issuingCountry: String

        enum CodingKeys: String, CodingKey {
            case identificationNumber, identificationType, issuingCountry
        }

    init(identificationNumber: String, identificationType: String, issuingCountry: String) {
        self.identificationNumber = identificationNumber
        self.identificationType = identificationType
        self.issuingCountry = issuingCountry
    }
}

// MARK: - Location
class UserLocation: Codable {
    var address: UserAddress?
    var locationType, locationID: String?

    enum CodingKeys: String, CodingKey {
        case address, locationType
        case locationID = "locationId"
    }

    init(address: UserAddress?, locationType: String?, locationID: String?) {
        self.address = address
        self.locationType = locationType
        self.locationID = locationID
    }
}

// MARK: - Address
class UserAddress: Codable {
    var county, addressLine5, city, country: String?
    var stateProvince, addressDescription, addressLine1, addressLine2: String?
    var addressLine3, zipCode, addressLine4: String?

    init(county: String?, addressLine5: String?, city: String?, country: String?, stateProvince: String?, addressDescription: String?, addressLine1: String?, addressLine2: String?, addressLine3: String?, zipCode: String?, addressLine4: String?) {
        self.county = county
        self.addressLine5 = addressLine5
        self.city = city
        self.country = country
        self.stateProvince = stateProvince
        self.addressDescription = addressDescription
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.addressLine3 = addressLine3
        self.zipCode = zipCode
        self.addressLine4 = addressLine4
    }
}

