//
//  AirPort.swift
//  GMA
//
//  Created by Hoan Nguyen on 26/01/2024.
//

import Foundation

// MARK: - Temperature
struct Airport: Codable {
    var country, airportName: String?
    var airportCode: String
    var location: AirportLocation

    enum CodingKeys: String, CodingKey {
        case country = "Country"
        case airportName = "Airport"
        case airportCode = "AirportCode"
        case location
    }
}

// MARK: - Location
struct AirportLocation: Codable {
    var x, y: Double
}

typealias AirportList = [Airport]
