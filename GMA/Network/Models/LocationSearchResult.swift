//
//  LocationSearchResult.swift
//  GMA
//
//  Created by Hoan Nguyen on 17/03/2022.
//

import Foundation
import UIKit

class LocationSearchResult: Codable {
    var locationSearch: [LocationSearch]
    init(locationSearch:[LocationSearch]) {
        self.locationSearch = locationSearch
    }
}

// MARK: - LocationSearch
class LocationSearch: Codable {
    let placeId, attributedPrimaryText: String
    let attributedSecondaryText: String?
    var photoDataString: String?
    var types:[String]?
    var coordinate: LocationCoordinate?
    var countryCode: String?
    var city: String?
    enum CodingKeys: String, CodingKey {
        case placeId, photoDataString
        case attributedPrimaryText, attributedSecondaryText
        case types
        case coordinate
        case countryCode, city
    }
    
    init(placeId: String, attributedPrimaryText: String, attributedSecondaryText: String?, type:[String]?, countryCode: String? = nil, city: String? = nil , coordinate: LocationCoordinate? = nil) {
        self.placeId = placeId
        self.attributedPrimaryText = attributedPrimaryText
        self.attributedSecondaryText = attributedSecondaryText
        self.types = type
        self.coordinate = coordinate
        self.countryCode = countryCode
        self.city = city
    }
    
    func copy() -> LocationSearch {
        do {
            let data = try JSONEncoder().encode(self)
            let copy = try JSONDecoder().decode(LocationSearch.self, from: data)
            return copy
        } catch {
            print("Workout copy() \(error)")
        }
        return self
    }
}

