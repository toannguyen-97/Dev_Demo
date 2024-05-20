//
//  LanguageItem.swift
//  GMA
//
//  Created by Hoan Nguyen on 21/04/2022.
//

import Foundation

struct LanguageItem: Codable {
        
    var languageName : String
    var languageDescription: String
    var languageCode: String
    
    init(languageName: String, languageDescription: String, languageCode: String) {
        self.languageName = languageName
        self.languageDescription = languageDescription
        self.languageCode = languageCode
    }
    
    init(){
        self.languageName = ""
        self.languageDescription = ""
        self.languageCode = ""
    }
}
