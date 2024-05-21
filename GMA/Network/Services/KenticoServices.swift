//
//  KenticoServices.swift
//  GMA
//
//  Created by Saven Developer on 3/7/22.
//

import Foundation

class KenticoServices{
    
    func getContent(codeName: String, depth: Int = 1, completion:@escaping(Result<[String:Any], Error>) -> Void){
        
        AspireConnection.shared.request(KenticoRouter.getContent(codeName: codeName, depth: depth)) { (data, error) in
            if error != nil{
                print(error!)
                completion(.failure(error!))
            }else{
                if let dataJson = data{
                    do {
                        if let jsonResponse = try  JSONSerialization.jsonObject(with: dataJson, options: []) as? [String: Any] {
                            completion(.success(jsonResponse))
                        } else {
                            completion(.failure(NetworkError.unknown))
                        }
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                }else {
                    completion(.failure(NetworkError.unknown))
                }
            }
        }
    }
    
    /**
                path : parent.sub1.sub2
     */
    static func getKenticoValue(dict:[String: Any]?, path:String)->Any?{
        guard let dic = dict else {return nil}
         let arr = path.components(separatedBy: ".")
         if(arr.count == 1){
             return dic[String(arr[0])]
         }
         else if (arr.count > 1){
             let p = arr[1...arr.count-1].joined(separator: ".")
             let d = dic[String(arr[0])] as? [String: Any]
             if (d != nil){
                 return getKenticoValue(dict:d!, path:p)
             }
         }
         return nil
     }
}
