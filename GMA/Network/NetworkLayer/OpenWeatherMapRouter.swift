//
//  OpenWeatherMapRouter.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 3/1/22.
//


import Foundation
import Alamofire

enum OpenWeatherUnit {
    case imperial   // F and miles/hour
    case metric    // C and m/s
    var localizedDescription: String{
        switch self{
        case .imperial:
            return  "imperial"
        case .metric:
            return  "metric"
        }
    }
}

enum OpenWeatherMapRouter: RequestProtocol{
    
    case getWeatherOfCitiWith(lat: Double, long:Double, unit: OpenWeatherUnit)
    case getWeatherWith(cityName: String, unit: OpenWeatherUnit)
    
    var baseURLString: String{
        return NetworkConstants.OpenWeatherMapURL
    }
    
    var path: String{
        return ""
    }
    
    var method: HTTPMethod {
        switch self {
        case .getWeatherWith:
            return .post
        default:
            return .get
        }
    }
    
    var headers: HTTPHeaders?{
        return nil
    }
    
    var params: Parameters?{
        switch self {
        case .getWeatherOfCitiWith(let lat,let long, let unit):
            return ["appid": "e7b2054dc37b1f464d912c00dd309595", "lat":"\(lat)", "lon": "\(long)", "units": unit.localizedDescription]
        case .getWeatherWith(let cityName,let unit):
            return ["appid": "e7b2054dc37b1f464d912c00dd309595", "q":"\(cityName)", "units": unit.localizedDescription]
        }
    }
    
    var body: Parameters?{
        return nil
    }
    
    var paramsEncoding: ParameterEncoding{
        return JSONEncoding.default
    }
    
    var cacheConfig: CacheConfig {
        return CacheConfig(cacheTime: 0, needRemoveWhenLogout: true)
    }
    
}

