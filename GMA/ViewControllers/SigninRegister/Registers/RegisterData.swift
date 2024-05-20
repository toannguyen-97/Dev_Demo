//
//  RegisterData.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//

import Foundation
class RegisterData {
    static var share = RegisterData()

    var accessCodeAES: String?
    var emailAES: String?
    var pswAES: String?
    var secretKey: String?
}
