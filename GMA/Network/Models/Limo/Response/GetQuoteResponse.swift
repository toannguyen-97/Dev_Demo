//
//  GetQuoteResponse.swift
//  GMA
//
//  Created by dat.tran on 1/15/24.
//

import Foundation
struct GetQuoteResponse: Codable {
    let timeZoneID: String?
    let quoteID: String?
    let partnerTransactionID: String?
    let partnerTransactionReferenceId1: String?
    let partnerTransactionReferenceId2: String?
    let createdDate: String?
    let lastUpdatedDate: String?
    var pickup: Pickup?
    var dropoff: GetQuoteResponseDropoff?
    var expectedPassengerCount: Int?
    var numberOfBags: Int?
    var quoteDetails: [QuoteDetail]?
    let tsandCS: String?

    enum CodingKeys: String, CodingKey {
        case timeZoneID = "timeZoneId"
        case quoteID = "quoteId"
        case partnerTransactionID = "partnerTransactionId"
        case partnerTransactionReferenceId1 = "partnerTransactionReferenceId1"
        case partnerTransactionReferenceId2 = "partnerTransactionReferenceId2"
        case createdDate = "createdDate"
        case lastUpdatedDate = "lastUpdatedDate"
        case pickup = "pickup"
        case dropoff = "dropoff"
        case expectedPassengerCount = "expectedPassengerCount"
        case numberOfBags = "numberOfBags"
        case quoteDetails = "quoteDetails"
        case tsandCS = "tsandCs"
    }
}

// MARK: - Dropoff
struct GetQuoteResponseDropoff: Codable {
    let address: GetQuoteResponseAddress?
    let travelDetail: TravelDetail?

    enum CodingKeys: String, CodingKey {
        case address = "address"
        case travelDetail = "travelDetail"
    }
}

// MARK: - Address
struct GetQuoteResponseAddress: Codable {
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
struct TravelDetail: Codable {
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

// MARK: - Pickup
struct Pickup: Codable {
    let dateTime: String?
    let address: GetQuoteResponseAddress?
    let travelDetail: TravelDetail?

    enum CodingKeys: String, CodingKey {
        case dateTime = "dateTime"
        case address = "address"
        case travelDetail = "travelDetail"
    }
}

// MARK: - QuoteDetail
struct QuoteDetail: Codable {
    let quoteRateID: Int?
    var localcurrencycharge: GetQuoteCurrencycharge?
    var basecurrencycharge: GetQuoteCurrencycharge?
    let vehicle: Vehicle?
    let cancellationPolicy: String?
    let notes: String?
    let disclaimers: [Disclaimer]?
    let bookingThreshhold: BookingThreshhold?
    let charge: GetBookingCharge?
    enum CodingKeys: String, CodingKey {
        case quoteRateID = "quoteRateID"
        case localcurrencycharge = "localcurrencycharge"
        case basecurrencycharge = "basecurrencycharge"
        case vehicle = "vehicle"
        case cancellationPolicy = "cancellationPolicy"
        case notes = "notes"
        case disclaimers = "disclaimers"
        case bookingThreshhold = "bookingThreshhold"
        case charge
    }
}

// MARK: - Currencycharge
struct GetQuoteCurrencycharge: Codable {
    var details: [Detail]?
    let specialRequestDetails: [Detail]?
    let totalNet: String?
    let totalGross: String?
    let totalTaxAmount: String?
    let basecurrency: String?
    let totalcustomerchargeHire: String?
    let localCurrency: String?

    enum CodingKeys: String, CodingKey {
        case details = "details"
        case specialRequestDetails = "specialRequestDetails"
        case totalNet = "totalNet"
        case totalGross = "totalGross"
        case totalTaxAmount = "totalTaxAmount"
        case basecurrency = "basecurrency"
        case totalcustomerchargeHire = "totalcustomerchargeHire"
        case localCurrency = "localCurrency"
    }
}

// MARK: - Detail
struct Detail: Codable {
    let type: String?
    let description: String?
    let amount: String?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case description = "description"
        case amount = "amount"
    }
}

// MARK: - BookingThreshhold
struct BookingThreshhold: Codable {
    let newBookingThresholdHours: Int?
    let updateJobThreasholdHours: Int?
    let cancelJobThresholdHours: Int?

    enum CodingKeys: String, CodingKey {
        case newBookingThresholdHours = "newBookingThresholdHours"
        case updateJobThreasholdHours = "updateJobThreasholdHours"
        case cancelJobThresholdHours = "cancelJobThresholdHours"
    }
}

// MARK: - Disclaimer
struct Disclaimer: Codable {
    let label: String?
    let text: String?
    let locale: String?

    enum CodingKeys: String, CodingKey {
        case label = "label"
        case text = "text"
        case locale = "locale"
    }
}

// MARK: - Vehicle
struct Vehicle: Codable {
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

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
