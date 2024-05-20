//
//  OpenWeatherMapServices.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 3/1/22.
//

import Foundation
import CoreLocation

class  OpenWeatherMapServices {
    
    func getWeatherOfCitiWith(location:CLLocation, unit: OpenWeatherUnit, completion:@escaping(Result<OpenWeatherMap, Error>) -> Void) {
        AspireConnection.shared.request(OpenWeatherMapRouter.getWeatherOfCitiWith(lat: location.coordinate.latitude, long: location.coordinate.longitude, unit: unit)) { (data, error) in
            if error != nil{
                print(error!)
                completion(.failure(error!))
            }else{
                if let dataJson = data{
                    do {
                        let jsonResponse = try JSONDecoder().decode(OpenWeatherMap.self, from: dataJson)
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
    
    func getWeatherWith(cityName: String, unit: OpenWeatherUnit, completion:@escaping(Result<OpenWeatherMap, Error>) -> Void) {
        AspireConnection.shared.request(OpenWeatherMapRouter.getWeatherWith(cityName: cityName, unit: unit)) { (data, error) in
            if error != nil{
                print(error!)
                completion(.failure(error!))
            }else{
                if let dataJson = data{
                    do {
                        let jsonResponse = try JSONDecoder().decode(OpenWeatherMap.self, from: dataJson)
                        completion(.success(jsonResponse))
                    } catch {
                        print("Response successful. But unable to decode the data!"+error.localizedDescription)
                        completion(.failure(error))
                    }
                }else{
                    completion(.failure(NetworkError.unknown))
                }
            }
        }
    }
}
