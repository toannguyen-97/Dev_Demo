//
//  DiningServices.swift
//  GMA
//
//  Created by Saven Developer on 6/15/22.
//

import Foundation

class DiningServices {
    
    func getDiningList(dic:[String:Any],  completion:@escaping(Result<Dining, Error>) -> Void) {
        var paramDic = dic
        if let city =  dic["city"] as? String{
            if  city.lowercased().contains("washington") {
                paramDic.updateValue("Washington", forKey: "city")
            }else if city.lowercased().contains("napa/sonoma") {
                paramDic.updateValue("Napa", forKey: "city")
            }else if city.lowercased().contains("ho chi minh") {
                paramDic.updateValue("Ho Chi Minh City", forKey: "city")
            }else if city.lowercased().unaccent()!.contains("ha noi") {
                paramDic.updateValue("HaNoi", forKey: "city")
            }else if city.lowercased().contains("bengaluru") {
                paramDic.updateValue("Bangalore", forKey: "city")
            }
        }
        
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.diningList" + "\(NSDate().timeIntervalSince1970)")
        
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
                AspireConnection.shared.request(DiningRouter.diningList(filterDic: paramDic)) { (data, error) in
                    if error != nil{
                        print(error!)
                        completion(.failure(error!))
                    }else{
                        if let dataJson = data{
                            do {
                                let jsonResponse = try JSONDecoder().decode(Dining.self, from: dataJson)
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
    
    func getDiningDetail(diningID: String,  completion:@escaping(Result<DiningItem, Error>) -> Void) {
        
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.diningDetail" + "\(NSDate().timeIntervalSince1970)")
        
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
                AspireConnection.shared.request(DiningRouter.diningDetail(diningID: diningID)) { (data ,error) in
                    if((error == nil)) {
                        if let dataJson = data{
                            do {
                                let jsonResponse = try JSONDecoder().decode(DiningItem.self, from: dataJson)
                                completion(.success(jsonResponse))
                            } catch {
                                print(error)
                                completion(.failure(error))
                            }
                        }else {
                            completion(.failure(NetworkError.unknown))
                        }
                    } else {
                        completion(.failure(error!))
                    }
                    serialQueue.resume()
                }
            }else {
                completion(.failure(totalError!))
            }
        }
    }
    
    
    func diningCreateReservation(dic:[String:Any], completion:@escaping(Result<Void, Error>)-> Void) {
        
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.diningcreatereservation")
        var totalError: Error?
        serialQueue.async {
            serialQueue.suspend()
            OktaServices().refreshUserToken { (results) in
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
                AspireConnection.shared.request(DiningRouter.diningCreateReservation(dic: dic)) { data , error in
                    if error != nil{
                        totalError = error
                    }else{
                        if let dataJson = data{
                            do {
                                if let jsonResponse = try JSONSerialization.jsonObject(with: dataJson, options: []) as? [String: Any] {
                                    if let _ = jsonResponse["errorCode"] as? String, let message = jsonResponse["message"] as? String {
                                        totalError = CustomError(msg: message)
                                    }else if let status = jsonResponse["reservationId"] as? String, !status.isEmpty {
                                    }else {
                                        totalError = NetworkError.unknown
                                    }
                                }else {
                                    totalError = NetworkError.unknown
                                }
                            } catch {
                                print(error)
                                totalError = error
                            }
                        }else {
                            totalError = NetworkError.unknown
                        }
                    }
                    serialQueue.resume()
                }
            }
        }
        serialQueue.async {
            if let error = totalError {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    
    func diningUpdateReservation(caseId: String, requestId: String, dic:[String:Any], completion:@escaping(Result<Void, Error>)-> Void) {
        
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.diningupdatereservation")
        var totalError: Error?
        serialQueue.async {
            serialQueue.suspend()
            OktaServices().refreshUserToken { (results) in
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
                AspireConnection.shared.request(DiningRouter.diningUpdateReservation(caseId: caseId, requestId: requestId, dic: dic) ) { data , error in
                    if error != nil{
                        totalError = error
                    }else{
                        if let dataJson = data{
                            do {
                                if let jsonResponse = try JSONSerialization.jsonObject(with: dataJson, options: []) as? [String: Any] {
                                    if let _ = jsonResponse["errorCode"] as? String, let message = jsonResponse["message"] as? String {
                                        totalError = CustomError(msg: message)
                                    }else if let status = jsonResponse["reservationId"] as? String, !status.isEmpty {
                                    }else {
                                        totalError = NetworkError.unknown
                                    }
                                }else {
                                    totalError = NetworkError.unknown
                                }
                            } catch {
                                print(error)
                                totalError = error
                            }
                        }else {
                            totalError = NetworkError.unknown
                        }
                    }
                    serialQueue.resume()
                }
            }
        }
        serialQueue.async {
            if let error = totalError {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    func cancelReservation(item: RequestItem, completion:@escaping(Result<Void, Error>)-> Void) {
        
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.diningcancelreservation")
        var totalError: Error?
        serialQueue.async {
            serialQueue.suspend()
            OktaServices().refreshUserToken { (results) in
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
                AspireConnection.shared.request(DiningRouter.cancelReservation(item: item)) { data , error in
                    if error != nil{
                        totalError = error
                    }else{
                        if let dataJson = data{
                            do {
                                if let jsonResponse = try JSONSerialization.jsonObject(with: dataJson, options: []) as? [String: Any] {
                                    if let _ = jsonResponse["errorCode"] as? String, let message = jsonResponse["message"] as? String {
                                        totalError = CustomError(msg: message)
                                    }
                                }else {
                                    totalError = NetworkError.unknown
                                }
                            } catch {
                                print(error)
                                totalError = error
                            }
                        }else {
                            totalError = NetworkError.unknown
                        }
                    }
                    serialQueue.resume()
                }
            }
        }
        serialQueue.async {
            if let error = totalError {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
}


