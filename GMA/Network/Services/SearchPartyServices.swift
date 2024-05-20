//
//  PMAServices.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/16/22.
//

import Foundation


class SearchPartyServices {
    
    private func findPartyUserWith(email: String, completion:@escaping(Result<String, Error>) -> Void) {
        AspireConnection.shared.request(SearchPartyRouter.findPMAPartyID(email: email)) { (data, error) in
            if((error == nil)) {
                if let dataJson = data{
                    do {
                        if let jsonArray = try JSONSerialization.jsonObject(with: dataJson, options: []) as? [[String: Any]] {
                            if let json = jsonArray.first, let partyID = json["PartyId"] as? String {
                                completion(.success(partyID))
                            }else {
                                completion(.failure(APIError.email_not_exits_pma))
                            }
                        }else {
                            completion(.failure(APIError.email_not_exits_pma))
                        }
                    } catch let err {
                        completion(.failure(err))
                    }
                }else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    private func getPartyUserWith(partyID: String, completion:@escaping(Result<PMAProfile, Error>) -> Void) {
        AspireConnection.shared.request(SearchPartyRouter.getPMAUserProfile(partyID: partyID)) { (data, error) in
            if((error == nil)) {
                if let dataJson = data{
                    do {
                        if let jsonResponse = try JSONDecoder().decode(PMAProfiles.self, from: dataJson).first {
                            completion(.success(jsonResponse))
                        }else {
                            completion(.failure(APIError.email_not_exits_pma))
                        }
                    } catch {
                        print(error)
                        completion(.failure(APIError.email_not_exits_pma))
                    }
                }else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    
    func getPartyUserPofile(email:String, completion:@escaping(Result<PMAProfile, Error>) -> Void) {
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.getPMAProfile")
        CurrentSession.share.pmaProfile = nil
        var totalError: Error?
        var pmaProfile: PMAProfile?
        var partyID:String?
        
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
        
        partyID = CurrentSession.share.oktaProfile?.profile.partyID
        serialQueue.async {
            if partyID == nil || partyID!.isEmpty {
                if(totalError == nil) {
                    serialQueue.suspend()
                    SearchPartyServices().findPartyUserWith(email: email) { (results) in
                        switch results{
                        case .success(let pid):
                            partyID = pid
                        case.failure(let err):
                            totalError = err
                        }
                        serialQueue.resume()
                    }
                }
            }
            
        }
        
        serialQueue.async {
            if(totalError == nil && partyID != nil) {
                serialQueue.suspend()
                SearchPartyServices().getPartyUserWith(partyID: partyID!) { (results) in
                    switch results{
                    case .success(let pProfile):
                        pmaProfile = pProfile
                        CurrentSession.share.pmaProfile = pProfile
                    case.failure(let err):
                        totalError = err
                    }
                    serialQueue.resume()
                }
            }
        }
        
        serialQueue.async {
            if let pmProfile = CurrentSession.share.pmaProfile, totalError == nil {
                var accessCode: String?
                if let pm = pmProfile.partyVerifications, pm.count > 0 {
                    pm.forEach { partyV in
                        if partyV.verificationKey?.lowercased() == "accesscode" {
                            accessCode = partyV.verificationValue
                        }
                    }
                    if let aCode = accessCode {
                        serialQueue.suspend()
                        AzureServices().getProgramInfoWith(bin: aCode) { result in
                            serialQueue.resume()
                        }
                    }
                }
            }
        }
        
        
        serialQueue.async {
            if let pmaUser = pmaProfile {
                completion(.success(pmaUser))
            } else {
                completion(.failure(totalError != nil ? totalError! : NetworkError.unknown))
            }
        }
    }
}



