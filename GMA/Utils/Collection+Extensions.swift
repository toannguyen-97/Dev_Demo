//
//  Collection+Extensions.swift
//  GMA
//
//  Created by dat.tran on 4/2/24.
//

import Foundation


extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
