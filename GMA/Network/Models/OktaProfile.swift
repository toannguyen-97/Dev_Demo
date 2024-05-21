//
//  OktaProfile.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/24/22.
//

import Foundation

let dayToExpiredPss = 90
let dayToWarningExpiredPss = 80


class OktaProfile: Codable {
    let id, status, created, activated: String
    let statusChanged: String
    let lastLogin: String?
    var lastUpdated, passwordChanged: String
    let type: TypeClass
    let profile: Profile
    let credentials: Credentials
    
    init(id: String, status: String, created: String, activated: String, statusChanged: String, lastLogin: String?, lastUpdated: String, passwordChanged: String, type: TypeClass, profile: Profile, credentials: Credentials) {
        self.id = id
        self.status = status
        self.created = created
        self.activated = activated
        self.statusChanged = statusChanged
        self.lastLogin = lastLogin
        self.lastUpdated = lastUpdated
        self.passwordChanged = passwordChanged
        self.type = type
        self.profile = profile
        self.credentials = credentials
    }

    func getDayToPawdExpired() -> Int{
        let currentDate = Date()
        let dFormater = DateFormatter()
        dFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let passChangedDate = dFormater.date(from: self.passwordChanged) {
            let delta = currentDate.days(from: passChangedDate)
            return delta
        }
        return dayToExpiredPss
    }
}

    // MARK: - Credentials
    class Credentials: Codable {
        let password: Password
        let provider: Provider

        init(password: Password, provider: Provider) {
            self.password = password
            self.provider = provider
        }
    }

    // MARK: - Password
    class Password: Codable {

        init() {
        }
    }

    // MARK: - Provider
    class Provider: Codable {
        let type, name: String

        init(type: String, name: String) {
            self.type = type
            self.name = name
        }
    }

    // MARK: - Profile
    class Profile: Codable {
        let firstName, lastName: String
        let mobilePhone: String?
        let organization: String
        let secondEmail, universalID: String?
        let userType, partyID, login, cdpID: String?
        let email: String

        enum CodingKeys: String, CodingKey {
            case firstName, lastName, mobilePhone, organization, secondEmail, userType
            case partyID = "partyId"
            case cdpID = "cdpId"
            case universalID = "UniversalId"
            case login, email
        }

        init(firstName: String, lastName: String, mobilePhone: String?, organization: String, secondEmail: String?, userType: String?, partyID: String?, cdpID: String?, universalID: String, login: String?, email: String) {
            self.firstName = firstName
            self.lastName = lastName
            self.mobilePhone = mobilePhone
            self.organization = organization
            self.secondEmail = secondEmail
            self.userType = userType
            self.partyID = partyID
            self.universalID = universalID
            self.login = login
            self.email = email
            self.cdpID = cdpID
        }
    }
// MARK: - TypeClass
class TypeClass: Codable {
    let id: String

    init(id: String) {
        self.id = id
    }
}
