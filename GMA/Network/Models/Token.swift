//
//  Token.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/16/22.
//

import Foundation


class Token: Codable {
    let refreshToken, scope, tokenId, tokenType: String
    let expiresTime: Int
    var accessToken: String
    var loginDate: Int?
    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
        case scope
        case tokenId = "id_token"
        case tokenType = "token_type"
        case expiresTime = "expires_in"
        case accessToken = "access_token"
        case loginDate = "loginDate"
    }
    
    func isValid() -> Bool {
        guard let lDate = self.loginDate else {
            return false
        }
        if self.accessToken == ""{
            return false
        }
        let lgDate = Date(timeIntervalSince1970: TimeInterval(lDate))
        let timeLogin  = Int(Date().timeIntervalSince(lgDate))
        if(timeLogin < self.expiresTime) {
            return true
        }else {
            return false
        }
    }
}
