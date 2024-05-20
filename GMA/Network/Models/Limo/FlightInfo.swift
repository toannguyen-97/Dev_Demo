//
//  FlightInfo.swift
//  GMA
//
//  Created by Hoan Nguyen on 25/01/2024.
//

import Foundation

import Foundation

struct FlightInfo: Codable {
    var result: FlightResult?
    var flights: [Flight]?

    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case flights = "Flights"
    }
}

// MARK: - Flight
struct Flight: Codable {
    var flightGUID: String?
    var acid: Acid?
    var departureAirport, arrivalAirport: ArrivalAirport?
    var originationDate, scheduledDeparture, scheduledArrival: OriginationDate?
    var scheduled, generalAviation: Bool?
    var status: String?
    var depDelayReason, arrDelayReason: [DelayReason]?
    var codeshares: [Acid]?
    var inAir: InAir?
    var departureTerminal, departureGate, checkinCounter, arrivalTerminal: String?
    var serviceType: String?
    var legSequenceNumber, numLegs: Int?
    var aircraft: Aircraft?
    var aircraftPreviousFlightLeg: AircraftPreviousFlightLeg?
    var scheduledDuration: String?

    enum CodingKeys: String, CodingKey {
        case flightGUID = "FlightGuid"
        case acid = "Acid"
        case departureAirport = "DepartureAirport"
        case arrivalAirport = "ArrivalAirport"
        case originationDate = "OriginationDate"
        case scheduledDeparture = "ScheduledDeparture"
        case scheduledArrival = "ScheduledArrival"
        case scheduled = "Scheduled"
        case generalAviation = "GeneralAviation"
        case status = "Status"
        case depDelayReason = "DepDelayReason"
        case arrDelayReason = "ArrDelayReason"
        case codeshares = "Codeshares"
        case inAir = "InAir"
        case departureTerminal = "DepartureTerminal"
        case departureGate = "DepartureGate"
        case checkinCounter = "CheckinCounter"
        case arrivalTerminal = "ArrivalTerminal"
        case serviceType = "ServiceType"
        case legSequenceNumber = "LegSequenceNumber"
        case numLegs = "NumLegs"
        case aircraft = "Aircraft"
        case aircraftPreviousFlightLeg = "AircraftPreviousFlightLeg"
        case scheduledDuration = "ScheduledDuration"
    }
}

// MARK: - Acid
struct Acid: Codable {
    var airline: ArrivalAirport?
    var flightNumber: String?

    enum CodingKeys: String, CodingKey {
        case airline = "Airline"
        case flightNumber = "FlightNumber"
    }
}

// MARK: - ArrivalAirport
struct ArrivalAirport: Codable {
    var code, codeNamespace, name: String?
    var location: FlightLocation?

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case codeNamespace = "CodeNamespace"
        case name = "Name"
        case location = "Location"
    }
}

// MARK: - Location
struct FlightLocation: Codable {
    var cityName, stateID, countryID: String?

    enum CodingKeys: String, CodingKey {
        case cityName = "CityName"
        case stateID = "StateId"
        case countryID = "CountryId"
    }
}

// MARK: - Aircraft
struct Aircraft: Codable {
    var code, codeNamespace: String?
    var optionalEquipment, weightClass: JSONNull?
    var tailNumber: String?

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case codeNamespace = "CodeNamespace"
        case optionalEquipment = "OptionalEquipment"
        case weightClass = "WeightClass"
        case tailNumber = "TailNumber"
    }
}

// MARK: - AircraftPreviousFlightLeg
struct AircraftPreviousFlightLeg: Codable {
    var flightID: Acid?
    var scheduledArrival: OriginationDate?

    enum CodingKeys: String, CodingKey {
        case flightID = "FlightId"
        case scheduledArrival = "ScheduledArrival"
    }
}

// MARK: - OriginationDate
struct OriginationDate: Codable {
    var utc, local: String?

    enum CodingKeys: String, CodingKey {
        case utc = "Utc"
        case local = "Local"
    }
}

// MARK: - DelayReason
struct DelayReason: Codable {
    var code: Int?
    var subcode: String?

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case subcode = "Subcode"
    }
}

// MARK: - InAir
struct InAir: Codable {
    var accuracy, dateTimeUTC, dateTimeLocal, sourceType: String?

    enum CodingKeys: String, CodingKey {
        case accuracy = "Accuracy"
        case dateTimeUTC = "DateTimeUtc"
        case dateTimeLocal = "DateTimeLocal"
        case sourceType = "SourceType"
    }
}

// MARK: - Result
struct FlightResult: Codable {
    var processingTimeUTC, version, code, message: String?
    var flights: Int?

    enum CodingKeys: String, CodingKey {
        case processingTimeUTC = "ProcessingTimeUtc"
        case version = "Version"
        case code = "Code"
        case message = "Message"
        case flights = "Flights"
    }
}
