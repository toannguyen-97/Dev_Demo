//
//  CurrentSession.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/20/22.
//

import Foundation
import LPMessagingSDK

let kUSERTOKEN = "SgEjuj8qSyobnDydUp8E"
let kASPIREPROFILE = "ronviIVyZtINWaIxiNdX"
let kPROGRAMDETAIL = "GsWLRyDcXopesgtjrbtA"
let KOKTAPROFILE = "KUfbTCmxenkybMJzfwjT"

class CurrentSession {
    var firstLogin = false
    var isPhoneNumberVerified = false
    var needUpdateRequestList = true
    var needTranslateCityName =  false
    private var _userToken: Token? = nil
    private var _currentCitySelected:ASCity? {
        didSet {
            if let city = _currentCitySelected {
                guard let _ =  LocationManager.shared.getCenterCoordinateFromCacheWith(city: city) else{
                    LocationManager.shared.getCenterCoordinatesOfCity(city: city) { location, countryCode in
                        var loc: LocationCoordinate? = nil
                        if let locatn = location{
                            loc = LocationCoordinate(latitude: locatn.coordinate.latitude, longitude: locatn.coordinate.longitude)
                        }
                        LocationManager.shared.cacheCityWithCenterCoordinate(city: ASCity(name: city.name, countryCode: countryCode, coordinate: loc, types: city.types, cityNameInEnglish: city.cityNameInEnglish))
                    }
                    return
                }
            }
        }
    }
    private var _currentLanguage:String?
    private var _currentCategorySelected: String?
    
    var serviceToken: Token?{
        didSet {
            if let _ = serviceToken {
                serviceToken!.loginDate = Int(Date().timeIntervalSince1970)
            }
        }
    }
    var userToken: Token? {
        set {
            if let ut = newValue {
                ut.loginDate = Int(Date().timeIntervalSince1970)
                UserDefaults.standard.setObject(ut, forKey: kUSERTOKEN)
            } else {
                UserDefaults.standard.removeObject(forKey: kUSERTOKEN)
            }
            _userToken = newValue
        }
        get {
            if let tk = _userToken {
                return tk
            } else {
                return UserDefaults.standard.getObject(forKey: kUSERTOKEN, castTo: Token.self)
            }
        }
    }
    var getSMSOTPTime: Date?
    var programDetail: ProgramDetail?
    var oktaProfile: OktaProfile?
    var pmaProfile: PMAProfile?
    var aspireProfile: AspireProfile?
    
    var citySelected: ASCity? {
        get{
            if let city = _currentCitySelected {
                return city
            }else {
                if let data = UserDefaults.standard.data(forKey: citySelectedAppUserPreferencesKey) {
                    let cty = ASCity.initFromData(data: data)
                    _currentCitySelected = cty
                }
                return _currentCitySelected
            }
        }
        set{
            if let cty = newValue, let cCode = cty.countryCode {
                if _currentCitySelected?.name != newValue?.name || _currentCitySelected?.countryCode != cCode {
//                    ExploreHepler.share.resetAllFilterInUserDefault()
                }
                _currentCitySelected = newValue
            }else {
                if _currentCitySelected?.name != newValue?.name {
//                    ExploreHepler.share.resetAllFilterInUserDefault()
                }
                _currentCitySelected = newValue
            }
            UserDefaults.standard.set(newValue?.toData(), forKey: citySelectedAppUserPreferencesKey)
            if newValue != nil {
                FirebaseTracking.share.setUserProperty()
            }
        }
    }
    
    func setCitySelectedWithoutStore(cityName: ASCity) {
        if _currentCitySelected != nil && _currentCitySelected?.name != cityName.name {
//            ExploreHepler.share.resetAllFilterInUserDefault()
        }
        _currentCitySelected = cityName
    }
    
    var categorySelected: String? {
        get {
            if let category = _currentCategorySelected {
                return category
            }else {
                guard let aspireProfile = CurrentSession.share.aspireProfile else {return nil}
                guard let appPreferences = aspireProfile.appUserPreferences else {return nil}
                for preference in appPreferences{
                    if preference.preferenceKey == categorySelectedAppUserPreferencesKey, let categoryName =  preference.preferenceValue{
                        return categoryName
                    }
                }
                return nil
            }
        }
        set {
            if newValue != categorySelected {
                _currentCategorySelected = newValue
                AzureServices().updateCategorySelectedToAspireProfile()
            }
//            FirebaseTracking.share.logEvent(event: FirebaseEvent.category_selection, viewController: UIApplication.shared.topMostViewController(), parameter: ["category": categorySelected ?? ""])
            FirebaseTracking.share.setUserProperty()
        }
    }
    
    var currentLanguage : String {
        get {
            var language = AppContants.defaultLanguage
            if let lang = Locale.preferredLanguages.first {
                if lang == "zh-Hant-HK" {
                    language = "zh-HK"
                }else if lang.contains("zh-Hant"){
                    language = "zh-TW"
                }else if lang == "en-GB" {
                    language = "en-UK"
                }else if lang.contains("ja") {
                    language = "ja-JP"
                }else if lang.contains("ko") {
                    language = "ko-KR"
                }else if lang == "en-US" {
                    language = "en-US"
                }
            }
            if let languageInUserdefault  = UserDefaults.standard.string(forKey: languageSelectedAppUserPreferencesKey) {
                if languageInUserdefault != language {
//                    ExploreHepler.share.resetAllFilterInUserDefault()
                    CurrentSession.share.needTranslateCityName = true
                    UserDefaults.standard.set(language, forKey: languageSelectedAppUserPreferencesKey)
                    UserDefaults.standard.synchronize()
                    FirebaseTracking.share.setUserProperty()
                }
            } else {
                UserDefaults.standard.set(language, forKey: languageSelectedAppUserPreferencesKey)
                UserDefaults.standard.synchronize()
                FirebaseTracking.share.setUserProperty()
            }
            return language
        }
    }
    
    
    var isPhoneNumberUpdated:Bool {
        if let phone = self.smsFactorEnroll?.embedded?.phones?.first?.profile?.phoneNumber{
            if let phoneN = CurrentSession.share.aspireProfile?.phones?.first?.phoneNumber, let phoneCode =  CurrentSession.share.aspireProfile?.phones?.first?.phoneCountryCode {
                   let phoneNumber = phoneCode + phoneN
                if phone == phoneNumber {
                    return false
                }
                return true
            }else {
                return false
            }
        }
        return false
    }
    var smsFactorEnroll : FactorEnroll?
    
    static var share = CurrentSession()
    
    func logout()  {
        AspireConnection.shared.removeExpiredCacheToSignout()
        _userToken = nil
//        citySelected = nil
        _currentCategorySelected = nil
        // call when logout and viewwillappear of signin screen
//        CurrentSession.share.serviceToken = nil
        CurrentSession.share.needUpdateRequestList = true
        CurrentSession.share.userToken = nil
        CurrentSession.share.programDetail = nil
        CurrentSession.share.oktaProfile = nil
        CurrentSession.share.pmaProfile = nil
        CurrentSession.share.aspireProfile = nil
        CurrentSession.share.smsFactorEnroll = nil
        OktaServices().revokeUserToken()
        //logout from liveperson chat
        LPMessaging.instance.logout(unregisterType: .all) {
            print("logged out from Live Person")
        } failure: { _ in
            print("unable to log out from live person")
        }
    }
    
    func storeDataToChangeLanguage() {
        if let proDetail = CurrentSession.share.programDetail {
            UserDefaults.standard.setObject(proDetail, forKey: kPROGRAMDETAIL)
        }
        if let oktaP = CurrentSession.share.oktaProfile {
            UserDefaults.standard.setObject(oktaP, forKey: KOKTAPROFILE)
        }
        if let aspireP = CurrentSession.share.aspireProfile {
            UserDefaults.standard.setObject(aspireP, forKey: kASPIREPROFILE)
        }
    }
    
    func getDataFromChangeLanguage() {
        if let proD = UserDefaults.standard.getObject(forKey: kPROGRAMDETAIL, castTo: ProgramDetail.self) {
            CurrentSession.share.programDetail = proD
        }
        if let oktaP = UserDefaults.standard.getObject(forKey: KOKTAPROFILE, castTo: OktaProfile.self) {
            CurrentSession.share.oktaProfile = oktaP
        }
        if let aspireP = UserDefaults.standard.getObject(forKey: kASPIREPROFILE, castTo: AspireProfile.self) {
            CurrentSession.share.aspireProfile = aspireP
        }
        self.removeDataToChangeLanguage()
    }
    
    func removeDataToChangeLanguage() {
        UserDefaults.standard.removeObject(forKey: kPROGRAMDETAIL)
        UserDefaults.standard.removeObject(forKey: KOKTAPROFILE)
        UserDefaults.standard.removeObject(forKey: kASPIREPROFILE)
    }
}
