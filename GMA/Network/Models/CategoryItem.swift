//
//  Category.swift
//  GMA
//
//  Created by Hoan Nguyen on 15/04/2022.
//

import Foundation

var childStringKey = "childs"
var adultStringKey = "adults"

let poiTypeString = "POI Type"
let perkContentTypeString =  "Perk Content Type"
let regionString = "Region"
let hotelTypeString = "Hotel Type"

let offerCategoryType = "Perks"
let offerCategoryName = "Offers"
let diningCategory = "Dining"
let attractionCategory = "Attractions"
let nightLifeCategory = "Nightlife"
let experiencesCategory = "Experiences"
let cruisesCategory = "Cruises"
let benefitsCategory = "Benefits"
let spaCategory = "Spas"
let hotelCategory = "Hotels"
let vacationPackagesCategory = "Vacation Packages"
let carCategory = "Car Rental"
let transportationCategory = "Transportation"
let flightsCategory = "Flights"
let golfCategory = "Golf"
let shoppingCategory = "Shopping"
let limoCategory = "Limo"

struct CategoryItem: Codable {
        
    var categoryName : String
    var categoryDescription: String
    var categoryImage: String
    var categoryKey: String
    
    init(categoryName: String, categoryDescription: String, categoryImage: String, categoryKey: String) {
        self.categoryName = categoryName
        self.categoryDescription = categoryDescription
        self.categoryImage = categoryImage
        self.categoryKey = categoryKey
    }
    
    init(){
        self.categoryName = ""
        self.categoryDescription = ""
        self.categoryImage = ""
        self.categoryKey = ""
    }
}
