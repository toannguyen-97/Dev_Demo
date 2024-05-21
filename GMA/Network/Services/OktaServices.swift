//
//  OktaServices.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/16/22.
//

import Foundation

class OktaServices {

    func revokeUserToken() {
        guard let userToken = CurrentSession.share.userToken?.accessToken else {
            return
        }
        AspireConnection.shared.request(OktaRouter.revokeToken(userToken)) { data, error in
        }
    }

    private func getTokenWith(userName: String, password: String, completion: @escaping(Result<Token, Error>) -> Void) {
        AspireConnection.shared.request(OktaRouter.getToken(username: userName, password: password)) { (data, error) in
            if((error == nil)) {
                if let dataJson = data {
                    do {
                        let jsonResponse = try JSONDecoder().decode(Token.self, from: dataJson)
                        completion(.success(jsonResponse))
                    } catch {
                        print("Response successful. But unable to decode the data!" + error.localizedDescription)
                        completion(.failure(APIError.invalid_grant))
                    }
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }
    }

    func refreshUserTkn(userRefreshTK: String, completion: @escaping(Result<Token, Error>) -> Void) {
        AspireConnection.shared.request(OktaRouter.refreshToken(refreshToken: userRefreshTK)) { (data, error) in
            if((error == nil)) {
                if let dataJson = data {
                    do {
                        let jsonResponse = try JSONDecoder().decode(Token.self, from: dataJson)
                        CurrentSession.share.userToken = jsonResponse
//                        BiometricManager.shared.saveBiometricData()
                        completion(.success(jsonResponse))
                    } catch {
                        completion(.failure(APIError.invalid_grant))
                    }
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }
    }

    func getServiceTokenWith(completion: @escaping(Result<Token, Error>) -> Void) {
        if let serviceTK = CurrentSession.share.serviceToken, serviceTK.isValid() {
            completion(.success(serviceTK))
        } else {
            OktaServices().getTokenWith(userName: NetworkConstants.aspireServiceAccount, password: NetworkConstants.aspireServiceSecret) { (results) in
                switch results {
                case .success(let token):
                    CurrentSession.share.serviceToken = token
                    completion(.success(token))
                case.failure(let err):
                    completion(.failure(err))
                }
            }
        }
    }

    func getUserTokenWith(username: String, psw: String, completion: @escaping(Result<Token, Error>) -> Void) {
        CurrentSession.share.userToken = nil
        let userN = NetworkConstants.organizationString + "_" + username
        OktaServices().getTokenWith(userName: userN, password: psw) { (results) in
            switch results {
            case .success(let token):
                CurrentSession.share.userToken = token
//                BiometricManager.shared.saveBiometricData()
                completion(.success(token))
            case.failure(let err):
                completion(.failure(err))
            }
        }
    }
    func refreshUserToken() async throws -> Token {
        try await withCheckedThrowingContinuation { continuatiuon in
            guard let userTK = CurrentSession.share.userToken,
                !userTK.refreshToken.isEmpty else {
                continuatiuon.resume(throwing: NetworkError.unknown)
                return
            }
            if userTK.isValid() {
                return continuatiuon.resume(returning: userTK)
            } else {
                OktaServices().refreshUserTkn(userRefreshTK: userTK.refreshToken) { (results) in
                    CurrentSession.share.userToken = nil
                    switch results {
                    case .success(let token):

                        CurrentSession.share.userToken = token
                        continuatiuon.resume(returning: token)
                    case.failure(let err):
                        continuatiuon.resume(throwing: err)
                    }
                }
            }
        }
    }
    func refreshUserToken(completion: @escaping(Result<Token, Error>) -> Void) {
        if let userTK = CurrentSession.share.userToken, !userTK.refreshToken.isEmpty {
            if userTK.isValid() {
                completion(.success(userTK))
            } else {
                OktaServices().refreshUserTkn(userRefreshTK: userTK.refreshToken) { (results) in
                    CurrentSession.share.userToken = nil
                    switch results {
                    case .success(let token):
                        CurrentSession.share.userToken = token
                        completion(.success(token))
                    case.failure(let err):
                        completion(.failure(err))
                    }
                }
            }
        } else {
            completion(.failure(NetworkError.unknown))
        }
    }


    func getOktaProfileWithEmail(email: String, completion: @escaping(Result<OktaProfile, Error>) -> Void) {
        CurrentSession.share.oktaProfile = nil
        AspireConnection.shared.request(OktaRouter.getProfile(email: email)) { (data, error) in
            if((error == nil)) {
                if let dataJson = data {
                    do {
                        let jsonResponse = try JSONDecoder().decode(OktaProfile.self, from: dataJson)
                        CurrentSession.share.oktaProfile = jsonResponse
                        completion(.success(jsonResponse))
                    } catch {
                        print(error)
                        completion(.failure(APIError.email_not_exits_okta))
                    }
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }
    }

    func setOktaPassword(with password: String, completion: @escaping(Result<OktaProfile, Error>) -> Void) {
        guard let email = CurrentSession.share.oktaProfile?.profile.email else {
            print("email not found")
            completion(.failure(APIError.email_not_exits_okta))
            return
        }
        AspireConnection.shared.request(OktaRouter.setPassword(email: email, Password: password)) { (data, error) in
            if((error == nil)) {
                if let dataJson = data {
                    do {
                        let response = try JSONDecoder().decode(OktaProfile.self, from: dataJson)
                        if !response.id.isEmpty {
                            completion(.success(response))
                        } else {
                            completion(.failure(NetworkError.unknown))
                        }
                    } catch {
                        do {
                            let response = try JSONDecoder().decode(OktaError.self, from: dataJson)
                            if let errorMessage = response.errorCauses.first?.errorSummary {
                                if errorMessage.contains(OktaError.errorOldPasswordNotCorrect) {
                                    completion(.failure(APIError.old_password_not_correct))
                                } else if errorMessage.contains(OktaError.errorNewPasswordIsCurrentPassword) {
                                    completion(.failure(APIError.password_too_recently))
                                } else if errorMessage.contains(OktaError.errorPasswordContainsPartOfEmailORFullName) {
                                    completion(.failure(APIError.password_contains_part_email_fullName))
                                } else {
                                    completion(.failure(error))
                                }
                            } else {
                                completion(.failure(error))
                            }
                        } catch {
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }
    }

    func enrollEmailFactorAutomatically(completion: @escaping(Result<EnrollEmailFactor, Error>) -> Void) {

        guard let email = CurrentSession.share.oktaProfile?.profile.email, let userID = CurrentSession.share.oktaProfile?.id else {
            completion(.failure(APIError.email_not_exits_okta))
            return
        }
        AspireConnection.shared.request(OktaRouter.enrollEmailFactorAutomatically(userID: userID, email: email)) { (data, error) in
            if((error == nil)) {
                if let dataJson = data {
                    do {
                        let jsonResponse = try JSONDecoder().decode(EnrollEmailFactor.self, from: dataJson)
                        completion(.success(jsonResponse))
                    } catch {
                        completion(.failure(NetworkError.unknown))
                    }
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }

    }

    func getListFactorEnrolled(completion: @escaping(Result<[FactorEnroll], Error>) -> Void) {
        guard let userID = CurrentSession.share.oktaProfile?.id else {
            completion(.failure(APIError.email_not_exits_okta))
            return
        }
        AspireConnection.shared.request(OktaRouter.getListFactorEnroll(userID: userID)) { data, error in
            if((error == nil)) {
                if let dataJson = data {
                    do {
                        let jsonResponse = try JSONDecoder().decode([FactorEnroll].self, from: dataJson)
                        for factor in jsonResponse {
                            if factor.factorType == "sms" {
                                CurrentSession.share.smsFactorEnroll = factor
                            }
                        }
                        completion(.success(jsonResponse))
                    } catch {
                        print(error)
                        completion(.failure(NetworkError.unknown))
                    }
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }
    }

    func enrollOktaSMSFactor(forVerification: Bool, completion: @escaping(Result<EnrollOktaSMSFactor, Error>) -> Void) {

        let userID: String!
        let phone: String!

        if forVerification == false {
            guard let pmaProfile = CurrentSession.share.pmaProfile, let userId = CurrentSession.share.oktaProfile?.id, let countryCode = pmaProfile.phoneCountryCode, let phoneNumber = pmaProfile.phoneNumber else {
                completion(.failure(APIError.email_not_exits_okta))
                return }
            userID = userId
            phone = countryCode + phoneNumber
        } else {
            guard let aspireProfile = CurrentSession.share.aspireProfile, let userId = CurrentSession.share.oktaProfile?.id, let countryCode = aspireProfile.phones?.first?.phoneCountryCode, let phoneNumber = aspireProfile.phones?.first?.phoneNumber else {
                completion(.failure(APIError.email_not_exits_okta))
                return
            }
            userID = userId
            phone = countryCode + phoneNumber
        }

        AspireConnection.shared.request(OktaRouter.enrollOktaSMSFactor(userID: userID, phoneNumber: phone)) { (data, error) in
            if((error == nil)) {
                if let dataJson = data {
                    do {
                        let jsonResponse = try JSONDecoder().decode(EnrollOktaSMSFactor.self, from: dataJson)
                        completion(.success(jsonResponse))
                    } catch {
                        do {
                            let response = try JSONDecoder().decode(OktaError.self, from: dataJson)
                            if response.errorCode == "E0000098" {
                                completion(.failure(APIError.invalid_Phone_number))
                            } else if let errorCause = response.errorCauses.first?.errorSummary, errorCause == "Invalid Phone Number" {
                                completion(.failure(APIError.invalid_Phone_number))
                            } else if response.errorSummary.contains("An SMS message was recently sent. Please wait") {
                                completion(.failure(APIError.OTPWasRecentlySent))
                            } else {
                                completion(.failure(APIError.invalid_Phone_number))
                            }

                        } catch {
                            completion(.failure(error))
                        }

                    }
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }

    }

    func forgotPasswordWithSMSFactor(completion: @escaping(Result<ForgotPasswordWithSMSFactor, Error>) -> Void) {
        if let date = CurrentSession.share.getSMSOTPTime, (Date().timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate) < 30 {
            completion(.failure(APIError.OTPWasRecentlySent))
            return
        }
        guard let mail = CurrentSession.share.oktaProfile?.profile.email else { return }
        let username = NetworkConstants.organizationString + "_" + mail
        AspireConnection.shared.request(OktaRouter.forgotPasswordWithSMSFactor(userName: username)) { (data, error) in
            if((error == nil)) {
                if let dataJson = data {
                    do {
                        CurrentSession.share.getSMSOTPTime = Date()
                        let jsonResponse = try JSONDecoder().decode(ForgotPasswordWithSMSFactor.self, from: dataJson)
                        completion(.success(jsonResponse))
                    } catch {
                        completion(.failure(NetworkError.unknown))
                    }
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }
    }

    func resetPassword(stateToken: String, password: String, completion: @escaping(Result<ResetPassword, Error>) -> Void) {

        AspireConnection.shared.request(OktaRouter.resetPassword(password: password, stateToken: stateToken)) { (data, error) in
            if((error == nil)) {
                if let dataJson = data {
                    do {
                        let jsonResponse = try JSONDecoder().decode(ResetPassword.self, from: dataJson)
                        completion(.success(jsonResponse))
                    } catch {
                        do {
                            let response = try JSONDecoder().decode(OktaError.self, from: dataJson)
                            if response.errorCode == "E0000080" {
                                completion(.failure(APIError.password_too_recently))
                            } else {
                                completion(.failure(error))
                            }
                        } catch {
                            completion(.failure(error))
                        }

                    }
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }

    }


    func activateSMSFactor(factorID: String, passCode: String, completion: @escaping(Result<ActivateSMSFactor, Error>) -> Void) {
        guard let userID = CurrentSession.share.oktaProfile?.id else { return }
        AspireConnection.shared.request(OktaRouter.activateSmsFactor(userID: userID, factorID: factorID, passcode: passCode)) { (data, error) in
            if((error == nil)) {
                if let dataJson = data {
                    do {
                        let jsonResponse = try JSONDecoder().decode(ActivateSMSFactor.self, from: dataJson)
                        CurrentSession.share.isPhoneNumberVerified = true
                        completion(.success(jsonResponse))
                    } catch {
                        completion(.failure(NetworkError.unknown))
                    }
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }

    }

    //Add response model
    func resendOTP(statetoken: String, completion: @escaping(Result<ForgotPasswordWithSMSFactor, Error>) -> Void) {
        AspireConnection.shared.request(OktaRouter.resendOTP(stateToken: statetoken)) { (data, error) in
            if((error == nil)) {
                if let dataJson = data {
                    do {
                        let jsonResponse = try JSONDecoder().decode(ForgotPasswordWithSMSFactor.self, from: dataJson)
                        completion(.success(jsonResponse))
                    } catch {
                        completion(.failure(NetworkError.unknown))
                    }
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }

    }


    func verifySMSRecoveryFactor(statetoken: String, passcode: String, completion: @escaping(Result<VerifySMSRecoveryFactor, Error>) -> Void) {
        AspireConnection.shared.request(OktaRouter.verifySMSRecoveryFactor(stateToken: statetoken, passcode: passcode)) { (data, error) in
            if((error == nil)) {
                if let dataJson = data {
                    do {
                        let jsonResponse = try JSONDecoder().decode(VerifySMSRecoveryFactor.self, from: dataJson)
                        completion(.success(jsonResponse))
                    } catch {
                        completion(.failure(NetworkError.unknown))
                    }
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }

    }

    //Add response model
    func resend(factorID: String, completion: @escaping(Result<EnrollOktaSMSFactor, Error>) -> Void) {
        var phoneNumber: String?
        if let pmaProfile = CurrentSession.share.pmaProfile, let countryCode = pmaProfile.phoneCountryCode, let number = pmaProfile.phoneNumber {
            phoneNumber = countryCode + number
        } else if let phoneObj = CurrentSession.share.aspireProfile?.phones?.first, let code = phoneObj.phoneCountryCode, let number = phoneObj.phoneNumber {
            phoneNumber = code + number
        } else {
            completion(.failure(APIError.email_not_exits_okta))
            return
        }


        guard let phone = phoneNumber, let oktaProfileID = CurrentSession.share.oktaProfile?.id else {
            return
        }
        AspireConnection.shared.request(OktaRouter.resend(phoneNumber: phone, userID: oktaProfileID, factorID: factorID)) { (data, error) in
            if((error == nil)) {
                if let dataJson = data {
                    do {
                        let jsonResponse = try JSONDecoder().decode(EnrollOktaSMSFactor.self, from: dataJson)
                        completion(.success(jsonResponse))
                    } catch {
                        completion(.failure(NetworkError.unknown))
                    }
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }

    }

    func changePassword(oldPassword: String, newPassword: String, completion: @escaping(Result<ChangePassword, Error>) -> Void) {
        guard let email = CurrentSession.share.aspireProfile?.emails?.first?.emailAddress else {
            completion(.failure(APIError.email_not_exits_okta))
            return
        }
        AspireConnection.shared.request(OktaRouter.changePassword(email: email, newP: newPassword, oldP: oldPassword)) { (data, error) in
            if((error == nil)) {
                if let dataJson = data {
                    do {
                        let jsonResponse = try JSONDecoder().decode(ChangePassword.self, from: dataJson)
                        completion(.success(jsonResponse))
                    } catch {
                        do {
                            let response = try JSONDecoder().decode(OktaError.self, from: dataJson)
                            if let errorMessage = response.errorCauses.first?.errorSummary {
                                if errorMessage.contains(OktaError.errorOldPasswordNotCorrect) {
                                    completion(.failure(APIError.old_password_not_correct))
                                } else if errorMessage.contains(OktaError.errorNewPasswordIsCurrentPassword) || errorMessage.contains(OktaError.errorPasswordUsedTooRecently) {
                                    completion(.failure(APIError.password_too_recently))
                                } else if errorMessage.contains(OktaError.errorPasswordContainsPartOfEmailORFullName) {
                                    completion(.failure(APIError.password_contains_part_email_fullName))
                                } else {
                                    completion(.failure(error))
                                }
                            } else {
                                completion(.failure(error))
                            }
                        } catch {
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }
    }

    func updatePhone(completion: @escaping(Result<EnrollOktaSMSFactor, Error>) -> Void) {
        guard let aspireProfile = CurrentSession.share.aspireProfile, let userId = CurrentSession.share.oktaProfile?.id, let countryCode = aspireProfile.phones?.first?.phoneCountryCode, let phoneNumber = aspireProfile.phones?.first?.phoneNumber else {
            completion(.failure(APIError.email_not_exits_okta))
            return
        }
        let phone = countryCode + phoneNumber
        AspireConnection.shared.request(OktaRouter.updatePhone(userID: userId, phoneNumber: phone)) { (data, error) in
            if ((error == nil)) {
                if let jsonData = data {
                    do {
                        let jsonResponse = try JSONDecoder().decode(EnrollOktaSMSFactor.self, from: jsonData)
                        print(jsonResponse)
                        completion(.success(jsonResponse))
                    } catch {
                        do {
                            let response = try JSONDecoder().decode(OktaError.self, from: jsonData)
                            if response.errorCode == "E0000098" {
                                completion(.failure(APIError.invalid_Phone_number))
                            } else if let errorCause = response.errorCauses.first?.errorSummary, errorCause == "This phone number is invalid." {
                                completion(.failure(APIError.invalid_Phone_number))
                            } else {
                                completion(.failure(error))
                            }
                        } catch {
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            } else {
                completion(.failure(error!))
            }
        }

    }

    func deleteFactor(completion: @escaping(Result<Void, Error>) -> Void) {
        guard let factorID = CurrentSession.share.smsFactorEnroll?.embedded?.phones?.first?.id, let userId = CurrentSession.share.oktaProfile?.id else {
            completion(.failure(NetworkError.badAPIRequest))
            return
        }
        AspireConnection.shared.request(OktaRouter.deleteFactor(userID: userId, factorID: factorID)) { (data, error) in
            if let err = error as? APIError, err == APIError.SuccessWithEmptyData {
                completion(.success(()))
            } else {
                completion(.failure(NetworkError.unknown))
            }
        }

    }

}



