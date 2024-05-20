//
//  MakeBookingRequest.swift
//  GMA
//
//  Created by dat.tran on 1/12/24.
//

import Foundation
import Adyen

struct MakeBookingRequest: EncodableParameters {
    let rateQuoteID: Int?
    let timeZoneID: String?
    let pickup: Pickup?
    let dropoff: GetQuoteResponseDropoff?
    let expectedPassengerCount: Int?
    let vehicleType: String?
    let specialRequest: [SpecialRequest]?
    let numberOfBags: Int?
    let passengerDetails: [PassengerDetail]?
    let localCurrencycharge: Currencycharge?
    let baseCurrencycharge: Currencycharge?
    let contactMethod: String?
    let sourceSystem: String?
    let contactSource: String?
    let localeID: String?
    let notificationPreferences: String?
    let conciergeAgent: ConciergeAgent?
    let paramlists: MakeBookingParamlists?
    var paymentDetails: PaymentDetails?
    var requestReferenceId:String?
    var paymentMode:String?
    var notesToDriver:String?
    init(rateQuoteID: Int?, timeZoneID: String?, pickup: Pickup?, dropoff: GetQuoteResponseDropoff?, expectedPassengerCount: Int?, vehicleType: String?, specialRequest: [SpecialRequest]?, numberOfBags: Int?, passengerDetails: [PassengerDetail]?, localCurrencycharge: Currencycharge?, baseCurrencycharge: Currencycharge?, contactMethod: String?, sourceSystem: String?, contactSource: String?, localeID: String?, notificationPreferences: String?, conciergeAgent: ConciergeAgent?, paramlists: MakeBookingParamlists?, paymentDetails: PaymentDetails?, requestReferenceId:String? = nil,paymentMode:String? = nil, notesToDriver:String?) {
        self.rateQuoteID = rateQuoteID
        self.timeZoneID = timeZoneID
        self.pickup = pickup
        self.dropoff = dropoff
        self.expectedPassengerCount = expectedPassengerCount
        self.vehicleType = vehicleType
        self.specialRequest = specialRequest
        self.numberOfBags = numberOfBags
        self.passengerDetails = passengerDetails
        self.localCurrencycharge = localCurrencycharge
        self.baseCurrencycharge = baseCurrencycharge
        self.contactMethod = contactMethod
        self.sourceSystem = sourceSystem
        self.contactSource = contactSource
        self.localeID = localeID
        self.notificationPreferences = notificationPreferences
        self.conciergeAgent = conciergeAgent
        self.paramlists = paramlists
        self.paymentDetails = paymentDetails
        self.requestReferenceId = requestReferenceId
        self.paymentMode = paymentMode
        self.notesToDriver = notesToDriver
    }
    enum CodingKeys: String, CodingKey {
        case rateQuoteID = "rateQuoteID"
        case timeZoneID = "timeZoneId"
        case pickup = "pickup"
        case dropoff = "dropoff"
        case expectedPassengerCount = "expectedPassengerCount"
        case vehicleType = "vehicleType"
        case specialRequest = "specialRequest"
        case numberOfBags = "numberOfBags"
        case passengerDetails = "passengerDetails"
        case localCurrencycharge = "localCurrencycharge"
        case baseCurrencycharge = "baseCurrencycharge"
        case contactMethod = "contactMethod"
        case sourceSystem = "sourceSystem"
        case contactSource = "contactSource"
        case localeID = "localeId"
        case notificationPreferences = "notificationPreferences"
        case conciergeAgent = "conciergeAgent"
        case paramlists = "paramlists"
        case paymentDetails = "paymentDetails"
        case requestReferenceId
        case paymentMode
        case notesToDriver
    }
}

// MARK: - Currencycharge
struct Currencycharge: Codable {
    let chargeHire: Int?
    let chargeHoliday: Int?
    let chargeNight: Int?
    let chargeWaiting: Int?
    let chargeWeekend: Int?
    let chargeExcessDistance: Int?
    let chargeExcessTime: Int?
    let totalGross: Int?
    let chargeExcess: Int?
    let customerchargeHire: Int?
    let totalTaxAmount: Double?
    let totalcustomerchargeHire: Double?
    let basecurrency: String?
    let localCurrency: String?
    init(chargeHire: Int?, chargeHoliday: Int?, chargeNight: Int?, chargeWaiting: Int?, chargeWeekend: Int?, chargeExcessDistance: Int?, chargeExcessTime: Int?, totalGross: Int?, chargeExcess: Int?, customerchargeHire: Int?, totalTaxAmount: Double?, totalcustomerchargeHire: Double?, basecurrency: String?, localCurrency: String?) {
        self.chargeHire = chargeHire
        self.chargeHoliday = chargeHoliday
        self.chargeNight = chargeNight
        self.chargeWaiting = chargeWaiting
        self.chargeWeekend = chargeWeekend
        self.chargeExcessDistance = chargeExcessDistance
        self.chargeExcessTime = chargeExcessTime
        self.totalGross = totalGross
        self.chargeExcess = chargeExcess
        self.customerchargeHire = customerchargeHire
        self.totalTaxAmount = totalTaxAmount
        self.totalcustomerchargeHire = totalcustomerchargeHire
        self.basecurrency = basecurrency
        self.localCurrency = localCurrency
    }
    enum CodingKeys: String, CodingKey {
        case chargeHire = "chargeHire"
        case chargeHoliday = "chargeHoliday"
        case chargeNight = "chargeNight"
        case chargeWaiting = "chargeWaiting"
        case chargeWeekend = "chargeWeekend"
        case chargeExcessDistance = "chargeExcessDistance"
        case chargeExcessTime = "chargeExcessTime"
        case totalGross = "totalGross"
        case chargeExcess = "chargeExcess"
        case customerchargeHire = "customerchargeHire"
        case totalTaxAmount = "totalTaxAmount"
        case totalcustomerchargeHire = "totalcustomerchargeHire"
        case basecurrency = "basecurrency"
        case localCurrency = "localCurrency"
    }
}

// MARK: - Dropoff
struct MakeBookingDropoff: Codable {
    let address: MakeBookingAddress?
    let travelDetail: MakeBookingDropoffTravelDetail?

    enum CodingKeys: String, CodingKey {
        case address = "address"
        case travelDetail = "travelDetail"
    }
}

// MARK: - Address
struct MakeBookingAddress: Codable {
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
struct MakeBookingDropoffTravelDetail: Codable {
    let dateTime: String?
    init(dateTime: String?) {
        self.dateTime = dateTime
    }
    enum CodingKeys: String, CodingKey {
        case dateTime = "dateTime"
    }
}

// MARK: - Paramlists
struct MakeBookingParamlists: Codable {
    let email: String?
    let phone: String?
    let topicImage: String?
    let topicID: String?
    let category:String?
    init(email: String?, phone: String?, topicImage: String?, topicID: String?, category:String? = limoCategory) {
        self.email = email
        self.phone = phone
        self.topicImage = topicImage
        self.topicID = topicID
        self.category = category
    }
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case phone = "mobileNumber"
        case topicImage = "topicImage"
        case topicID = "topicId"
        case category
    }
}

// MARK: - PassengerDetail
struct PassengerDetail: Codable {
    var name: String?
    var emailAddress: String?
    var mobile: Mobile?
    init(name: String?, emailAddress: String?, mobile: Mobile?) {
        self.name = name
        self.emailAddress = emailAddress
        self.mobile = mobile
    }
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case emailAddress = "emailAddress"
        case mobile = "mobile"
    }
}

// MARK: - Mobile
struct Mobile: Codable {
    var number: String?
    var countryCode: String?
    init(number: String?, countryCode: String?) {
        self.number = number
        self.countryCode = countryCode
    }
    enum CodingKeys: String, CodingKey {
        case number = "number"
        case countryCode = "countryCode"
    }
}

// MARK: - PaymentDetails
struct PaymentDetails: Codable {
    var paymentMethod: PaymentMethod?
    var returnURL: String?
    var channel: String?
    var shopperIP: String?
    var origin: String?
    var details: AdyenPaymentsDetails?
    var paymentData: String?
    init(paymentMethod: PaymentMethod? = nil, returnURL: String? = nil, channel: String? = nil, shopperIP: String? = nil, origin: String? = nil, adyenPaymentDetail: AdyenPaymentsDetails? = nil, paymentData: String? = nil) {
        self.paymentMethod = paymentMethod
        self.returnURL = returnURL
        self.channel = channel
        self.shopperIP = shopperIP
        self.origin = origin
        self.details = adyenPaymentDetail
        self.paymentData = paymentData
    }
    
    mutating func resetPaymentInformation(){
        self.paymentMethod = nil
        self.returnURL = nil
        self.channel = nil
        self.shopperIP = nil
        self.origin = nil
        self.details = nil
        self.paymentData = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case paymentMethod = "paymentMethod"
        case returnURL = "returnUrl"
        case channel = "channel"
        case shopperIP = "shopperIP"
        case origin = "origin"
        case details
        case paymentData
    }
}

// MARK: - PaymentMethod
struct PaymentMethod: Codable {
    let type: String?
    let holderName: String?
    var encryptedCardNumber: String?
    var encryptedExpiryMonth: String?
    var encryptedExpiryYear: String?
    var encryptedSecurityCode: String?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case holderName = "holderName"
        case encryptedCardNumber = "encryptedCardNumber"
        case encryptedExpiryMonth = "encryptedExpiryMonth"
        case encryptedExpiryYear = "encryptedExpiryYear"
        case encryptedSecurityCode = "encryptedSecurityCode"
    }
    init(type: String?, holderName: String? = nil, encryptedCardNumber: String? = nil, encryptedExpiryMonth: String? = nil, encryptedExpiryYear: String? = nil, encryptedSecurityCode: String? = nil) {
        let card = Card(number: encryptedCardNumber, securityCode: encryptedSecurityCode, expiryMonth: encryptedExpiryMonth, expiryYear: encryptedExpiryYear)
        do {
            let cardEncryptor = try CardEncryptor.encrypt(card: card, with: NetworkConstants.adyenPublicKey)

            self.encryptedCardNumber = cardEncryptor.number
            self.encryptedExpiryMonth = cardEncryptor.expiryMonth
            self.encryptedExpiryYear = cardEncryptor.expiryYear
            self.encryptedSecurityCode = cardEncryptor.securityCode
        } catch {
            self.encryptedCardNumber = ""
            self.encryptedExpiryMonth = ""
            self.encryptedExpiryYear = ""
            self.encryptedSecurityCode = ""
            debugPrint("--------ENCRYPT ADYEN ERROR-------------", error)
        }
        self.type = type
        self.holderName = holderName
    }
}

// MARK: - Pickup
struct MakeBookingPickup: Codable {
    let dateTime: String?
    let address: MakeBookingAddress?
    let travelDetail: MakeBookingPickupTravelDetail?

    init(dateTime: String?, address: MakeBookingAddress?, travelDetail: MakeBookingPickupTravelDetail?) {
        self.dateTime = dateTime
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
struct MakeBookingPickupTravelDetail: Codable {
    let carrierCode: String?
    let carrierNumber: String?
    let dateTime: String?
    let terminal: String?
    init(carrierCode: String?, carrierNumber: String?, dateTime: String?, terminal: String?) {
        self.carrierCode = carrierCode
        self.carrierNumber = carrierNumber
        self.dateTime = dateTime
        self.terminal = terminal
    }
    enum CodingKeys: String, CodingKey {
        case carrierCode = "carrierCode"
        case carrierNumber = "carrierNumber"
        case dateTime = "dateTime"
        case terminal = "terminal"
    }
}
