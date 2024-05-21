//
//  AppContants.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/24/22.
//

import Foundation


//Local Notification Key
let K_TEPERATURE_UNIT_CHANGE = "temperature_unit_change"
let K_DISTANCE_UNIT_CHANGE = "distance_unit_change"
let k_LANGUAGE_CHANGE = "language_change"

let keyExploreSearch = "RECENT_SEARCH_EXPLORE"
let keyRequestSearch = "RECENT_SEARCH_REQUEST"
let keyRequestFilters = "REQUEST_FILTER"
let keyPOITYPEFilters = "CATEGORY_POITYPE_FILTER"
let keySearchAroundMeDistanceFilters = "CATEGORY_AROUNDME_DISTANCE_FILTER"
let keyPerkContentTypeFilters = "CATEGORY_ContentType_FILTER"
let keyDiningCuisineFilters = "CATEGORY_Dining_Cuisines_FILTER"
let keyCruisesRegionFilters = "CATEGORY_Cruises_FILTER"
let keyDiningOnlineBookingFilters = "CATEGORY_Dining_Online_Booking_FILTER"
let keyDiningSpecialOffersFilters = "CATEGORY_Dining_Special_Offers_FILTER"
let keyHotelTypeFilters = "CATEGORY_HotelTypes_FILTER"
let keyCategorySort = "CATEGORY_SORT"

let last4Digits = "Last4Digit"
struct AppContants {
//    Static properties
    static let phoneNumberLengLimit = 18
    static let AppSmallScreenWidth = 375.0
    static let phoneSupport = "8772886503"
    static let EncryptKey =  Obfuscated.hastag.c.o.n.c.i.e.r.g.e.dot.g.m.a.dot.c.o.m.hastag._9._1.at.hastag.B._8.percent.asterisk._6.E.B.C._8._0._4._5.E._1.dash._8._4.B._3.dash.E._1._7._1.A._0.C._0._2._6.F._4.at
    static let iv = Obfuscated.a.b.s.d.e.b.g.h.i.j.k.l.m.n.o.p
    static let GOOGLEAPI_KEY = Obfuscated.A.I.z.a.S.y.D.m._6._7.u._1.B.M.Z.s.w.S.C.Q.n.J.u._3._8.C.J.T.M.X.J.q.j.Y._5.F.g.j.Y
    static let K_PHONE_VERIFICATION_MESSAGE_REPEAT_DATE = Obfuscated._5.M.R.G.m.x.F.E._0.k.V.a._2.P._4.s._1.C.F.Q
    static let phoneVerificationSMSRepeatTime:Double =  30*24*60*60
    static let defaultLanguage =  "en-UK"
    
    static let dateFormatToDisplay = "d MMM yyyy"
    static let dateFormatLogic = "yyyy-MM-dd"
    static let dayDateFormat = "EEE, d MMM yyyy"
    static let timeFormatToDisplay = "h:mm a"
    static let timeFormatLogic = "HH:mm"
    static let timeFormatPickupDate = "yyyy-MM-dd'T'HH:mm:ss"
    static let timeFormatPickupDateWithoutSS = "yyyy-MM-dd'T'HH:mm"
    static let timeMMMDYYYY = "MMM d, yyyy"
    
    static let localeLogic = Locale.init(identifier: "en_us")
    
    static var shared = AppContants()
    //
    var spaTypeOfServices = ["Body Massage", "Facial Treatment", "Foot Massage"]
    var spaTypeOfServicesEnglish = ["Body Massage", "Facial Treatment", "Foot Massage"]
    
    var cmsNoInternetTitleSystemString = "No Internet Connection"
    var cmsNoInternetMessageSystemString = "Please check your internet connection."
    var cmsOkSystemString = "Ok"
    var cmsDoneSystemString = "Done"
    var cmsSettingSystemString = "Setting"
    var cmsCancelSytemString = "Cancel"
    var cmsLocationDisableString = "Location Service Disabled"
    var cmsEnableLocationMessageString = "To enable, please go to Settings and turn on Location Service for this app."
    
    var cmsDistanceKmString = "km"
    var cmsDistanceMiString = "mi"
}

enum contentType{
    case about
    case termsOfUse
    case privacyPolicy
    
    var codeName: String{
        switch self {
        case .about:
            return "app___about"
        case .termsOfUse:
            return "app___terms_of_use"
        case .privacyPolicy:
            return "app_privacy_policy"
        }
    }
    //using this title variable for Firebase tracking
    var title: String{
        switch self {
        case .about:
            return "About"
        case .termsOfUse:
            return "Terms of Use"
        case .privacyPolicy:
            return "Privacy Policy"
        }
    }
    var path: String{
        switch self {
        case .about:
            return "app___about_body"
        case .termsOfUse:
            return "app___terms_of_use_body"
        case .privacyPolicy:
            return "app___privacy_policy_body"
        }
    }
}

enum TemperatureUnit {
    case F
    case C
    var stringValue:String {
        switch self{
        case .F:
            return "F"
        case .C:
            return  "C"
        }
    }
}

enum DistanceUnit {
    case Km
    case Mi
    
    var stringValue:String {
        switch self{
        case .Km:
            return "km"
        case .Mi:
            return  "mi"
        }
    }
}

public enum flowType{
    case registrationFlow
    case forgotPasswordFlow
    case verifyPhoneNumberFlow
}

public enum TemperatureType{
    case fahrenheit
    case Celsius
}

public enum DistanceType{
    case miles
    case kilometers
}

public enum PreferenceType{
    case cuisine
    case dietary
    case preferredChain
    case bedType
    case roomType
    case preferredVendor
    case vehicleType
    case preferredAirline
    case airlineClass
    case seat
    case homeAirport
    
    var stringValue: String{
        switch self {
        case .cuisine:
            return "Cuisine Preference"
        case .dietary:
            return "Dietary Preference"
        case .preferredChain:
            return "Hotel Preference"
        case .bedType:
            return "Bed Type"
        case .roomType:
            return "Room Type"
        case .preferredVendor:
            return "Preferred Vendor"
        case .vehicleType:
            return "Car Type Preference"
        case .preferredAirline:
            return "Airline Preference"
        case .airlineClass:
            return "Flight Class"
        case .seat:
            return "Flight Seat"
        case .homeAirport:
            return "Home Airport"
        }
    }
}

struct PreferenceItem{
    var text: String
    var value: String
    
    init(text: String, value: String) {
        self.text = text
        self.value = value
    }
    
    init(){
        self.text = ""
        self.value = ""
    }
}
