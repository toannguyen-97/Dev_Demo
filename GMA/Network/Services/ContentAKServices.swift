//
//  ContentAKServices.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 3/6/22.
//

import Foundation

let pageSize = 50

class ContentAKServices {
    func filterData(dic:[String:Any],  completion:@escaping(Result<[ContentTopic], Error>) -> Void) {
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.contentfilterdata" + "\(NSDate().timeIntervalSince1970)")
        
        var totalError: Error?
        
        serialQueue.async {
            serialQueue.suspend()
            OktaServices().getServiceTokenWith { (results) in
                switch results{
                case .success(_):
                    break
                case.failure(let err):
                    totalError = err
                }
                serialQueue.resume()
            }
        }
        serialQueue.async {
            if totalError == nil {
                serialQueue.suspend()
                AspireConnection.shared.request(ContentAKRouter.search(filterDic: dic)) { (data, error) in
                    if error != nil{
                        print(error!)
                        completion(.failure(error!))
                    }else{
                        if let dataJson = data{
                            do {
                                let jsonResponse = try JSONDecoder().decode(ListContentTopic.self, from: dataJson)
                                completion(.success(jsonResponse.responses))
                            } catch {
                                print(error)
                                completion(.failure(error))
                            }
                        }else {
                            completion(.failure(NetworkError.unknown))
                        }
                    }
                    serialQueue.resume()
                }
            }else {
                completion(.failure(totalError!))
            }
        }
    }
    
    func getData(dic:[String:Any],  completion:@escaping(Result<ListContentTopic, Error>) -> Void) {
        
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.contentdatafilter" + "\(NSDate().timeIntervalSince1970)")
        var totalError: Error?
        
        serialQueue.async {
            serialQueue.suspend()
            OktaServices().getServiceTokenWith { (results) in
                switch results{
                case .success(_):
                    break
                case.failure(let err):
                    totalError = err
                }
                serialQueue.resume()
            }
        }
        serialQueue.async {
            if totalError == nil {
                serialQueue.suspend()
                AspireConnection.shared.request(ContentAKRouter.search(filterDic: dic)) { (data, error) in
                    if error != nil{
                        print(error!)
                        completion(.failure(error!))
                    }else{
                        if let dataJson = data{
                            do {
                                let jsonResponse = try JSONDecoder().decode(ListContentTopic.self, from: dataJson)
                                completion(.success(jsonResponse))
                            } catch {
                                print(error)
                                completion(.failure(error))
                            }
                        }else {
                            completion(.failure(NetworkError.unknown))
                        }
                    }
                    serialQueue.resume()
                }
            }else {
                completion(.failure(totalError!))
            }
        }
    }
    
    
    
    func getFilterDic(poiTypeToFilter: [String], perkContentTypeToFilter: [String], regionsToFilter: [String], hotelTypesToFilter: [String]) -> [[String:Any]] {
//        guard let city = CurrentSession.share.citySelected?.getValueToSendRequest()?.correctCityName() else {return []}
        let city = [""]
        guard let categoryName = CurrentSession.share.categorySelected else {return []}
        
        var contentTypeStr = categoryName
        if categoryName == benefitsCategory || categoryName == offerCategoryName {
            contentTypeStr = offerCategoryType
        }
        
        var filterDic = [
            ["name": "Content Type",
             "values": [contentTypeStr]],
            ["name": "Major Market",
             "values": [city]],
            ["name": "Client Availability",
                "values": ["Default"]]
        ]
        
        if categoryName == benefitsCategory{
            filterDic.removeAll()
            filterDic.append(contentsOf: [
                [
                    "name": "Content Type",
                    "values": [offerCategoryType]
                ],
                [
                    "name": "Perk Availability",
                    "values": ["Active"]
                ],
                [
                    "name": "Perk Type",
                    "values": ["Global Privileges"]
                ]
            ])
        } else if categoryName == cruisesCategory || categoryName == vacationPackagesCategory || categoryName == experiencesCategory{
            filterDic.removeAll(where: {$0["name"] as! String == "Major Market"})
            if categoryName == experiencesCategory {
                filterDic.append(contentsOf: [
                    [
                        "name": "Major Market",
                        "values": [city, "Global"]
                    ]
                ])
            }
        } else if categoryName == offerCategoryName {
            filterDic.append(contentsOf: [
                [
                    "name": "Perk Availability",
                    "values": ["Active"]
                ],
                [
                    "name": "Perk Type",
                    "values": ["Global Dining Collection",
                               "Hotel Privileges",
                               "Spa Privileges",
                               "Nightlife Privileges",
                               "Tactical Offer"]
                ]
            ])
        }
        
        if poiTypeToFilter.count > 0{
            filterDic.append([
                "name": poiTypeString,
                "values": poiTypeToFilter
            ])
        }
        if perkContentTypeToFilter.count > 0 {
            filterDic.append([
                "name": perkContentTypeString,
                "values":  perkContentTypeToFilter
            ])
        }
        if regionsToFilter.count > 0 {
            filterDic.append([
                "name": regionString,
                "values": regionsToFilter
            ])
        }
        
        if hotelTypesToFilter.count > 0 {
            filterDic.append([
                "name": hotelTypeString,
                "values": hotelTypesToFilter
            ])
        }
        return filterDic
    }
    
    func generateFacetsToGetDataToFilter() -> [String] {
        var facets:[String] = []
        switch CurrentSession.share.categorySelected {
        case attractionCategory, nightLifeCategory, spaCategory:
            facets = ["POI Type"]
        case cruisesCategory, vacationPackagesCategory:
            facets = ["Region"]
        case offerCategoryName, benefitsCategory:
            facets = ["Perk Content Type"]
        case hotelCategory:
            facets = ["Hotel Type"]
        case experiencesCategory, shoppingCategory:
            facets = ["POI Type", "Region"]
        default:
            break
        }
        return facets
    }
    
}


