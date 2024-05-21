//
//  Recommendation.swift
//  GMA
//
//  Created by Hoan Nguyen on 12/04/2022.
//

import Foundation
// MARK: - Welcome
struct Recommendation: Codable {
    let topContents: TopContents

    enum CodingKeys: String, CodingKey {
        case topContents = "topContents"
    }
}

// MARK: - TopContents
struct TopContents: Codable {
    let recommendationList: [RecommendationItem]?

    enum CodingKeys: String, CodingKey {
        case recommendationList = "content"
    }
}

// MARK: - Content
struct RecommendationItem: Codable {
    let effectiveDate: String?
    let postCode: String?
    let clientAvailability: String?
    let cuisine: String?
    let summary: String?
    let nameLocalized: String?
    let category: String?
    let country: JSONNull?
    let addressline2: String?
    let state: String?
    let originalAddressLongitude: String?
    let imageUrl3: String?
    let rank: String?
    let originalName: String?
    let originalAddressLine3: String?
    let originalAddressState: String?
    let description: String?
    let originalAddressCountry: JSONNull?
    let restaurantContactNumber: String?
    let sourceURL: String?
    let reservationOpenings: String?
    let restaurantContactCountryCode: String?
    let imageUrl4: String?
    let qualityRating: String?
    let contentSource: String?
    let originalAddressLine1: String?
    let contentTags: String?
    let switchflySharedID: String?
    let lattitude: String?
    let addressline3: String?
    let hasPerk: String?
    let longitude: String?
    let city: String?
    let expiryDate: String?
    let sabreID: String?
    let contentName: String?
    let reviewCount: String?
    let addressline1: String?
    let imageUrl1: String?
    let originalAddressLatitude: String?
    let tier: String?
    let contentID: String?
    let originalAddressCity: String?
    let originalAddressLine2: String?
    let defaultImage: String?
    let originalAddressPostCode: String?
    let originalSummary: String?
    let neighbourhood: String?
    let priceRating: String?
    let imageUrl2: String?
    let perkVendorPromoURL: String?
    let expediaID: String?
    enum CodingKeys: String, CodingKey {
        case effectiveDate = "effectiveDate"
        case postCode = "postCode"
        case clientAvailability = "ClientAvailability"
        case cuisine = "cuisine"
        case summary = "summary"
        case nameLocalized = "NameLocalized"
        case category = "category"
        case country = "country"
        case addressline2 = "addressline_2"
        case state = "state"
        case originalAddressLongitude = "originalAddressLongitude"
        case imageUrl3 = "imageUrl3"
        case rank = "rank"
        case originalName = "originalName"
        case originalAddressLine3 = "originalAddressLine_3"
        case originalAddressState = "originalAddressState"
        case description = "description"
        case originalAddressCountry = "originalAddressCountry"
        case restaurantContactNumber = "restaurantContactNumber"
        case sourceURL = "sourceUrl"
        case reservationOpenings = "reservationOpenings"
        case restaurantContactCountryCode = "restaurantContactCountryCode"
        case imageUrl4 = "imageUrl4"
        case qualityRating = "qualityRating"
        case contentSource = "contentSource"
        case originalAddressLine1 = "originalAddressLine_1"
        case contentTags = "contentTags"
        case switchflySharedID = "SwitchflySharedID"
        case lattitude = "lattitude"
        case addressline3 = "addressline_3"
        case hasPerk = "hasPerk"
        case longitude = "longitude"
        case city = "city"
        case expiryDate = "expiryDate"
        case sabreID = "SabreID"
        case contentName = "contentName"
        case reviewCount = "reviewCount"
        case addressline1 = "addressline_1"
        case imageUrl1 = "imageUrl1"
        case originalAddressLatitude = "originalAddressLatitude"
        case tier = "tier"
        case contentID = "contentId"
        case originalAddressCity = "originalAddressCity"
        case originalAddressLine2 = "originalAddressLine_2"
        case defaultImage = "defaultImage"
        case originalAddressPostCode = "originalAddressPostCode"
        case originalSummary = "originalSummary"
        case neighbourhood = "neighbourhood"
        case priceRating = "priceRating"
        case imageUrl2 = "imageUrl2"
        case perkVendorPromoURL = "PerkVendorPromoURL"
        case expediaID = "ExpediaID"
    }
}
