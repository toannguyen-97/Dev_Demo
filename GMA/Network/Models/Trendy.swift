//
//  Trendy.swift
//  GMA
//
//  Created by Hoan Nguyen on 14/04/2022.
//

import Foundation
// MARK: - Welcome
struct TrendyContent: Codable {
    let topTrends: TrendList
}

// MARK: - TopTrends
struct TrendList: Codable {
    let trend: [Trend]
}

// MARK: - Trend
struct Trend: Codable {
    let contentID: Int
    let contentName: String
    let image: String
    let category: String
    let qualityRating: String
    let location: String
    let client_availability: String

    enum CodingKeys: String, CodingKey {
        case contentID = "contentId"
        case contentName, image, category, qualityRating, location, client_availability
    }
}
