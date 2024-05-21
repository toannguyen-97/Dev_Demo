//
//  AdyenPaymentResponse.swift
//  GMA
//
//  Created by dat.tran on 3/5/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let adyenPaymentsDetailResponse = try? JSONDecoder().decode(AdyenPaymentsDetailResponse.self, from: jsonData)

import Foundation

// MARK: - AdyenPaymentsDetailResponse
struct AdyenPaymentsDetailResponse: Codable {
    let additionalData: AdyenPaymentsDetailAdditionalData?
    let pspReference: String?
    let resultCode: String?
    let amount: AdyenPaymentsDetailAmount?
    let merchantReference: String?
    let paymentMethod: AdyenPaymentsDetailPaymentMethod?

    enum CodingKeys: String, CodingKey {
        case additionalData = "additionalData"
        case pspReference = "pspReference"
        case resultCode = "resultCode"
        case amount = "amount"
        case merchantReference = "merchantReference"
        case paymentMethod = "paymentMethod"
    }
}

// MARK: - AdditionalData
struct AdyenPaymentsDetailAdditionalData: Codable {
    let avsResult: String?
    let cardSummary: String?
    let networkTxReference: String?
    let refusalReasonRaw: String?
    let acquirerAccountCode: String?
    let expiryDate: String?
    let cardBin: String?
    let cvcResultRaw: String?
    let merchantReference: String?
    let acquirerReference: String?
    let issuerBin: String?
    let cardIssuingCountry: String?
    let authCode: String?
    let cardHolderName: String?
    let paymentAccountReference: String?
    let authorisationMid: String?
    let issuerCountry: String?
    let cvcResult: String?
    let avsResultRaw: String?
    let retryAttempt1ShopperInteraction: String?
    let cardPaymentMethod: String?
    let fundingSource: String?
    let acquirerCode: String?

    enum CodingKeys: String, CodingKey {
        case avsResult = "avsResult"
        case cardSummary = "cardSummary"
        case networkTxReference = "networkTxReference"
        case refusalReasonRaw = "refusalReasonRaw"
        case acquirerAccountCode = "acquirerAccountCode"
        case expiryDate = "expiryDate"
        case cardBin = "cardBin"
        case cvcResultRaw = "cvcResultRaw"
        case merchantReference = "merchantReference"
        case acquirerReference = "acquirerReference"
        case issuerBin = "issuerBin"
        case cardIssuingCountry = "cardIssuingCountry"
        case authCode = "authCode"
        case cardHolderName = "cardHolderName"
        case paymentAccountReference = "PaymentAccountReference"
        case authorisationMid = "authorisationMid"
        case issuerCountry = "issuerCountry"
        case cvcResult = "cvcResult"
        case avsResultRaw = "avsResultRaw"
        case retryAttempt1ShopperInteraction = "retry.attempt1.shopperInteraction"
        case cardPaymentMethod = "cardPaymentMethod"
        case fundingSource = "fundingSource"
        case acquirerCode = "acquirerCode"
    }
}

// MARK: - Amount
struct AdyenPaymentsDetailAmount: Codable {
    let currency: String?
    let value: Int?

    enum CodingKeys: String, CodingKey {
        case currency = "currency"
        case value = "value"
    }
}

// MARK: - PaymentMethod
struct AdyenPaymentsDetailPaymentMethod: Codable {
    let brand: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case brand = "brand"
        case type = "type"
    }
}
