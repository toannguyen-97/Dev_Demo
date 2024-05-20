//
//  UIString+Extensions.swift
//  GMA
//
//  Created by dat.tran on 4/1/24.
//

import Foundation

extension String {
    var asError: NSError {
        NSError(domain: "", code: 0,
                            userInfo: [ NSLocalizedDescriptionKey: self ])
    }
}
