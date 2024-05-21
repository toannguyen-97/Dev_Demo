//
//  UserDefault+Extension.swift
//  GMA
//
//  Created by Hoan Nguyen on 11/02/2022.
//

import Foundation

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object? where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if let encryptStr = String(data: data, encoding: .utf8)?.aesEncrypt() , let encryptData = encryptStr.data(using: .utf8) {
                set(encryptData, forKey: forKey)
                synchronize()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) -> Object? where Object: Decodable {
        guard let data = data(forKey: forKey), let decryptStr = String(data: data, encoding: .utf8)?.aesDecrypt(), let decryptData = decryptStr.data(using: .utf8)  else { return nil }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: decryptData)
            return object
        } catch {
            return nil
        }
    }
}
