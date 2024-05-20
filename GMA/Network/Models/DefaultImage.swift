//
//  DefaultImage.swift
//  GMA
//
//  Created by Hoan Nguyen on 13/11/2023.
//

import Foundation
struct DefaultImage: Codable {
        
    var name : String
    var keyValue: String
    var image: String
    
    init(name: String, keyValue: String, image: String) {
        self.name = name
        self.keyValue = keyValue
        self.image = image
    }
    
    init(){
        self.name = ""
        self.keyValue = ""
        self.image = ""
    }
}
