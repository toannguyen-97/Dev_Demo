//
//  LocationService.swift
//
//  Copyright © 2019 Aspire-Lifestyles. All rights reserved.
//

import CoreLocation
import UIKit

let kLOCATION_UPDATE = "Update location"
let kCITY_CENTER_COORDINATE = "list_city_with_center_coordinate"
let K_LOCATION_RECENT = Obfuscated.I._7.b.U.p.J.U.K.T.j._8._4.Z.m.h._5.h.y.o.M
let locationRecentCount = 10

class LocationManager: NSObject {
    static let shared = LocationManager()

    typealias LocationCompletion = (CLLocation?) -> ()


    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var currentLocationCompletion: LocationCompletion?

    override init() {
        super.init()
        configLocation()
    }

    var isPreciseLocation = true
    var currentUserASCity: ASCity?

    var exposedLocation: CLLocation? {
        return self.currentLocation
    }

    func configLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
    }

    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }

    func request() {
        let status = getAuthorizationStatus()
        DispatchQueue.global().async { [self] in
            if status == .denied || !CLLocationManager.locationServicesEnabled() {
                return
            }

            if status == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
                return
            }
            locationManager.requestLocation()
        }
    }

    func getCurrentLocation(currentLocationCompletion: @escaping LocationCompletion) {
        DispatchQueue.global().async { [self] in
            let status = getAuthorizationStatus()
            if status == .denied || status == .restricted || status == .notDetermined || !CLLocationManager.locationServicesEnabled() {
                return
            }
            self.currentLocationCompletion = currentLocationCompletion
        }
    }
    func getPlaceEnglishKey(for city: ASCity?) async -> ASCity? {
        return await withCheckedContinuation { continuation in
            if let location = city?.coordinate {
                let enGeocoder = CLGeocoder()
                enGeocoder.reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude), preferredLocale: Locale(identifier: "en")) { (placeMark, error) in
                    if let mark = placeMark?.first {
                        if let name = mark.locality?.unaccent() {
                            city?.cityNameInEnglish = name
                        } else if let country = mark.country?.unaccent() {
                            city?.cityNameInEnglish = country
                        }
                    }
                    continuation.resume(returning: city)
                }
            } else {
                continuation.resume(returning: city)
            }
        }
    }

    func getPlaceEnglishKey(for city: ASCity?, handleComplete: @escaping(ASCity?) -> Void) {
        if let location = city?.coordinate {
            let enGeocoder = CLGeocoder()
            enGeocoder.reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude), preferredLocale: Locale(identifier: "en")) { (placeMark, error) in
                if let mark = placeMark?.first {
                    if let name = mark.locality?.unaccent() {
                        city?.cityNameInEnglish = name
                    } else if let country = mark.country?.unaccent() {
                        city?.cityNameInEnglish = country
                    }
                }
                handleComplete(city)
            }
        } else {
            handleComplete(city)
        }
    }
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> ()) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
    func getPlace(for location: CLLocation?) async throws -> ASCity? {
        return try await withCheckedThrowingContinuation { continuation in
            if let location = location {
                let dgroup = DispatchGroup()
                var cityReturn: ASCity? = ASCity()
                currentUserASCity = ASCity()
                dgroup.enter()
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { [self] (placeMark, error) in
                    if let mark = placeMark?.first {
                        if let name = mark.locality?.unaccent() {
                            currentUserASCity?.name = name
                            cityReturn?.name = name
                        } else if let country = mark.country?.unaccent() {
                            currentUserASCity?.name = country
                            cityReturn?.name = country
                        }
                        let cCode = UtilServices.shared.convertCountryCode2To3(iso31661Alpha: mark.isoCountryCode)
                        currentUserASCity?.countryCode = cCode
                        currentUserASCity?.coordinate = LocationCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                        cityReturn?.countryCode = cCode
                        cityReturn?.coordinate = LocationCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    } else {
                        cityReturn = nil
                        currentUserASCity = nil
                    }
                    dgroup.leave()
                }
                dgroup.enter()
                let enGeocoder = CLGeocoder()
                enGeocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "en")) { [self] (placeMark, error) in
                    if error != nil{
                        continuation.resume(throwing: error!)
                    }
                    if let mark = placeMark?.first {
                        if let name = mark.locality?.unaccent() {
                            cityReturn?.cityNameInEnglish = name
                            currentUserASCity?.cityNameInEnglish = name
                        } else if let country = mark.country?.unaccent() {
                            cityReturn?.cityNameInEnglish = country
                            currentUserASCity?.cityNameInEnglish = country
                        }
                    }
                    dgroup.leave()
                }
                dgroup.notify(queue: .main) {
                    continuation.resume(returning: cityReturn)
                }
            } else {
                continuation.resume(returning: nil)
            }
        }

    }
    func getPlace(for location: CLLocation?, handleComplete: @escaping(ASCity?) -> Void) {
        if let location = location {
            let dgroup = DispatchGroup()
            var cityReturn: ASCity? = ASCity()
            currentUserASCity = ASCity()
            dgroup.enter()
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [self] (placeMark, error) in
                if let mark = placeMark?.first {
                    if let name = mark.locality?.unaccent() {
                        currentUserASCity?.name = name
                        cityReturn?.name = name
                    } else if let country = mark.country?.unaccent() {
                        currentUserASCity?.name = country
                        cityReturn?.name = country
                    }
                    let cCode = UtilServices.shared.convertCountryCode2To3(iso31661Alpha: mark.isoCountryCode)
                    currentUserASCity?.countryCode = cCode
                    currentUserASCity?.coordinate = LocationCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    cityReturn?.countryCode = cCode
                    cityReturn?.coordinate = LocationCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                } else {
                    cityReturn = nil
                    currentUserASCity = nil
                }
                dgroup.leave()
            }
            dgroup.enter()
            let enGeocoder = CLGeocoder()
            enGeocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "en")) { [self] (placeMark, error) in
                if let mark = placeMark?.first {
                    if let name = mark.locality?.unaccent() {
                        cityReturn?.cityNameInEnglish = name
                        currentUserASCity?.cityNameInEnglish = name
                    } else if let country = mark.country?.unaccent() {
                        cityReturn?.cityNameInEnglish = country
                        currentUserASCity?.cityNameInEnglish = country
                    }
                }
                dgroup.leave()
            }
            dgroup.notify(queue: .main) {
                handleComplete(cityReturn)
            }
        } else {
            handleComplete(nil)
        }
    }

    func locationIsCity(asCity: ASCity?) -> Bool {
        guard let types = asCity?.types else {
            return true
        }
        if types.count == 0 || types.contains("locality") {
            return true
        }
        return false
    }


    func isCanSortDataWithDistance() -> Bool {
//        if let location = LocationManager.shared.exposedLocation, let city = CurrentSession.share.citySelected, let selectedCityCenterLocation = LocationManager.shared.getCenterCoordinateFromCacheWith(city: city)?.coordinate {
//            let distance = location.distance(from: CLLocation(latitude: selectedCityCenterLocation.latitude, longitude: selectedCityCenterLocation.longitude))
//            if distance <= limitDistanceToShowFilterMeters {
//                return true
//            }
//        }
        return false
    }

    func isSameRegion() -> Bool {
//        if let location = LocationManager.shared.exposedLocation, let city = CurrentSession.share.citySelected, let selectedCityCenterLocation = LocationManager.shared.getCenterCoordinateFromCacheWith(city: city)?.coordinate {
//            let distance = location.distance(from: CLLocation(latitude: selectedCityCenterLocation.latitude, longitude: selectedCityCenterLocation.longitude))
//            if distance <= limitDistanceToShowFilterMeters {
//                return true
//            }
//        }
        return false
    }

    func getCenterCoordinatesOfCity(city: ASCity, handleComplete: @escaping(CLLocation?, String?) -> Void) {
        var keyStr = city.getValueToSendRequest() ?? ""
        if let cCode = city.countryCode {
            keyStr = keyStr + " " + cCode }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(keyStr) { placeMark, error in
            if let placeM = placeMark?.first {
                handleComplete(placeM.location, UtilServices.shared.convertCountryCode2To3(iso31661Alpha: placeM.isoCountryCode))
            } else {
                handleComplete(nil, nil)
            }
        }
    }

    func updateCitySelectedToAspireProfile() {
//        guard let aspireProfile = CurrentSession.share.aspireProfile else { return }
//        guard let appPreferences = aspireProfile.appUserPreferences, let citySelected = CurrentSession.share.citySelected else { return }
//        var haveCitySelected = false
//        for preference in appPreferences {
//            if preference.preferenceKey == citySelectedAppUserPreferencesKey {
//                preference.preferenceValue = citySelected.name
//                haveCitySelected = true
//            }
//        }
//        if haveCitySelected == false {
//            let citySelectedPreference = AppUserPreference(appUserPreferenceID: nil, preferenceKey: citySelectedAppUserPreferencesKey, preferenceValue: citySelected.name)
//            aspireProfile.appUserPreferences?.append(citySelectedPreference)
//        }
//        AzureServices().updateAspireProfile(profile: aspireProfile) { result in
//        }
    }

    // Search Location Cache
    func getLocationSearchRecents() -> [LocationSearch] {
        if let email = CurrentSession.share.aspireProfile?.emails?.first?.emailAddress?.MD5 {
            let keyStr = K_LOCATION_RECENT + email
            if let recents = UserDefaults.standard.getObject(forKey: keyStr, castTo: LocationSearchResult.self) {
                return recents.locationSearch.reversed()
            } else {
                return []
            }
        }
        return []
    }

    func addItemToLocationSearchRecents(locationItem: LocationSearch) {
        if let email = CurrentSession.share.aspireProfile?.emails?.first?.emailAddress?.MD5 {
            let keyStr = K_LOCATION_RECENT + email
            let recentLocationSearch: LocationSearchResult!
            if let recents = UserDefaults.standard.getObject(forKey: keyStr, castTo: LocationSearchResult.self) {
                recentLocationSearch = recents
            } else {
                recentLocationSearch = LocationSearchResult(locationSearch: [])
            }
            if recentLocationSearch.locationSearch.contains(where: { $0.attributedPrimaryText == locationItem.attributedPrimaryText }) {
                recentLocationSearch.locationSearch.removeAll(where: { $0.placeId == locationItem.placeId })
            }
            recentLocationSearch.locationSearch.append(locationItem)
            if recentLocationSearch.locationSearch.count > locationRecentCount {
                recentLocationSearch.locationSearch.remove(at: 0)
            }
            UserDefaults.standard.setObject(recentLocationSearch, forKey: keyStr)
        }
    }

    func cacheCityWithCenterCoordinate(city: ASCity?) {
        guard let ct = city, let _ = ct.coordinate else {
            return
        }
        var cityString = ct.getValueToSendRequest() ?? ""
        if let countryCode = ct.countryCode {
            cityString = cityString + countryCode
        }
        if var dic = UserDefaults.standard.value(forKey: kCITY_CENTER_COORDINATE) as? [String: Data] {
            if !dic.keys.contains(cityString) {
                dic[cityString] = ct.toData()
                UserDefaults.standard.set(dic, forKey: kCITY_CENTER_COORDINATE)
            }
        } else {
            let dic = [cityString: ct.toData()]
            UserDefaults.standard.set(dic, forKey: kCITY_CENTER_COORDINATE)
        }
    }

    func getCenterCoordinateFromCacheWith(city: ASCity?) -> ASCity? {
        if let dic = UserDefaults.standard.value(forKey: kCITY_CENTER_COORDINATE) as? [String: Data], let ct = city {
            var cityString = ct.getValueToSendRequest() ?? ""
            if let countryCodeT = ct.countryCode {
                cityString = cityString + countryCodeT
            }
            if let cityData = dic[cityString], let locationCoordinate = ASCity.initFromData(data: cityData)?.coordinate {
                city?.coordinate = locationCoordinate
                return city
            }
        }
        return nil
    }
}


extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
            locationManager.requestLocation()
            if let location = manager.location {
                self.currentLocation = location
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLOCATION_UPDATE), object: nil)
            }
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
            locationManager.requestLocation()
            if let location = manager.location {
                self.currentLocation = location
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLOCATION_UPDATE), object: nil)
            }
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")

        case .restricted:
            print("parental control setting disallow location data")

        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")

        default:
            print("default")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location
            if let currentCompletion = currentLocationCompletion {
                currentCompletion(location)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLOCATION_UPDATE), object: nil)


            if #available(iOS 14.0, *) {
                switch manager.accuracyAuthorization {
                case .fullAccuracy:
                    isPreciseLocation = true
                    print("Full Accuracy")
                case .reducedAccuracy:
                    isPreciseLocation = false
                    print("Reduced Accuracy")
                @unknown default:
                    print("Unknown Precise Location...")
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLOCATION_UPDATE), object: nil)
        if let currentCompletion = currentLocationCompletion {
            currentCompletion(nil)
        }
        print("Error: \(error.localizedDescription)")
    }
}
