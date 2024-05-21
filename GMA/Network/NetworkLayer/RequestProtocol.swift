//
//  RequestProtocol.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/13/22.
//

import Foundation
import Alamofire


protocol RequestProtocol: URLRequestConvertible {
    /// The target's base `URL`.
    var baseURLString: String { get }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP method used in the request.
    var method: HTTPMethod { get }
    
    /// The headers to be used in the request.
    var headers: HTTPHeaders? { get }
    
    var params: Parameters? { get }
    
    var body: Parameters? { get }
    
    var paramsEncoding: ParameterEncoding { get }
    
    // hour
    var cacheConfig: CacheConfig { get }
    
}
extension RequestProtocol {
    func asURLRequest() throws -> URLRequest {
        // Construct url
        let baseURL = URL(string: baseURLString)!
        // Append path
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        
        // Determine HTTP method
        urlRequest.httpMethod = method.rawValue
        
        // Set common headers
        urlRequest.headers = headers ?? [:]
        // Add http body to request
        if let body = body {
            do {
                if isFormURLEncoding() {
                    urlRequest.httpBody = self.encodeParameters(body: body)
                }else {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                }
            } catch (_) {
                print("APIRouter: Failed to parse body into request.")
            }
        }
        // Add query parameters to request
        if let parameters = params {
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
    
    private func percentEscapeString(_ string: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet)!
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
    
    private func encodeParameters(body: Parameters)-> Data? {
        let parameterArray = body.map { (arg) -> String in
            return "\(arg.key)=\(self.percentEscapeString(arg.value as! String))"
        }
        return parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
    }
    
    private func isFormURLEncoding() -> Bool {
        var isFormURLEn = false
        headers?.forEach({ header in
            if header.value == "application/x-www-form-urlencoded" {
                isFormURLEn = true
                return
            }
        })
        return isFormURLEn
    }
}



struct CacheConfig {
    let cacheTime:Int    // hour
    let needRemoveWhenLogout:Bool
}



