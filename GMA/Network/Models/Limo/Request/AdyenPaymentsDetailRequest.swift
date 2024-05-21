//
//  AdyenPaymentsDetailRequest.swift
//  GMA
//
//  Created by dat.tran on 3/5/24.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let requestAdyenPaymentsDetail = try? JSONDecoder().decode(RequestAdyenPaymentsDetail.self, from: jsonData)

import Foundation

// MARK: - RequestAdyenPaymentsDetail
struct AdyenPaymentsDetailRequest: EncodableParameters {
    let details: AdyenPaymentsDetails?
    let paymentData: String?

    enum CodingKeys: String, CodingKey {
        case details = "details"
        case paymentData = "paymentData"
    }
}

// MARK: - Details
struct AdyenPaymentsDetails: Codable {
    let md: String?
    let paRes: String?
    let payload: String?
    let redirectResult: String?
    let queryString: String?
    let paymentResponse: String?
    let merchantData: String?

    enum CodingKeys: String, CodingKey {
        case md = "MD"
        case paRes = "PaRes"
        case payload = "payload"
        case redirectResult = "redirectResult"
        case queryString = "queryString"
        case paymentResponse = "paymentResponse"
        case merchantData = "merchantData"
    }
}
