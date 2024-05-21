//
//  GetQuoteRequest.swift
//  GMA
//
//  Created by dat.tran on 1/12/24.
//

import Foundation
struct GetQuoteRequest: EncodableParameters {
    let pickup: GetQuotePickup?
    let dropoff: GetQuoteDropoff?
    let sourceSystem: String?
    let contactMethod: String?
    let contactSource: String?
    let localeID: String?
    let conciergeAgent: ConciergeAgent?
    let currency: String?
    let expectedPassengerCount: Int?
    let vehicleType: String?
    let timeZoneID: String?
    let specialRequest: [SpecialRequest]?
    init(pickup: GetQuotePickup?,
         dropoff: GetQuoteDropoff?,
         sourceSystem: String? = "Self-Serve",
         contactMethod: String? = "Self-Serve",
         contactSource: String? = "Website",
         localeID: String? = CurrentSession.share.currentLanguage,
         conciergeAgent: ConciergeAgent?, 
         currency: String? = CurrentSession.share.programDetail?.extraInfo?.currency,
         expectedPassengerCount: Int?, vehicleType: String?, timeZoneID: String?, specialRequest: [SpecialRequest]?) {
        self.pickup = pickup
        self.dropoff = dropoff
        self.sourceSystem = sourceSystem
        self.contactMethod = contactMethod
        self.contactSource = contactSource
        self.localeID = localeID
        self.conciergeAgent = conciergeAgent
        self.currency = currency
        self.expectedPassengerCount = expectedPassengerCount
        self.vehicleType = vehicleType
        self.timeZoneID = timeZoneID
        self.specialRequest = specialRequest
    }
    enum CodingKeys: String, CodingKey {
        case pickup = "pickup"
        case dropoff = "dropoff"
        case sourceSystem = "sourceSystem"
        case contactMethod = "contactMethod"
        case contactSource = "contactSource"
        case localeID = "localeId"
        case conciergeAgent = "conciergeAgent"
        case currency = "currency"
        case expectedPassengerCount = "expectedPassengerCount"
        case vehicleType = "vehicleType"
        case timeZoneID = "timeZoneId"
        case specialRequest = "specialRequest"
    }
}

// MARK: - ConciergeAgent
struct ConciergeAgent: Codable {
    let agentName: String?
    let agentID: String?
    let agentDetails: String?
    init(agentName: String?, agentID: String?, agentDetails: String?) {
        self.agentName = agentName
        self.agentID = agentID
        self.agentDetails = agentDetails
    }
    enum CodingKeys: String, CodingKey {
        case agentName = "agentName"
        case agentID = "agentId"
        case agentDetails = "agentDetails"
    }
}

// MARK: - Dropoff
struct GetQuoteDropoff: Codable {
    let address: GetQuoteAddress?
    let travelDetail: DropoffTravelDetail?
    init(address: GetQuoteAddress?, travelDetail: DropoffTravelDetail?) {
        self.address = address
        self.travelDetail = travelDetail
    }
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case travelDetail = "travelDetail"
    }
}

// MARK: - Address
struct GetQuoteAddress: Codable {
    let addressLine1: String?
    let country: String?
    let latitude: Double?
    let longitude: Double?
    let airportCode: String?
    init(addressLine1: String?, country: String?, latitude: Double?, longitude: Double?, airportCode: String?) {
        self.addressLine1 = addressLine1
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.airportCode = airportCode
    }
    enum CodingKeys: String, CodingKey {
        case addressLine1 = "addressLine1"
        case country = "country"
        case latitude = "latitude"
        case longitude = "longitude"
        case airportCode = "airportCode"
    }
}

// MARK: - DropoffTravelDetail
struct DropoffTravelDetail: Codable {
    let carrierCode: String?
    let carrierNumber: String?
    let dateTime: String?
    let terminal: String?
    init(carrierCode: String?, carrierNumber: String?, dateTime: String?, terminal: String?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppContants.timeFormatPickupDateWithoutSS
        let date = dateFormatter.date(from: dateTime ?? "")
        dateFormatter.dateFormat = AppContants.timeFormatPickupDate
        let dateString = dateFormatter.string(from: date ?? Date())
        
        self.dateTime = dateString
        self.carrierCode = carrierCode
        self.carrierNumber = carrierNumber
        self.terminal = terminal
    }
    enum CodingKeys: String, CodingKey {
        case carrierCode = "carrierCode"
        case carrierNumber = "carrierNumber"
        case dateTime = "dateTime"
        case terminal = "terminal"
    }
}

// MARK: - Pickup
struct GetQuotePickup: Codable {
    let dateTime: String?
    let address: GetQuoteAddress?
    let travelDetail: PickupTravelDetail?
    init(dateTime: Date?, address: GetQuoteAddress?, travelDetail: PickupTravelDetail?) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = AppContants.localeLogic
        dateFormatter.dateFormat = AppContants.timeFormatPickupDate
        self.dateTime = dateFormatter.string(from: dateTime ?? Date())
        self.address = address
        self.travelDetail = travelDetail
    }
    enum CodingKeys: String, CodingKey {
        case dateTime = "dateTime"
        case address = "address"
        case travelDetail = "travelDetail"
    }
}

// MARK: - PickupTravelDetail
struct PickupTravelDetail: Codable {
    let carrierCode: String?
    let carrierNumber: String?
    let dateTime: String?
    let terminal: String?
    init(carrierCode: String?, carrierNumber: String?, dateTime: String?, terminal: String?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppContants.timeFormatPickupDateWithoutSS
        let date = dateFormatter.date(from: dateTime ?? "")
        dateFormatter.dateFormat = AppContants.timeFormatPickupDate
        let dateString = dateFormatter.string(from: date ?? Date())
        
        self.dateTime = dateString
        self.carrierCode = carrierCode
        self.carrierNumber = carrierNumber
        self.terminal = terminal
    }
    enum CodingKeys: String, CodingKey {
        case carrierCode = "carrierCode"
        case carrierNumber = "carrierNumber"
        case dateTime = "dateTime"
        case terminal = "terminal"
    }
}

// MARK: - SpecialRequest
struct SpecialRequest: Codable {
    let type: String?
    var quantity: Int?
    init(type: String?, quantity: Int?) {
        self.type = type
        self.quantity = quantity
    }
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case quantity = "quantity"
    }
}
