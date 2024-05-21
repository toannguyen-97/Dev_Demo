//
//  CreateRequest.swift
//  GMA
//
//  Created by Hoan Nguyen on 18/05/2022.
//

import Foundation

let dining_Quandoo_Suffix_LastName = "-"

// MARK: - CreateRequest
class CreateRequest: Codable {
    var partyID: String?
    var caseID, requestID: String?
    var sourceSystem, contactMethod, requestType, caseStatus: String?
    var restaurantName, partners, reservationID, status: String?
    var serviceType, bookingDate, bookingEndDate, salutation, firstName: String?
    var lastName, emailAddress, notificationPreference, requestReferenceID: String?
    var externalReferenceID, notes: String?
    var pax: Pax?
    var address: Address?
    var latitude, longitude, travelType, vehicleType: String?
    var phoneNumber, airportCode, carrierCode, carrierNumber: String?
    var travelDate, noOfBags, baseAmount, baseCurrency: String?
    var currency, totalAmount: String?
    var dropAddress: Address?
    var region: String?
    var paramlists: Paramlists?
    
    enum CodingKeys: String, CodingKey {
        case partyID = "partyId"
        case caseID = "caseId"
        case requestID = "requestId"
        case sourceSystem, contactMethod, requestType, caseStatus, restaurantName
        case partners = "Partners"
        case reservationID = "reservationId"
        case status, serviceType, bookingDate,  bookingEndDate, salutation, firstName, lastName, emailAddress, notificationPreference
        case requestReferenceID = "requestReferenceId"
        case externalReferenceID = "externalReferenceId"
        case notes
        case pax = "Pax"
        case address = "Address"
        case latitude, longitude, travelType, vehicleType
        case phoneNumber = "PhoneNumber"
        case airportCode, carrierCode, carrierNumber, travelDate, noOfBags, baseAmount, baseCurrency, currency, totalAmount, region
        case dropAddress = "DropAddress"
        case paramlists
    }
    init() {
        
    }
    static func createDataToSend() -> CreateRequest{
        let request = CreateRequest()
        if let partyID = CurrentSession.share.aspireProfile?.partyID {
            request.partyID = partyID
        }
        request.sourceSystem = "Concierge"
        request.contactMethod = "Digital"
        request.serviceType = "CONCIERGE"
        if let email = CurrentSession.share.aspireProfile?.emails?.first?.emailAddress {
            request.emailAddress = email
        }
        if let fName = CurrentSession.share.aspireProfile?.firstName {
            request.firstName = fName
        }
        if let lName = CurrentSession.share.aspireProfile?.lastName {
            request.lastName = lName
        }
        if let phone = CurrentSession.share.aspireProfile?.phones?.first?.phoneCountryCode, let number = CurrentSession.share.aspireProfile?.phones?.first?.phoneNumber {
            request.phoneNumber = phone + " " + number
        }
        request.notificationPreference = "Email"
        return request
    }
    
    init(requestItem: RequestItem, isBookAgain: Bool = false) {
        if let partyId = CurrentSession.share.aspireProfile?.partyID {
            partyID = partyId
        }
        caseID = requestItem.caseID
        requestID = requestItem.requestID
        requestReferenceID = requestItem.requestReferenceID
        requestType = requestItem.requestType
        sourceSystem = "Concierge"
        contactMethod = "Digital"
        serviceType = "CONCIERGE"
        notificationPreference = "Email"
        emailAddress = requestItem.paramlists?.email
        phoneNumber = requestItem.paramlists?.mobileNumber
        firstName = requestItem.firstName
        lastName = requestItem.lastName
        if firstName == "" && lastName == "" {
            firstName = requestItem.reserveName
        }
        notes = requestItem.requestNotes
        restaurantName = requestItem.vendorName
        partners = requestItem.popularVendor
        status = requestItem.status
        longitude = requestItem.longitude
        latitude = requestItem.latitude
        if isBookAgain {
            // remove caseID , refer ID...
            caseID = nil
            requestReferenceID = nil
            bookingDate = nil
            bookingEndDate = nil
        }else {
            bookingDate = requestItem.eventStartDate
            bookingEndDate = requestItem.eventEndDate
        }
        
        pax = Pax(adults: "\(requestItem.numberInParty)", childs: "0")
        address = Address()
        address?.addressLine1 = requestItem.vendorAddress.vendorAddr1
        address?.addressLine2 = requestItem.vendorAddress.vendorAddr2
        address?.city = requestItem.vendorAddress.vendorCity
        address?.state = requestItem.vendorAddress.vendorState
        address?.country = requestItem.vendorAddress.vendorCountry
        address?.postalCode = requestItem.vendorAddress.vendorPostalCode
        paramlists = requestItem.paramlists?.copy() as? Paramlists
//        var phoneNumber, airportCode, carrierCode, carrierNumber: String?
//        var travelDate, noOfBags, baseAmount, baseCurrency: String?
//        var currency, totalAmount: String?
    }
    
    func getAddressString() -> String {
        var address = self.address?.addressLine1 ?? ""
        if address.isEmpty {
            address = self.address?.addressLine2 ?? ""
        }
        if let pcode = self.address?.postalCode, !pcode.isEmpty {
            address = address + ", " + pcode
        }
        if let city = self.address?.city {
            address = address + " " + city
        }
        if let country = self.address?.country {
            address = address + ", " + country
        }
        if address.prefix(2) == ", " {
            address = address.withReplacedCharacters(", ", by: "")
        }
        return address
    }
    
    func setRequestTypeFromCategory(categories: [String]?) {
        let officalCategories = [ diningCategory, attractionCategory, nightLifeCategory, experiencesCategory, cruisesCategory, spaCategory, hotelCategory, vacationPackagesCategory, shoppingCategory]
        var categoryName = ""
        if let contentTypes = categories, let fCate = contentTypes.first {
            var cate: String?
            contentTypes.forEach { ctype in
                if ctype == CurrentSession.share.categorySelected {
                    cate = ctype
                }
            }
            if let catg = cate {
                categoryName = catg
            }else {
                contentTypes.forEach({ str in
                    if officalCategories.contains(str) {
                        categoryName = str
                    }
                })
                if categoryName.isEmpty {
                    categoryName = fCate
                }
            }
        }
        paramlists = Paramlists()
        paramlists!.category = categoryName
        switch categoryName.lowercased() {
        case "attractions":
            self.requestType = "T Travel Services"
        case "dining":
            self.requestType = "D Restaurant"
        case "nightlife":
            self.requestType = "E Nightlife"
        case "car":
            self.requestType = "T CAR RENTAL"
        case "spas":
            self.requestType = "P Spa/Salon"
        case "hotels":
            self.requestType = "T HOTEL AND B&B"
        case "experiences":
            self.requestType = "E Experiences"
        case "cruises":
            self.requestType = "T Cruise"
        case "vacation packages":
            self.requestType = "X Special travel package (Via partners)"
        case "shopping":
            self.requestType = "SHOPPING"
        default:
            self.requestType = "O CLIENT SPECIFIC"
            break
        }
    }
}

// MARK: - Address
struct Address: Codable {
    var addressLine1, addressLine2, city, state: String?
    var country, postalCode: String?

    enum CodingKeys: String, CodingKey {
        case addressLine1 = "AddressLine1"
        case addressLine2 = "AddressLine2"
        case city = "City"
        case state = "State"
        case country = "Country"
        case postalCode = "PostalCode"
    }
    
    init() {
        
    }
}

// MARK: - Pax
struct Pax: Codable {
    var noOfAdults: String = "0"
    var noOfChilds: String = "0"
    
    init(adults: String, childs: String = "0") {
        noOfChilds = childs
        noOfAdults = adults
    }
    
    func numberInParty() -> Int {
        if let child = Int(noOfChilds), let adult = Int(noOfAdults) {
            return child + adult
        }
        return 0
    }
}

// MARK: - Paramlists
class Paramlists: Codable, NSCopying {
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Paramlists(email: email, mobileNumber: mobileNumber, topicImage: topicImage, topicId: topicId, typeOfService: typeOfService, hotelRooms: hotelRooms?.map{ $0.copy() as! HotelRoom }, region: region, category: category, city: city, country:  country)
        return copy
    }
    
    var email, mobileNumber: String?
    var topicImage: String?
    var topicId, typeOfService: String?
    var hotelRooms: [HotelRoom]?
    var region, category: String?
    var city, country: String?

    enum CodingKeys: String, CodingKey {
        case email, mobileNumber, topicImage
        case topicId
        case typeOfService, hotelRooms, region, category
        case city, country
    }
    
    init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let str = try? values.decode(String.self, forKey: .email) {
            email = str
        }
        if let str = try? values.decode(String.self, forKey: .mobileNumber) {
            mobileNumber = str
        }
        if let str = try? values.decode(String.self, forKey: .topicImage) {
            topicImage = str
        }
        if let str = try? values.decode(String.self, forKey: .topicId) {
            topicId = str
        }
        if let str = try? values.decode(String.self, forKey: .typeOfService) {
            typeOfService = str
        }
        if let str = try? values.decode(String.self, forKey: .region) {
            region = str
        }
        if let str = try? values.decode(String.self, forKey: .category) {
            category = str
        }
        if let str = try? values.decode(String.self, forKey: .city) {
            city = str
        }
        if let str = try? values.decode(String.self, forKey: .country) {
            country = str
        }
        if let hotel = try? values.decode([HotelRoom].self, forKey: .hotelRooms) {
            hotelRooms = hotel
        }else if let hotelString = try? values.decode(String.self, forKey: .hotelRooms) {
            if let jsonData = hotelString.data(using: .utf8) {
                hotelRooms = try JSONDecoder().decode([HotelRoom].self, from: jsonData)
            }
        }
    }

    init(email: String?, mobileNumber: String?, topicImage: String?, topicId: String?, typeOfService: String?, hotelRooms: [HotelRoom]?, region: String?, category: String?, city: String?, country: String?) {
        self.email = email
        self.mobileNumber = mobileNumber
        self.topicImage = topicImage
        self.topicId = topicId
        self.typeOfService = typeOfService
        self.hotelRooms = hotelRooms
        self.region = region
        self.category = category
        self.city = city
        self.country = country
    }
}

// MARK: - HotelRoom
class HotelRoom: Codable, NSCopying {
   
    func copy(with zone: NSZone? = nil) -> Any {
        let copy  = HotelRoom(adults: adults, childs: childs)
        return copy
    }
    
    var adults, childs: Int

    init(adults: Int, childs: Int) {
        self.adults = adults
        self.childs = childs
    }
}
