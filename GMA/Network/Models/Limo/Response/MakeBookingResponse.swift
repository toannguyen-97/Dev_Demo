//
//  MakeBookingResponse.swift
//  GMA
//
//  Created by dat.tran on 1/15/24.
//

import Foundation


// MARK: - MakeBookinResponse
struct MakeBookingResponse: Codable {
    let message:String?
    let errorCode:String?
    let paymentMode: String?
    let pickup: MakeBookingPickup?
    let paramlists: MakeBookingParamlists?
    let discountPercentage: Int?
    let currency, contactMethod, vehicleType: String?
    let numberOfBags: Int?
    let localeID: String?
    let paymentDetails: MakeBookingPaymentDetails?
    let requestReferenceID: String?
    let expectedPassengerCount: Int?
    let timeZoneID: String?
    let dropoff: MakeBookingDropoff?
    let specialRequest: [JSONAny]?
    let passengerDetails: [PassengerDetail]?
    let notificationPreferences: String?
    let conciergeAgent: ConciergeAgent?
    let rateQuoteID: Int?
    let contactSource: String?
    let localCurrencycharge, baseCurrencycharge: Currencycharge?
    let sourceSystem: String?
    
    enum CodingKeys: String, CodingKey {
        case paymentMode, pickup, paramlists, discountPercentage, currency, contactMethod, vehicleType, numberOfBags,message,errorCode
        case localeID = "localeId"
        case paymentDetails
        case requestReferenceID = "requestReferenceId"
        case expectedPassengerCount
        case timeZoneID = "timeZoneId"
        case dropoff, specialRequest, passengerDetails, notificationPreferences, conciergeAgent, rateQuoteID, contactSource, localCurrencycharge, baseCurrencycharge, sourceSystem
    }
    
}

// MARK: - BookingParty
struct BookingParty: Codable {
    let name: Name?
    let emailAddress: String?
    let mobile: BookingPartyMobile?
}

// MARK: - BookingPartyMobile
struct BookingPartyMobile: Codable {
    let countyCode, number: String?
}

// MARK: - Name
struct Name: Codable {
    let firstName, lastName: String?
}

// MARK: - Driver
struct Driver: Codable {
    let name, mobile: String?
}

// MARK: - TravelDetail
struct MakeBookingTravelDetail: Codable {
    let type, carrierCode, carrierNumber, dateTime: String?
    let terminal: String?
}

// MARK: - Passenger
struct MakeBookingPassenger: Codable {
    let name, emailAddress: String?
    let mobile: MakeBookingPassengerMobile?
}

// MARK: - PassengerMobile
struct MakeBookingPassengerMobile: Codable {
    let number, countryCode: String?
}

// MARK: - PaymentDetails
struct MakeBookingPaymentDetails: Codable {
    let pspReference, resultCode: String?
    let details: [PaymentDetail]?
    let paymentData: String?
    let redirect: PaymentRedirect?
    let action: PaymentAction?
}
// MARK: - Detail
struct PaymentDetail: Codable {
    let key, type: String?
}
// MARK: - Action
struct PaymentAction: Codable {
    let paymentMethodType, paymentData: String?
    let data: PaymentRedirectDataClass?
    let url: String?
    let method, type: String?
}

// MARK: - Redirect
struct PaymentRedirect: Codable {
    let url: String?
    let data: PaymentRedirectDataClass?
    let method: String?
}
// MARK: - DataClass
struct PaymentRedirectDataClass: Codable {
    let paReq: String?
    let termURL: String?
    let md: String?
    
    enum CodingKeys: String, CodingKey {
        case paReq = "PaReq"
        case termURL = "TermUrl"
        case md = "MD"
    }
}
// MARK: - QuoteDetails
struct MakeBookingQuoteDetails: Codable {
    let quoteRateID: Int?
    let charge: MakeBookingCharge?
    let vehicle: MakeBookingVehicle?
    let cancellationPolicy, notes: String?
    let disclaimers: [JSONAny]?
    let bookingThreshhold: MakeBookingBookingThreshhold?
}

// MARK: - BookingThreshhold
struct MakeBookingBookingThreshhold: Codable {
    let newBookingThresholdHours, updateJobThreasholdHours, cancelJobThresholdHours: Int?
}

// MARK: - Charge
struct MakeBookingCharge: Codable {
    let details: [MakeBookingDetail]?
    let specialRequestDetails: [MakeBookingDetail]?
    let totalNet, totalGross, totalTaxAmount, currency: String?
}

// MARK: - Detail
struct MakeBookingDetail: Codable {
    let type, description, amount: String?
}

// MARK: - Vehicle
struct MakeBookingVehicle: Codable {
    let type: String?
    let maxPassengers, maxLuggages: Int?
    let photoURL: String?
    
    enum CodingKeys: String, CodingKey {
        case type, maxPassengers, maxLuggages
        case photoURL = "photoUrl"
    }
}
