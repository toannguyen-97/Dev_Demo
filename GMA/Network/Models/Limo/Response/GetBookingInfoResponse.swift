// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement
struct GetBookingElement: Codable {
    let bookingID, status, notesToDriver, notesToPassenger: String?
    let reservationCode: String?
    let passengers: [GetBookingPassenger]?
    let createdDate, lastUpdatedDate: String?
    let pickup: Pickup?
    let dropoff: GetQuoteResponseDropoff?
    let expectedPassengerCount, numberOfBags: Int?
    var quoteDetails: [QuoteDetail]?
    let bookingParty: GetBookingParty?
    let driver: GetBookingDriver?
    let paymentDetails: GetBookingPaymentDetails?
    let paramlists: GetBookingParamlists?

    enum CodingKeys: String, CodingKey {
        case bookingID = "bookingId"
        case status = "status"
        case notesToDriver = "notesToDriver"
        case notesToPassenger = "notesToPassenger"
        case reservationCode = "reservationCode"
        case passengers = "passengers"
        case createdDate = "createdDate"
        case lastUpdatedDate = "lastUpdatedDate"
        case pickup = "pickup"
        case dropoff = "dropoff"
        case expectedPassengerCount = "expectedPassengerCount"
        case numberOfBags = "numberOfBags"
        case quoteDetails = "quoteDetails"
        case bookingParty = "bookingParty"
        case driver = "driver"
        case paymentDetails = "paymentDetails"
        case paramlists = "paramlists"
    }
}

// MARK: - BookingParty
struct GetBookingParty: Codable {
    let name: GetBookingName?
    let emailAddress: String?
    let mobile: GetBookingMobile?
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case emailAddress = "emailAddress"
        case mobile = "mobile"
    }
}

// MARK: - Mobile
struct GetBookingMobile: Codable {
    let countryCode, number: String?
    enum CodingKeys: String, CodingKey {
        case countryCode = "countryCode"
        case number = "number"
    }
}

// MARK: - Name
struct GetBookingName: Codable {
    let firstName, lastName: String?
    enum CodingKeys: String, CodingKey {
        case firstName = "firstName"
        case lastName = "lastName"
    }
}

// MARK: - Driver
struct GetBookingDriver: Codable {
    let name, mobile: String?
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case mobile = "mobile"
    }
}

// MARK: - Dropoff
struct GetBookingDropoff: Codable {
    let address: GetBookingAddress?
    let travelDetail: GetBookingTravelDetail?
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case travelDetail = "travelDetail"
    }
}

// MARK: - Address
struct GetBookingAddress: Codable {
    let airportCode: String?
    let addressLine1: String?
    let addressLine2: String?
    let addressLine3: String?
    let postcode: String?
    let city: String?
    let country: String?
    let state: String?
    let longitude: Double?
    let latitude: Double?
    enum CodingKeys: String, CodingKey {
        case airportCode = "airportCode"
        case addressLine1 = "addressLine1"
        case addressLine2 = "addressLine2"
        case addressLine3 = "addressLine3"
        case postcode = "postcode"
        case city = "city"
        case country = "country"
        case state = "state"
        case longitude = "longitude"
        case latitude = "latitude"
    }
}

// MARK: - TravelDetail
struct GetBookingTravelDetail: Codable {
    let type: String?
    let carrierCode: String?
    let carrierNumber: String?
    let dateTime: String?
    let terminal: String?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case carrierCode = "carrierCode"
        case carrierNumber = "carrierNumber"
        case dateTime = "dateTime"
        case terminal = "terminal"
    }
}

// MARK: - Paramlists
struct GetBookingParamlists: Codable {
    let email: String?
    let specialRequest: String?
    let topicImage: String?
    let topicID: String?
    let category: String?
    let mobileNumber: String?
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case specialRequest = "specialRequest"
        case topicImage = "topicImage"
        case topicID = "topicId"
        case category = "category"
        case mobileNumber = "mobileNumber"
    }
}

// MARK: - Passenger
struct GetBookingPassenger: Codable {
    let name: String?
    let emailAddress: String?
    let mobile: GetBookingMobile?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case emailAddress = "emailAddress"
        case mobile = "mobile"
    }
}

// MARK: - PaymentDetails
struct GetBookingPaymentDetails: Codable {
    let pspReference: String?
    let resultCode: String?

    enum CodingKeys: String, CodingKey {
        case pspReference = "pspReference"
        case resultCode = "resultCode"
    }
}

// MARK: - Pickup
struct GetBookingPickup: Codable {
    let dateTime: String?
    let address: GetBookingAddress?
    let travelDetail: GetBookingTravelDetail?

    enum CodingKeys: String, CodingKey {
        case dateTime = "dateTime"
        case address = "address"
        case travelDetail = "travelDetail"
    }
}

// MARK: - QuoteDetail
struct GetBookingQuoteDetail: Codable {
    let quoteRateID: Int?
    let charge: GetBookingCharge?
    let vehicle: GetBookingVehicle?
    let cancellationPolicy, notes: String?
    let disclaimers: [JSONAny]?
    let bookingThreshhold: GetBookingThreshhold?
    enum CodingKeys: String, CodingKey {
        case quoteRateID = "quoteRateID"
        case charge = "charge"
        case vehicle = "vehicle"
        case cancellationPolicy = "cancellationPolicy"
        case notes = "notes"
        case disclaimers = "disclaimers"
        case bookingThreshhold = "bookingThreshhold"
    }
}

// MARK: - BookingThreshhold
struct GetBookingThreshhold: Codable {
    let newBookingThresholdHours: Int?
    let updateJobThreasholdHours: Int?
    let cancelJobThresholdHours: Int?

    enum CodingKeys: String, CodingKey {
        case newBookingThresholdHours = "newBookingThresholdHours"
        case updateJobThreasholdHours = "updateJobThreasholdHours"
        case cancelJobThresholdHours = "cancelJobThresholdHours"
    }
}

// MARK: - Charge
struct GetBookingCharge: Codable {
    let details: [GetBookingDetail]?
    let specialRequestDetails: [GetBookingSpecialRequestDetail]?
    let totalNet: String?
    let totalGross: String?
    let totalTaxAmount: String?
    let currency: String?
    enum CodingKeys: String, CodingKey {
        case details = "details"
        case specialRequestDetails = "specialRequestDetails"
        case totalNet = "totalNet"
        case totalGross = "totalGross"
        case totalTaxAmount = "totalTaxAmount"
        case currency = "currency"
    }
}
// MARK: - SpecialRequestDetail
struct GetBookingSpecialRequestDetail: Codable {
    let type, description: String?
    let amount: Double?
}
// MARK: - Detail
struct GetBookingDetail: Codable {
    let type: String?
    let description: String?
    let amount: String?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case description = "description"
        case amount = "amount"
    }
}

// MARK: - Vehicle
struct GetBookingVehicle: Codable {
    let type: String?
    let maxPassengers: Int?
    let maxLuggages: Int?
    let photoURL: String?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case maxPassengers = "maxPassengers"
        case maxLuggages = "maxLuggages"
        case photoURL = "photoUrl"
    }
}

typealias GetBookingResponse = [GetBookingElement]
