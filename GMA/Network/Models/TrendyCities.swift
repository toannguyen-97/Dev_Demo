//
//  TrendyCities.swift
//  GMA
//
//  Created by Hoan Nguyen on 16/03/2022.
//

import Foundation

// MARK: - Welcome
struct TrendyCities: Codable {
    let topTrends: TopTrends
}

// MARK: - TopTrends
struct TopTrends: Codable {
    let trendCity: [TrendCity]
}

// MARK: - TrendCity
struct TrendCity: Codable {
    let topicID: Int
    let city: String
    let country: String?
    let trendCityDescription, facts: String?
    let image: String?
    let notes: String?
    let noOfRequests: Int
    let monthlyAverage, averageDifference: Double
    let rank: Int
    let imageMarketImage2: String?

    enum CodingKeys: String, CodingKey {
        case topicID = "topicId"
        case city, country
        case trendCityDescription = "description"
        case facts, image, notes, noOfRequests, monthlyAverage, averageDifference, rank
        case imageMarketImage2 = "INDEX_MARKET_IMAGE_2"
    }
}
