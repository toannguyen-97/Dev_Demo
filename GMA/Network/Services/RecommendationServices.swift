//
//  RecommendationServices.swift
//  GMA
//
//  Created by Hoan Nguyen on 29/03/2022.
//

import Foundation


class RecommendationServices {
    
    func getContent(dic:[String:Any],  completion:@escaping(Result<[RecommendationItem], Error>) -> Void) {
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.recommendation" + "\(NSDate().timeIntervalSince1970)")
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
                AspireConnection.shared.request(RecommendationRouter.getContent(filterDic: dic)) { data, error in
                    if error != nil{
                        print(error!)
                        completion(.failure(error!))
                    }else{
                        if let dataJson = data{
                            do {
                                let jsonResponse = try JSONDecoder().decode(Recommendation.self, from: dataJson)
                                if let recommendations = jsonResponse.topContents.recommendationList {
                                    completion(.success(recommendations))
                                }else {
                                    completion(.success([]))
                                }
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
}
