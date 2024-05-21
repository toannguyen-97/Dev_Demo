//
//  ContentTopic.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 3/6/22.
//

import Foundation


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let temperatures = try? newJSONDecoder().decode(Temperatures.self, from: jsonData)

import Foundation


struct ListContentTopic: Codable {
    let responses: [ContentTopic]
    let facets: [Facet]?
    let resultCount: Int
}

// MARK: - Temperatures
struct ContentTopic: Codable {
    let responseID: Int
    let topicID: String
    let topicLabel, topicName: String
    let distance: Double?
    var attributes: Attributes?
    
    enum CodingKeys: String, CodingKey {
        case responseID = "responseId"
        case topicID = "topicId"
        case topicLabel, topicName, distance, attributes
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.responseID = try container.decode(Int.self, forKey: .responseID)
        if let theInt = try? container.decode(Int.self, forKey: .topicID){
            topicID = "\(theInt)"
        } else if let theStr = try? container.decode(String.self, forKey: .topicID){
            topicID = theStr
        }else {
            topicID = ""
        }
        
        self.topicLabel = try container.decode(String.self, forKey: .topicLabel)
        self.topicName = try container.decode(String.self, forKey: .topicName)
        self.distance = try container.decodeIfPresent(Double.self, forKey: .distance)
        self.attributes = try container.decodeIfPresent(Attributes.self, forKey: .attributes)
    }
    
    init(responseID: Int, topicID: String, topicLabel: String, topicName: String, distance: Double?, attributes: Attributes? = nil) {
        self.responseID = responseID
        self.topicID = topicID
        self.topicLabel = topicLabel
        self.topicName = topicName
        self.distance = distance
        self.attributes = attributes
    }

}

// MARK: - Attributes
struct Attributes: Codable {
    let timeZone: [String]?
    let owner: [String]?
    let clientID: [String]?
    let saturdayHours: String?
    let name: String
    let address1, sourceID: String?
    let programID: [String]?
    let currency: [String]?
    let image2URL: String?
    let image3URL: String?
    let requestType: [String]?
    let contentType: [String]
    let latLongConfirmed: [String]?
    let priceRating: [String]?
    let enclosureCode: String?
    let fridayHours: String?
    let postalCode: String?
    let city: String?
    var latitude, longitude: String?
    let googlePlaceID, neighborhood: String?
    let tuesdayHours, mondayHours: String?
    let state: [String]?
    let country: [String]?
    let region: [String]?
    let expiryDate: String?
    let translations: [String]?
    let hoursOfOperation, attributesDescription: String?
    let website: String?
    let conciergeTags: [String]?
    let eventCity: [String]?
    let source: [String]?
    let clientAvailability: [String]?
    let insiderTips, effectiveDate: String?
    let thursdayHours: String?
    let openStatus: [String]?
    let majorMarket: [String]?
    let country3_Letter: [String]?
    let image1URL: String?
    let sundayHours: String?
    let shortDescription: String?
    let wednesdayHours: String?
    let poiType: [String]?
    let summary: String?
    let countryCode: [String]?
    let phoneNumber: String?
    let address2: String?
    let qualityRating, perkType: [String]?
    let perkVendorName: String?
    let perkContentType: [String]?
    let policyDescription: String?
    let matchingCode: String?
    let cuisine: [String]?
    let duration: String?
    let internalInstructions: String?
    let hotelType: [String]?


    enum CodingKeys: String, CodingKey {
        case timeZone = "Time Zone"
        case owner = "Owner"
        case clientID = "Client ID"
        case saturdayHours = "Saturday Hours"
        case latitude = "Latitude"
        case name = "Name"
        case address1 = "Address_1"
        case sourceID = "Source ID"
        case programID = "Program ID"
        case currency = "Currency"
        case image2URL = "Image_2 URL"
        case image3URL = "Image_3 URL"
        case requestType = "Request Type"
        case contentType = "Content Type"
        case latLongConfirmed = "Lat Long Confirmed"
        case priceRating = "Price Rating"
        case enclosureCode = "Enclosure Code"
        case fridayHours = "Friday Hours"
        case postalCode = "Postal Code"
        case city = "City"
        case googlePlaceID = "Google Place ID"
        case longitude = "Longitude"
        case neighborhood = "Neighborhood"
        case tuesdayHours = "Tuesday Hours"
        case mondayHours = "Monday Hours"
        case state = "State"
        case country = "Country"
        case region = "Region"
        case expiryDate = "Expiry Date"
        case translations = "Translations"
        case hoursOfOperation = "Hours of Operation"
        case attributesDescription = "Description"
        case website = "Website"
        case conciergeTags = "Concierge Tags"
        case eventCity = "EventCity"
        case source = "Source"
        case clientAvailability = "Client Availability"
        case insiderTips = "Insider Tips"
        case effectiveDate = "Effective Date"
        case thursdayHours = "Thursday Hours"
        case openStatus = "Open Status"
        case majorMarket = "Major Market"
        case country3_Letter = "Country 3_Letter"
        case image1URL = "Image_1 URL"
        case sundayHours = "Sunday Hours"
        case shortDescription = "Short Description"
        case wednesdayHours = "Wednesday Hours"
        case poiType = "POI Type"
        case summary = "Summary"
        case countryCode = "Country Code"
        case phoneNumber = "Phone Number"
        case address2 = "Address_2"
        case qualityRating = "Quality Rating"
        case perkType = "Perk Type"
        case perkVendorName = "Perk Vendor Name"
        case perkContentType = "Perk Content Type"
        case policyDescription = "Policy Description"
        case matchingCode = "Matching Code"
        case cuisine = "Cuisine"
        case duration = "Duration"
        case internalInstructions = "Internal Instructions"
        case hotelType = "Hotel Type"
    }
    
    init(name: String, address1: String?, contentType: [String], postalCode: String?, city: String?, latitude: String? = nil, longitude: String? = nil, state: [String]?, country: [String]?, region: [String]?,image1URL: String?, address2: String?) {
        self.timeZone = nil
        self.owner = nil
        self.clientID = nil
        self.saturdayHours = nil
        self.name = name
        self.address1 = address1
        self.sourceID = nil
        self.programID = nil
        self.currency = nil
        self.image2URL = nil
        self.image3URL = nil
        self.requestType = nil
        self.contentType = contentType
        self.latLongConfirmed = nil
        self.priceRating = nil
        self.enclosureCode = nil
        self.fridayHours = nil
        self.postalCode = postalCode
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
        self.googlePlaceID = nil
        self.neighborhood = nil
        self.tuesdayHours = nil
        self.mondayHours = nil
        self.state = state
        self.country = country
        self.region = region
        self.expiryDate = nil
        self.translations = nil
        self.hoursOfOperation = nil
        self.attributesDescription = nil
        self.website = nil
        self.conciergeTags = nil
        self.eventCity = nil
        self.source = nil
        self.clientAvailability = nil
        self.insiderTips = nil
        self.effectiveDate = nil
        self.thursdayHours = nil
        self.openStatus = nil
        self.majorMarket = nil
        self.country3_Letter = nil
        self.image1URL = image1URL
        self.sundayHours = nil
        self.shortDescription = nil
        self.wednesdayHours = nil
        self.poiType = nil
        self.summary = nil
        self.countryCode = nil
        self.phoneNumber = nil
        self.address2 = address2
        self.qualityRating = nil
        self.perkType = nil
        self.perkVendorName = nil
        self.perkContentType = nil
        self.policyDescription = nil
        self.matchingCode = nil
        self.cuisine = nil
        self.duration = nil
        self.internalInstructions = nil
        self.hotelType = nil
    }
}



// MARK: - Facet
struct Facet: Codable {
    var name: String?
    var items: [FacetItem]?
}

// MARK: - Item
struct FacetItem: Codable {
    var value: String?
    var count: Int?
}
