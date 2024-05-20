//
//  EncodableParameters.swift
//  GMA
//
//  Created by dat.tran on 1/12/24.
//

import Foundation
protocol EncodableParameters: Encodable {
    func toJsonString() -> [String:Any]?
}

extension EncodableParameters {
    func toJsonString() -> [String:Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return [:] }
            return dictionary
        } catch {
            return nil
        }
    }
}

