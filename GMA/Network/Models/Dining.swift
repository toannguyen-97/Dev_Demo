//
//  Dining.swift
//  GMA
//
//  Created by Saven Developer on 6/15/22.
//

import Foundation

struct Dining: Codable {
    let restaurantList: [DiningItem]
    let count: Int
}
struct DiningItem: Codable {
    var contentID: String
    var webSite: String?
    var aliasContentID: [String]?
    var reservationSourceID, reservationSource, restaurantName: String?
    var aliasName: String?
    var originalRestaurantName: String?
    var cuisine: [String]?
    var contentSource: String?
    var contentTags: [String]?
    var defaultImage: String?
    var reservationType: String?
    var perkEnabled: Bool?
    var perkVendorPromoURL: String?
    var address, originalAddress: DiningAddress?
    var contactNumber, bookingURL, summary, originalSummary: String?
    var price: Int?
    var restaurantReview: RestaurantReview?
    var rating: Rating?
    var locale: String?
    var weightage: String?
    var distance, miles, meters: String?
    var ratingKey, reservationOpenings: [String]?
    var images: [String]?
    var name, originalName: String?
    var diningItemDescription, originalDescription: String?
    var restaurantContact: RestaurantContact?
    var hoursOfOperation: DaysOfOperation?
    var termsURL, policyURL: String?
    var insiderTips: String?
    var suitableFor, additionalInformation: [String]?
    var perks: [Perk]?
    var perkType: [String]?
    
    enum CodingKeys: String, CodingKey {
        case contentID = "contentId"
        case webSite = "WebSite"
        case aliasContentID, name, originalName, originalDescription
        case images, suitableFor, additionalInformation, perkType
        case insiderTips
        case restaurantContact, hoursOfOperation
        case diningItemDescription = "description"
        case reservationSourceID = "reservationSourceId"
        case reservationSource, restaurantName, aliasName, originalRestaurantName, cuisine, contentSource, contentTags, defaultImage, reservationType, perkEnabled, perkVendorPromoURL, address, originalAddress, contactNumber
        case summary, originalSummary, price, restaurantReview
        case rating, weightage, distance, miles, meters, ratingKey, reservationOpenings, locale
        case termsURL = "termsUrl"
        case policyURL = "policyUrl"
        case bookingURL = "bookingUrl"
        case perks
    }
    
    init(contentID: String) {
        self.contentID = contentID
    }
    
    
    func getAddressString() -> String{
        if let address = address {
            var addressStr = address.addressLine1?.trim() ?? ""
            if addressStr.isEmpty {
                addressStr = address.addressLine2?.trim() ?? ""
            }
            
            if let pcode = address.postcode, !pcode.isEmpty {
                addressStr = addressStr + ", " + pcode
            }
            if let city = address.city, !city.isEmpty  {
                addressStr = addressStr + " " + city
            }
            if let country = address.country, !country.isEmpty {
                addressStr = addressStr + ", " + country
            }
            return addressStr
        }
        return ""
    }
    
    func toContentTopic() -> ContentTopic{
        let attrs = Attributes(name: self.name ?? self.restaurantName ?? "", address1: self.address?.addressLine1, contentType: [diningCategory], postalCode: self.address?.postcode, city: self.address?.city, latitude: self.address?.latitude, longitude: self.address?.longitude, state: [self.address?.state ?? ""], country: [self.address?.country ?? ""], region: [self.address?.state ?? ""], image1URL: self.images?.first, address2: self.address?.addressLine2)
        
        let topic = ContentTopic(responseID: 0, topicID: self.contentID, topicLabel: self.restaurantName ?? "", topicName: self.restaurantName ?? "", distance: nil, attributes: attrs)
        return topic
    }
}

// MARK: - Address
struct DiningAddress: Codable {
    var addressLine1, addressLine2, addressLine3, city: String?
    var state, country, postcode, longitude: String?
    var latitude: String?
}

// MARK: - RestaurantContact
struct RestaurantContact: Codable {
    let countryCode, number: String?
}


// MARK: - Rating
struct Rating: Codable {
    let rate, total: Float?
    
    enum CodingKeys: String, CodingKey {
        case rate = "Rate"
        case total = "Total"
    }
    
    enum AnotherCodingKeys: String, CodingKey {
        case rate = "rate"
        case total = "total"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let _ = try? container.decodeIfPresent(Float.self, forKey: .rate) {
            self.rate = try container.decodeIfPresent(Float.self, forKey: .rate)
            self.total = try container.decodeIfPresent(Float.self, forKey: .total)
        }else {
            let anotherContainer = try decoder.container(keyedBy: AnotherCodingKeys.self)
            self.rate = try anotherContainer.decodeIfPresent(Float.self, forKey: .rate)
            self.total = try anotherContainer.decodeIfPresent(Float.self, forKey: .total)
        }
    }
}

// MARK: - RestaurantReview
struct RestaurantReview: Codable {
    
    let reviewCount: Int
    let sourceRestaurantUrl: String?
    
    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let url = try? values.decode(String.self, forKey: .sourceRestaurantUrl){
            sourceRestaurantUrl = url
        }else{
            sourceRestaurantUrl = nil
        }

        if let theString = try? values.decode(String.self, forKey: .reviewCount),
           let latitude = Int(theString.trimmingCharacters(in: .whitespacesAndNewlines)) {
            reviewCount = latitude
        }else if let rCount = try? values.decode(Int.self, forKey: .reviewCount) {
            reviewCount = rCount
        }else {
            reviewCount = 0
        }
    }
}


// MARK: - DaysOfOperation
struct DaysOfOperation: Codable {
    let mon, tue, wed, thu: [HoursOfOperation]?
    let fri, sat, sun: [HoursOfOperation]?
    
    enum CodingKeys: String, CodingKey {
        case mon = "Mon"
        case tue = "Tue"
        case wed = "Wed"
        case thu = "Thu"
        case fri = "Fri"
        case sat = "Sat"
        case sun = "Sun"
    }
}

// MARK: - HoursOfOperation
struct HoursOfOperation: Codable {
    let openHour, closeHour: String?
    
    enum CodingKeys: String, CodingKey {
        case openHour = "open"
        case closeHour = "close"
    }
}



// MARK: - Perk
struct Perk: Codable {
    let id: String?
    let name, perkDescription, policy, policyType: String?
    let effectiveDate, expiryDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case perkDescription = "description"
        case policy, policyType, effectiveDate, expiryDate
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        perkDescription = try values.decode(String.self, forKey: .perkDescription)
        policy = try values.decode(String.self, forKey: .policy)
        policyType = try values.decode(String.self, forKey: .policyType)
        effectiveDate = try values.decode(String.self, forKey: .effectiveDate)
        expiryDate = try values.decode(String.self, forKey: .expiryDate)
        if let theString = try? values.decode(String.self, forKey: .id){
           id = theString
        } else if let intString = try? values.decode(Int.self, forKey: .id) {
            id = "\(intString)"
        }else {
            id = nil
        }
    }
}

// MARK: - Meta
struct Meta: Codable {
    let count: Int
}

// MARK: - Pagination
struct Pagination: Codable {
    let next: String?
}
