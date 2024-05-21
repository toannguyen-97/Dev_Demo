//
//  RequestItem.swift
//  GMA
//
//  Created by Hoan Nguyen on 12/05/2022.
//

import Foundation


let SpecialRequirementString = "SpecialRequirements"
let emailString = "Email"
let mobileNumberString = "MobileNumber"
let topicImageString = "TopicImage"
let topicIDString = "TopicID"
let typeofServiceTreatmentString = "Type of Service / Treatment"
let hotelRoomString = "HotelRooms"

class RequestItem: Codable {
    let caseID, requestID: String?
    let requestType, caseReferenceNumber: String?
    let requestReferenceID: String?
    let contactSource, firstName, lastName, confirmationNo: String?
    let status, outcome, reservationName, dateOpened: String?
    let dateLastUpdated: String?
    let vendorName, popularVendor, eventCountry, eventCity: String?
    let eventCityOther: String?
    let eventStartDate: String?
    let numberInParty: Int
    let numberofChildren, numberofAdults, numberofSeniors, eventEndDate: String?
    let totalGrossAmount: String?
    let vendorAddress: VendorAddress
    let latitude, longitude: String?
    var requestNotes: String?
    let pickupLocation: PickupLocation
    let destination: Destination
    let departureCity, reserveName, requestPreferences, flightNumber: String?
    let childSeat, babySeat, numberOfBags, sabreLocator: String?
    let dropOffLocation: DropOffLocation
    var categoryName: String?
    var displayStatus: String?
    var paramlists: Paramlists?
    
    enum CodingKeys: String, CodingKey {
        case caseID = "caseId"
        case requestID = "requestId"
        case requestType, caseReferenceNumber
        case requestReferenceID = "requestReferenceId"
        case contactSource, firstName, lastName, confirmationNo, status, outcome, reservationName, dateOpened, dateLastUpdated, vendorName, popularVendor, eventCountry, eventCity, eventCityOther, eventStartDate, numberInParty, numberofChildren, numberofAdults, numberofSeniors, eventEndDate
        case totalGrossAmount = "TotalGrossAmount"
        case vendorAddress, latitude, longitude, requestNotes, pickupLocation, destination, departureCity, reserveName, requestPreferences, flightNumber, childSeat, babySeat, numberOfBags
        case sabreLocator = "SABRELocator"
        case dropOffLocation
        case paramlists
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.caseID = try? container.decode(String.self, forKey: .caseID)
        self.requestID = try? container.decode(String.self, forKey: .requestID)
        self.requestType = try? container.decode(String.self, forKey: .requestType)
        self.caseReferenceNumber = try? container.decode(String.self, forKey: .caseReferenceNumber)
        self.requestReferenceID = try? container.decode(String.self, forKey: .requestReferenceID)
        
        self.contactSource = try? container.decode(String.self, forKey: .contactSource)
        self.firstName = try? container.decode(String.self, forKey: .firstName)
        self.lastName = try? container.decode(String.self, forKey: .lastName)
        self.confirmationNo = try? container.decode(String.self, forKey: .confirmationNo)
        self.status = try? container.decode(String.self, forKey: .status)
        self.outcome = try? container.decode(String.self, forKey: .outcome)
        self.reservationName = try? container.decode(String.self, forKey: .reservationName)
        self.dateOpened = try? container.decode(String.self, forKey: .dateOpened)
        self.dateLastUpdated = try? container.decode(String.self, forKey: .dateLastUpdated)
        self.vendorName = try? container.decode(String.self, forKey: .vendorName)
        self.popularVendor = try? container.decode(String.self, forKey: .popularVendor)
        self.eventCountry = try? container.decode(String.self, forKey: .eventCountry)
        self.eventCity = try? container.decode(String.self, forKey: .eventCity)
        
        self.eventCityOther = try? container.decode(String.self, forKey: .eventCityOther)
        self.eventStartDate = try? container.decode(String.self, forKey: .eventStartDate)
        
        if let numberStr = try? container.decode(String.self, forKey: .numberInParty) , let number = Int(numberStr){
            self.numberInParty = number
        }else if let number = try? container.decode(Int.self, forKey: .numberInParty) {
            self.numberInParty = number
        }else {
            self.numberInParty = 0
        }
        if let number = try? container.decode(Int.self, forKey: .numberofChildren){
            self.numberofChildren = "\(number)"
        }else if let numberStr = try? container.decode(String.self, forKey: .numberofChildren) {
            self.numberofChildren = numberStr
        }else {
            self.numberofChildren = "0"
        }
        if let number = try? container.decode(Int.self, forKey: .numberofAdults){
            self.numberofAdults = "\(number)"
        }else if let numberStr = try? container.decode(String.self, forKey: .numberofAdults) {
            self.numberofAdults = numberStr
        }else {
            self.numberofAdults = "0"
        }
        if let number = try? container.decode(Int.self, forKey: .numberofSeniors){
            self.numberofSeniors = "\(number)"
        }else if let numberStr = try? container.decode(String.self, forKey: .numberofSeniors) {
            self.numberofSeniors = numberStr
        }else {
            self.numberofSeniors = "0"
        }
        if let number = try? container.decode(Int.self, forKey: .numberOfBags){
            self.numberOfBags = "\(number)"
        }else if let numberStr = try? container.decode(String.self, forKey: .numberOfBags) {
            self.numberOfBags = numberStr
        }else {
            self.numberOfBags = "0"
        }
        
        
        self.eventEndDate = try? container.decode(String.self, forKey: .eventEndDate)
        self.totalGrossAmount = try? container.decode(String.self, forKey: .totalGrossAmount)
        self.vendorAddress = try container.decode(VendorAddress.self, forKey: .vendorAddress)
        self.latitude = try? container.decode(String.self, forKey: .latitude)
        self.longitude = try? container.decode(String.self, forKey: .longitude)
        self.requestNotes = try? container.decode(String.self, forKey: .requestNotes)
        self.pickupLocation = try container.decode(PickupLocation.self, forKey: .pickupLocation)
        self.destination = try container.decode(Destination.self, forKey: .destination)
        self.departureCity = try? container.decode(String.self, forKey: .departureCity)
        self.reserveName = try? container.decode(String.self, forKey: .reserveName)
        self.requestPreferences = try? container.decode(String.self, forKey: .requestPreferences)
        self.flightNumber = try? container.decode(String.self, forKey: .flightNumber)
        self.childSeat = try? container.decode(String.self, forKey: .childSeat)
        self.babySeat = try? container.decode(String.self, forKey: .babySeat)
        self.sabreLocator = try? container.decode(String.self, forKey: .sabreLocator)
        self.dropOffLocation = try container.decode(DropOffLocation.self, forKey: .dropOffLocation)
        self.paramlists = try? container.decode(Paramlists.self, forKey: .paramlists)
    }
    
    static func requestTypeValue(requestType: String?) -> String {
        if let requestT =  requestType{
            if let index = requestTypes.firstIndex(where: { $0.lowercased() == requestT.lowercased()}) {
               return requestDisplayEN[index]
            }
        }
        return "Other"
    }
    
    func getAddressString() -> String {
        var address = self.vendorAddress.vendorAddr1.trim()
        if address.isEmpty {
            address = self.vendorAddress.vendorAddr2.trim()
        }
        address = address + (address.isEmpty ? "" : ", ") + self.vendorAddress.vendorPostalCode
        address = address + (address.isEmpty ? "" : " ") + self.vendorAddress.vendorCity
        address = address + (address.isEmpty ? "" : ", ") + self.vendorAddress.vendorCountry
        return address
    }
}

// MARK: - Destination
struct Destination: Codable {
    let destinationAddr1, destinationAddr2, destinationAddr3, destinationCity: String
    let destinationState, destinationCountry, destinationPostalCode: String
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let str = try? container.decode(String.self, forKey: .destinationAddr1) {
            self.destinationAddr1 = str
        }else {
            self.destinationAddr1 = ""
        }
        if let str = try? container.decode(String.self, forKey: .destinationAddr2) {
            self.destinationAddr2 = str
        }else {
            self.destinationAddr2 = ""
        }
        if let str = try? container.decode(String.self, forKey: .destinationAddr3) {
            self.destinationAddr3 = str
        }else {
            self.destinationAddr3 = ""
        }
        if let str = try? container.decode(String.self, forKey: .destinationCity) {
            self.destinationCity = str
        }else {
            self.destinationCity = ""
        }
        if let str = try? container.decode(String.self, forKey: .destinationState) {
            self.destinationState = str
        }else {
            self.destinationState = ""
        }
        if let str = try? container.decode(String.self, forKey: .destinationCountry) {
            self.destinationCountry = str
        }else {
            self.destinationCountry = ""
        }
        if let str = try? container.decode(String.self, forKey: .destinationPostalCode) {
            self.destinationPostalCode = str
        }else {
            self.destinationPostalCode = ""
        }
    }
}

// MARK: - DropOffLocation
struct DropOffLocation: Codable {
    let dropoffAddr1, dropoffAddr2, dropoffAddr3, dropoffCity: String
    let dropoffState, dropoffCountry, dropoffPostalCode: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let str = try? container.decode(String.self, forKey: .dropoffAddr1) {
            self.dropoffAddr1 = str
        }else {
            self.dropoffAddr1 = ""
        }
        if let str = try? container.decode(String.self, forKey: .dropoffAddr2) {
            self.dropoffAddr2 = str
        }else {
            self.dropoffAddr2 = ""
        }
        if let str = try? container.decode(String.self, forKey: .dropoffAddr3) {
            self.dropoffAddr3 = str
        }else {
            self.dropoffAddr3 = ""
        }
        if let str = try? container.decode(String.self, forKey: .dropoffCity) {
            self.dropoffCity = str
        }else {
            self.dropoffCity = ""
        }
        if let str = try? container.decode(String.self, forKey: .dropoffState) {
            self.dropoffState = str
        }else {
            self.dropoffState = ""
        }
        if let str = try? container.decode(String.self, forKey: .dropoffCountry) {
            self.dropoffCountry = str
        }else {
            self.dropoffCountry = ""
        }
        if let str = try? container.decode(String.self, forKey: .dropoffPostalCode) {
            self.dropoffPostalCode = str
        }else {
            self.dropoffPostalCode = ""
        }
    }
}

// MARK: - PickupLocation
struct PickupLocation: Codable {
    let pickupAddr1, pickupAddr2, pickupAddr3, pickupCity: String
    let pickupState, pickupCountry, pickupPostalCode: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let str = try? container.decode(String.self, forKey: .pickupAddr1) {
            self.pickupAddr1 = str
        }else {
            self.pickupAddr1 = ""
        }
        if let str = try? container.decode(String.self, forKey: .pickupAddr2) {
            self.pickupAddr2 = str
        }else {
            self.pickupAddr2 = ""
        }
        if let str = try? container.decode(String.self, forKey: .pickupAddr3) {
            self.pickupAddr3 = str
        }else {
            self.pickupAddr3 = ""
        }
        if let str = try? container.decode(String.self, forKey: .pickupCity) {
            self.pickupCity = str
        }else {
            self.pickupCity = ""
        }
        if let str = try? container.decode(String.self, forKey: .pickupState) {
            self.pickupState = str
        }else {
            self.pickupState = ""
        }
        if let str = try? container.decode(String.self, forKey: .pickupCountry) {
            self.pickupCountry = str
        }else {
            self.pickupCountry = ""
        }
        if let str = try? container.decode(String.self, forKey: .pickupPostalCode) {
            self.pickupPostalCode = str
        }else {
            self.pickupPostalCode = ""
        }
    }
    
    
}

// MARK: - VendorAddress
struct VendorAddress: Codable {
    let vendorAddr1, vendorAddr2, vendorAddr3, vendorCity: String
    let vendorState, vendorCountry, vendorPostalCode: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let str = try? container.decode(String.self, forKey: .vendorAddr1) {
            self.vendorAddr1 = str
        }else {
            self.vendorAddr1 = ""
        }
        if let str = try? container.decode(String.self, forKey: .vendorAddr2) {
            self.vendorAddr2 = str
        }else {
            self.vendorAddr2 = ""
        }
        if let str = try? container.decode(String.self, forKey: .vendorAddr3) {
            self.vendorAddr3 = str
        }else {
            self.vendorAddr3 = ""
        }
        if let str = try? container.decode(String.self, forKey: .vendorCity) {
            self.vendorCity = str
        }else {
            self.vendorCity = ""
        }
        if let str = try? container.decode(String.self, forKey: .vendorState) {
            self.vendorState = str
        }else {
            self.vendorState = ""
        }
        if let str = try? container.decode(String.self, forKey: .vendorCountry) {
            self.vendorCountry = str
        }else {
            self.vendorCountry = ""
        }
        if let str = try? container.decode(String.self, forKey: .vendorPostalCode) {
            self.vendorPostalCode = str
        }else {
            self.vendorPostalCode = ""
        }
    }
}

typealias RequestList = [RequestItem]


enum REQUEST_STATUS : String {
    case PENDING
    case CONFIRMED
    case CLOSED
    case OPEN
}

let requestDisplayEN = ["Attractions",
                        "Attractions",
                        "Flights / Airport Services",
                        "Flights / Airport Services",
                        "Flights / Airport Services",
                        "Flights / Airport Services",
                        "Limo",
                        "Flights / Airport Services",
                        "Flights / Airport Services",
                        "Flights / Airport Services",
                        "Dining",
                        "Dining",
                        "Dining",
                        "Dining",
                        "Attractions",
                        "Attractions",
                        "Attractions",
                        "Attractions",
                        "Spas",
                        "Cruises",
                        "Nightlife",
                        "Attractions",
                        "Spas",
                        "Car Rental",
                        "",
                        "Flights / Airport Services",
                        "Hotels",
                        "Limo",
                        "Golf",
                        "",
                        "Dining",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "Experiences",
                        "Attractions",
                        "Spas",
                        "Vacation Packages"]
let requestTypes = ["E THEME PARK ",
                    "E ENTERTAINMENT OTHER",
                    "T AIRPORT LOUNGE",
                    "T MEET & ASSIST",
                    "V LUGGAGE DELIVERY",
                    "V VALET PARKING",
                    "V AIRPORT TRANSFER",
                    "T VIP",
                    "I AIRPORT SERVICES",
                    "T PRIVATE JET",
                    "D FOOD ORDER",
                    "D PRIVATE CHEF",
                    "D OTHER",
                    "D WINE",
                    "C MUSEUM & GALLERY",
                    "C LOCAL EVENTS",
                    "C OTHER",
                    "C CAMPING/PARKS",
                    "P SPA/SALON",
                    "T CRUISE",
                    "E NIGHTLIFE",
                    "C SIGHTSEEING/TOURS",
                    "H WELLNESS",
                    "T CAR RENTAL",
                    "E CONCERT/THEATER",
                    "T AIRFARE",
                    "T HOTEL AND B&B",
                    "T Limo and Sedan",
                    "S GOLF",
                    "O CLIENT SPECIFIC",
                    "D RESTAURANT",
                    "O TEST",
                    "O JUNK MAIL",
                    "O DROPPED/HANGUP",
                    "O CASE MERGE",
                    "O UNAUTHENTICATED CALL/WRONG NUMBER",
                    "O CUSTOMER CALLBACK",
                    "E Experiences",
                    "T Travel Services",
                    "P Spa/Salon",
                    "X Special travel package (Via partners)"]
