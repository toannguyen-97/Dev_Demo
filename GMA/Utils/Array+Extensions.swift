//
//  Array+Extensions.swift
//  GMA
//
//  Created by Hoan Nguyen on 05/07/2022.
//

import Foundation


extension Array where Element: (Comparable & SignedNumeric) {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
    
    func nearest(to value: Element) -> (offset: Int, element: Element)? {
        self.enumerated().min(by: {
            abs($0.element - value) < abs($1.element - value)
        })
    }
}

extension Array {
    func toStringWithPlusItems(numberOfItemToShow: Int)-> String {
        if let strs =  self as? [String] {
            if strs.count > numberOfItemToShow {
                let arr = strs.prefix(numberOfItemToShow)
                let selectedString = arr.joined(separator: ", ")
                return "\(selectedString), +\(strs.count - numberOfItemToShow)"
            }else {
                let selectedString = strs.joined(separator: ", ")
                return "\(selectedString)"
            }
        }
        return ""
    }
    
    func stringIntdictionaryArrayToString() -> String? {
        if let dic = self as? [[String:Int]]{
            let encoder = JSONEncoder()
            if let jsonData = try? encoder.encode(dic) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    return jsonString
                }
            }
        }
        return nil
    }
}
