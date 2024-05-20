//
//  ASCity.swift
//  GMA
//
//  Created by Hoan Nguyen on 12/10/2023.
//

import Foundation
import CoreLocation

class ASCity: Codable {
    var name: String
    var countryCode: String?
    var coordinate: LocationCoordinate?
    var types: [String]?
    var city: String?
    var cityNameInEnglish: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case coordinate
        case countryCode, types, city, cityNameInEnglish
    }

    
    init() {
        self.name = ""
        self.countryCode = nil
        self.coordinate = nil
        self.types = nil
        self.city = nil
        self.cityNameInEnglish = nil
    }
    
    init(name: String, countryCode: String?,coordinate: LocationCoordinate?, types:[String]?, city: String? = nil, cityNameInEnglish: String? = nil) {
        self.name = name
        self.countryCode = countryCode
        self.coordinate = coordinate
        self.types = types
        self.city = city
        self.cityNameInEnglish = cityNameInEnglish
    }
    

    static func initFromData(data: Data) -> ASCity?{
        do {
            let decoder = JSONDecoder()
            let cty = try decoder.decode(ASCity.self, from: data)
            return cty
        } catch {
            return nil
        }
    }
    
    func toData()-> Data? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            return data
        } catch {
            return nil
        }
    }
    
    func getValueToSendRequest() -> String? {
        if let engCity = self.cityNameInEnglish {
            return engCity
        } else if let city = self.city {
            return city
        }else {
            return self.name
        }
    }
}


class LocationCoordinate: Codable {
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
