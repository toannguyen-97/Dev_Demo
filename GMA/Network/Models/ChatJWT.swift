//
//  ChatJWT.swift
//  GMA
//
//  Created by Hoan Nguyen on 22/03/2022.
//

import Foundation

// MARK: - Welcome
struct ChatJWT: Codable {
    let isSuccess: Bool
    let data: DataClass
    let error: String?
}

// MARK: - DataClass
struct DataClass: Codable {
    let token: String
}
