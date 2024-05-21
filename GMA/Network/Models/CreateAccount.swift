//
//  CreateAccount.swift
//  GMA
//
//  Created by Saven Developer on 1/25/22.
//

import Foundation

struct CreateAccount: Codable {
    let partyID, message: String
    
    enum CodingKeys: String, CodingKey {
        case partyID = "partyId"
        case message
    }
    
}
