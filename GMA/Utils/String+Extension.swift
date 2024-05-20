//
//  String+Extension.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/19/22.
//

import Foundation
import UIKit
import CommonCrypto
import CryptoKit

extension String {
    
    func isAlphabetic() -> Bool {
        return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
    
    func correctCityName() -> String{
        if  self.lowercased().contains("washington") {
            return "Washington DC"
        }else if self.lowercased().contains("ho chi minh") {
            return "Ho Chi Minh City"
        }else if self.lowercased().unaccent()!.contains("ha noi") {
            return "HaNoi"
        }else if self.lowercased().unaccent()!.contains("bengaluru") {
            return "Bangalore"
        }
        return self
    }
    
    func versionCompare(_ otherVersion: String) -> ComparisonResult {
        return self.compare(otherVersion, options: .numeric)
    }
    
    func convert24hToAMPM() -> String {
        let hFomatter = DateFormatter()
        hFomatter.locale = AppContants.localeLogic
        hFomatter.dateFormat = "HH:mm"
        if let date = hFomatter.date(from: self) {
            hFomatter.dateFormat = "h:mm a"
            return hFomatter.string(from: date)
        }
        hFomatter.dateFormat = "h:mm a"
        return hFomatter.string(from: Date())
    }
    
    func convertAMPMTo24h() -> String {
        let hFomatter = DateFormatter()
        hFomatter.locale = AppContants.localeLogic
        hFomatter.dateFormat = "h:mm a"
        if let date = hFomatter.date(from: self) {
            hFomatter.dateFormat = "HH:mm"
            return hFomatter.string(from: date)
        }
        hFomatter.dateFormat = "HH:mm"
        return hFomatter.string(from: Date())
    }
    
    func yyyyMMddHHmmToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = AppContants.localeLogic
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = dateFormatter.date(from: self) {
            return date
        }else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date =  dateFormatter.date(from: self) {
                return date
            }else {
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm a"
                if let date =  dateFormatter.date(from: self) {
                    return date
                }else {
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    if let date = dateFormatter.date(from: self) {
                        return date
                    } else {
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
                        if let date = dateFormatter.date(from: self) {
                            return date
                        }else{
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            return dateFormatter.date(from: self)
                        }
                    }
                }
                
            }
        }
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    
    func unaccent() -> String? {
        return self.applyingTransform(.stripDiacritics, reverse: false)
    }
    
    func toAttributeStringWith(fontName:String, fontSize:CGFloat, color:UIColor, lineSpacing: CGFloat) -> NSAttributedString {
        let trimString = self.trim()
        let attributedString = NSMutableAttributedString(string: trimString)
        if trimString.count == 0 {
            return attributedString
        }
        
        let range = NSMakeRange(0, attributedString.mutableString.length)
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize), NSAttributedString.Key.foregroundColor: color], range: range)
        
        let paragraphStyle = NSMutableParagraphStyle()
        if(lineSpacing == 0) {
            paragraphStyle.lineSpacing = Sizes.paragraphLineSpacing
        } else {
            paragraphStyle.lineSpacing = lineSpacing
        }
        paragraphStyle.lineBreakMode = .byTruncatingTail
        attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: range)
        return attributedString;
    }
    
    
    func withReplacedCharacters(_ oldChar: String, by newChar: String) -> String {
        let newStr = self.replacingOccurrences(of: oldChar, with: newChar, options: .literal, range: nil)
        return newStr
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    
    func aesEncrypt() -> String? {
        let key = AppContants.EncryptKey
        let iv = AppContants.iv
        let options = kCCOptionPKCS7Padding
        if let keyData = key.data(using: String.Encoding.utf8),
           let data = self.data(using: String.Encoding.utf8),
           let cryptData    = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) {
            
            
            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)
            
            
            
            var numBytesEncrypted :size_t = 0
            
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      (data as NSData).bytes, data.count,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)
            
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
                return base64cryptString
                
                
            }
            else {
                return nil
            }
        }
        return nil
    }
    
    func aesDecrypt() -> String? {
        let key = AppContants.EncryptKey
        let iv = AppContants.iv
        let options = kCCOptionPKCS7Padding
        if let keyData = key.data(using: String.Encoding.utf8),
           let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters),
           let cryptData    = NSMutableData(length: Int((data.length)) + kCCBlockSizeAES128) {
            
            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCDecrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)
            
            var numBytesEncrypted :size_t = 0
            
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      data.bytes, data.length,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)
            
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let unencryptedMessage = String(data: cryptData as Data, encoding:String.Encoding.utf8)
                return unencryptedMessage
            }
            else {
                return nil
            }
        }
        return nil
    }
    
    func toDictionary() -> [String:Any]?{
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                let dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                return dictonary
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func toArrayDictionary() -> [[String:Any]]?{
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                let array = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
                return array
            } catch {
                return nil
            }
        }
        return nil
    }

    
    func removeHTMLTag() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}


extension String {
    var MD5: String {
        let length = Int(CC_SHA512_DIGEST_LENGTH)
        let messageData = self.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_SHA512(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
    
    
    func htmlAttributedString(font: String, size: CGFloat, hexColor: String = Colors.whiteHexString) -> NSAttributedString? {
        let htmlTemplate = """
        <!doctype html>
        <html>
          <head>
            <style>
              body {
                color: \(hexColor);
                font-family: \(font);
                font-size: \(size)px;
                line-height: 23px;
              }
            </style>
          </head>
          <body>
            \(self.trim())
          </body>
        </html>
        """

        guard let data = htmlTemplate.data(using: .unicode) else {
            return nil
        }

        
        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
            ) else {
            return nil
        }

//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineBreakMode = .byTruncatingTail
//        paragraphStyle.lineSpacing = Sizes.paragraphLineSpacing
//        let att = NSMutableAttributedString(attributedString: attributedString)
//        let range = NSMakeRange(0, att.mutableString.length)
//        att.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: range)
        return attributedString
    }
    
    public var symbolForCurrencyCode: String? {
      let identifiers = Locale.availableIdentifiers
      guard let identifier = identifiers.first(where: { Locale(identifier: $0).currencyCode == self }) else {
        return nil
      }
      guard let symbol = Locale(identifier: identifier).currencySymbol else {
        return nil
      }
      return symbol
    }
    
    func trailingTrim(_ characterSet : CharacterSet) -> String {
        if let range = rangeOfCharacter(from: characterSet, options: [.anchored, .backwards]) {
            return self.substring(to: range.lowerBound).trailingTrim(characterSet)
        }
        return self
    }
    
}
