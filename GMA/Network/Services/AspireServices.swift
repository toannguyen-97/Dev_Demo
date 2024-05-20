//
//  AspireServices.swift
//  GMA
//
//  Created by Saven Developer on 1/21/22.
//

import Foundation

class AspireServices{
    
    func getSupportAirports(completion:@escaping(Result<AirportList, Error>) -> Void){
        AspireConnection.shared.request(AspireRouter.getSupportAirports) { data, error in
            if error != nil{
                print(error!)
                completion(.failure(error!))
            }else{
                if let dataJson = data{
                    do {
                        let jsonResponse = try JSONDecoder().decode(AirportList.self, from: dataJson)
                        completion(.success(jsonResponse))
                    } catch {
                        print("Response successful. But unable to decode the data!"+error.localizedDescription)
                        completion(.failure(error))
                    }
                }else {
                    completion(.failure(NetworkError.unknown))
                }
            }
        }
    }
    
    func getCountryList(completion:@escaping(Result<[CountryDetail], Error>) -> Void){
        AspireConnection.shared.request(AspireRouter.getCountryList("")) { data, error in
            if error != nil{
                print(error!)
                completion(.failure(error!))
            }else{
                if let dataJson = data{
                    do {
                        let jsonResponse = try JSONDecoder().decode(CountryListModel.self, from: dataJson)
                        completion(.success(jsonResponse.codes))
                    } catch {
                        print("Response successful. But unable to decode the data!"+error.localizedDescription)
                        completion(.failure(error))
                    }
                }else {
                    completion(.failure(NetworkError.unknown))
                }
            }
        }
    }
    
    func getFlightInfo(flightNumber: String, flightDate: String, completion:@escaping(Result<FlightInfo, Error>) -> Void){
        AspireConnection.shared.request(AspireRouter.getFlightInfo(flightNumber: flightNumber, flightDate: flightDate)) { data, error in
            if error != nil{
                print(error!)
                completion(.failure(error!))
            }else{
                if let dataJson = data{
                    do {
                        let jsonResponse = try JSONDecoder().decode(FlightInfo.self, from: dataJson)
                        completion(.success(jsonResponse))
                    } catch {
                        print("Response successful. But unable to decode the data!"+error.localizedDescription)
                        completion(.failure(error))
                    }
                }else {
                    completion(.failure(NetworkError.unknown))
                }
            }
        }
    }
    
    func generateJWT(completion:@escaping(Result<String, Error>) -> Void) {
        OktaServices().getServiceTokenWith { (results) in
            switch results{
            case .success(_):
                AspireConnection.shared.request(AspireRouter.generateJWT) { data, error in
                    if error != nil{
                        print(error!)
                        completion(.failure(error!))
                    }else{
                        if let dataJson = data{
                            do {
                                let jsonResponse = try JSONDecoder().decode(ChatJWT.self, from: dataJson)
                                completion(.success(jsonResponse.data.token))
                            } catch {
                                print("Response successful. But unable to decode the data!"+error.localizedDescription)
                                completion(.failure(error))
                            }
                        }else {
                            completion(.failure(NetworkError.unknown))
                        }
                    }
                }
            case.failure(_):
                completion(.failure(NetworkError.unknown))
            }
        }
    }
}

