//
//  AzureServices.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/16/22.
//

import Foundation


class AzureServices {

    func getProgramInfoWith(bin: String, completion: @escaping(Result<ProgramDetail, Error>) -> Void) {
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.programinfo")

        var totalError: Error?
        var programDetail: ProgramDetail?
        serialQueue.async {
            serialQueue.suspend()
            OktaServices().getServiceTokenWith { (results) in
                switch results {
                case .success(_):
                    break
                case.failure(let err):
                    totalError = err
                }
                serialQueue.resume()
            }
        }

        serialQueue.async {
            if totalError == nil {
                serialQueue.suspend()
                AspireConnection.shared.request(AzureRouter.getProgramInfo(bin: bin)) { (data, error) in
                    if((error == nil)) {
                        if let dataJson = data {
                            do {
                                let jsonResponse = try JSONDecoder().decode(ProgramInfo.self, from: dataJson)
                                if let pDetail = jsonResponse.programDetails.first, pDetail.status == 1 {
                                    CurrentSession.share.programDetail = pDetail
                                }
                                programDetail = jsonResponse.programDetails.first
                            } catch {
                                totalError = APIError.accesscodeInvalid
                            }
                        } else {
                            totalError = NetworkError.unknown
                        }
                    } else {
                        totalError = error
                    }
                    serialQueue.resume()
                }
            }
        }


        serialQueue.async {
            if let pInfo = programDetail {
                completion(.success(pInfo))
            } else {
                completion(.failure(totalError!))
            }
        }
    }

    func loginWith(username: String, psw: String, completion: @escaping(Result<Void, Error>) -> Void) {
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.login")
        var loginError: Error?

        serialQueue.async {
            serialQueue.suspend()
            OktaServices().getOktaProfileWithEmail(email: username) { (results) in
                switch results {
                case .success(let oktaProfile):
                    if(oktaProfile.status == "LOCKED_OUT") {
                        loginError = APIError.account_locked_out
                    }
                case.failure(let err):
                    loginError = err
                }
                serialQueue.resume()
            }
        }

        serialQueue.async {
            if loginError == nil {
                serialQueue.suspend()
                OktaServices().getUserTokenWith(username: username, psw: psw) { result in
                    switch result {
                    case .success(_):
                        break
                    case.failure(let err):
                        loginError = err
                    }
                    serialQueue.resume()
                }
            }
        }

        serialQueue.async {
            if loginError == nil {
                serialQueue.suspend()
                AzureServices().getAspireProfile { results in
                    switch results {
                    case .success(_):
                        break
                    case.failure(let err):
                        loginError = err
                    }
                    serialQueue.resume()
                }
            }
        }
        serialQueue.async {
            if let error = loginError {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }

    }

    func autoLoginWithRefreshToken(completion: @escaping(Result<Void, Error>) -> Void) {
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.autologin")

        var autoLoginError: Error?
        // get aspire profile (inlcude get token with refresh token)
        serialQueue.async {
            serialQueue.suspend()
            AzureServices().getAspireProfile { results in
                switch results {
                case .success(_):
                    break
                case.failure(let err):
                    autoLoginError = err
                }
                serialQueue.resume()
            }
        }

        serialQueue.async {
            if let email = CurrentSession.share.aspireProfile?.emails?.first?.emailAddress, autoLoginError == nil {
                serialQueue.suspend()
                OktaServices().getOktaProfileWithEmail(email: email) { (results) in
                    switch results {
                    case .success(let oktaProfile):
                        if(oktaProfile.status == "LOCKED_OUT") {
                            autoLoginError = APIError.account_locked_out
                        }
                    case.failure(let err):
                        autoLoginError = err
                    }
                    serialQueue.resume()
                }
            }
        }
        serialQueue.async {
            if let error = autoLoginError {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }


    func createAccount(profileDict: [String: Any], completion: @escaping(Result<CreateAccount, Error>) -> Void) {

        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.createaccount")

        var profileError: Error?
        var createAccountResponse: CreateAccount?

        serialQueue.async {
            serialQueue.suspend()
            OktaServices().getServiceTokenWith { (results) in
                switch results {
                case .success(_):
                    break
                case.failure(let err):
                    profileError = err
                }
                serialQueue.resume()
            }
        }

        serialQueue.async {
            if profileError == nil {
                serialQueue.suspend()
                AspireConnection.shared.request(AzureRouter.createCustomer(customerInfo: profileDict)) { (data, error) in
                    if((error == nil)) {
                        if let dataJson = data {
                            do {

                                let jsonResponse = try JSONDecoder().decode(CreateAccount.self, from: dataJson)
                                createAccountResponse = jsonResponse
                            } catch let error {
                                print(error.localizedDescription)
                                profileError = APIError.accesscodeInvalid
                            }
                        } else {
                            profileError = NetworkError.unknown
                        }
                    } else {
                        profileError = error
                    }
                    serialQueue.resume()
                }
            }
        }

        serialQueue.async {
            if let response = createAccountResponse {
                completion(.success(response))
            } else {
                completion(.failure(profileError!))
            }
        }
    }

    func getAspireProfile(completion: @escaping(Result<AspireProfile, Error>) -> Void) {
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.getaspireprofile")
        var totalError: Error?
        var aspireProfile: AspireProfile?

        serialQueue.async {
            serialQueue.suspend()
            OktaServices().refreshUserToken { (results) in
                switch results {
                case .success(_):
                    break
                case.failure(let err):
                    totalError = err
                }
                serialQueue.resume()
            }
        }
        serialQueue.async {
            if totalError == nil {
                serialQueue.suspend()
                AspireConnection.shared.request(AzureRouter.getProfile) { (data, error) in
                    if error == nil {
                        if let dataJson = data {
                            do {
                                let jsonResponse = try JSONDecoder().decode(AspireProfile.self, from: dataJson)
                                aspireProfile = jsonResponse
                                CurrentSession.share.aspireProfile = jsonResponse
                                FirebaseTracking.share.setUserProperty()
                            } catch let error {
                                totalError = error
                            }
                        } else {
                            totalError = NetworkError.unknown
                        }
                    } else {
                        totalError = error
                    }
                    serialQueue.resume()
                }
            }
        }
        serialQueue.async {
            if let response = aspireProfile {
                completion(.success(response))
            } else {
                completion(.failure(totalError!))
            }
        }
    }

    func updateAspireProfile(profile: AspireProfile, completion: @escaping(Result<Void, Error>) -> Void) {
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.updateaspireprofile")
        var totalError: Error?

        serialQueue.async {
            serialQueue.suspend()
            OktaServices().refreshUserToken { (results) in
                switch results {
                case .success(_):
                    break
                case.failure(let err):
                    totalError = err
                }
                serialQueue.resume()
            }
        }

        serialQueue.async {
            if totalError == nil {
                serialQueue.suspend()
                AspireConnection.shared.request(AzureRouter.updateProfile(profile)) { (data, error) in
                    totalError = error
                    serialQueue.resume()
                }
            }
        }
        serialQueue.async {
            if let error = totalError {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func generateEmailOTP(emailID: String, type: String, completion: @escaping(Result<generateOTP, Error>) -> Void) {
//        RegisterData.share.secretKey = UUID().uuidString.lowercased()
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.generateOTP")

        var otpError: Error?
        var generateOTPResponse: generateOTP?

        serialQueue.async {
            serialQueue.suspend()
            OktaServices().getServiceTokenWith { (results) in
                switch results {
                case .success(_):
                    break
                case.failure(let err):
                    otpError = err
                }
                serialQueue.resume()
            }
        }

        serialQueue.async {
            if otpError == nil {
                serialQueue.suspend()
                AspireConnection.shared.request(AzureRouter.generateEmailOTP(email: emailID, type: type)) { (data, error) in
                    if((error == nil)) {
                        if let dataJson = data {
                            do {
                                let jsonResponse = try JSONDecoder().decode(generateOTP.self, from: dataJson)
                                if jsonResponse.OTPWasRecentlySentError() {
                                    otpError = APIError.OTPWasRecentlySent
                                } else {
                                    generateOTPResponse = jsonResponse
                                }
                            } catch {
                                otpError = APIError.accesscodeInvalid
                            }
                        } else {
                            otpError = NetworkError.unknown
                        }
                    } else {
                        otpError = error
                    }
                    serialQueue.resume()
                }
            }
        }

        serialQueue.async {
            if let response = generateOTPResponse {
                completion(.success(response))
            } else {
                completion(.failure(otpError!))
            }
        }

    }


    func validateOTP(emailID: String, otp: String, completion: @escaping(Result<generateOTP, Error>) -> Void) {

        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.validateOTP")

        var otpError: Error?
        var generateOTPResponse: generateOTP?

        serialQueue.async {
            serialQueue.suspend()
            OktaServices().getServiceTokenWith { (results) in
                switch results {
                case .success(_):
                    break
                case.failure(let err):
                    otpError = err
                }
                serialQueue.resume()
            }
        }

        serialQueue.async {
            if otpError == nil {
                serialQueue.suspend()
                AspireConnection.shared.request(AzureRouter.validateOTP(email: emailID, otp: otp)) { (data, error) in
                    if((error == nil)) {
                        if let dataJson = data {
                            do {
                                let jsonResponse = try JSONDecoder().decode(generateOTP.self, from: dataJson)
                                generateOTPResponse = jsonResponse
                            } catch {
                                otpError = APIError.accesscodeInvalid
                            }
                        } else {
                            otpError = NetworkError.unknown
                        }
                    } else {
                        otpError = error
                    }
                    serialQueue.resume()
                }
            }
        }

        serialQueue.async {
            if let response = generateOTPResponse {
                completion(.success(response))
            } else {
                completion(.failure(otpError!))
            }
        }

    }

    func updateCategorySelectedToAspireProfile() {
        guard let aspireProfile = CurrentSession.share.aspireProfile else { return }
        guard let appPreferences = aspireProfile.appUserPreferences, let categorySelected = CurrentSession.share.categorySelected else { return }
        var haveCategorySelected = false
        for preference in appPreferences {
            if preference.preferenceKey == categorySelectedAppUserPreferencesKey {
                preference.preferenceValue = categorySelected
                haveCategorySelected = true
            }
        }
        if haveCategorySelected == false {
            let categorySelectedPreference = AppUserPreference(appUserPreferenceID: nil, preferenceKey: categorySelectedAppUserPreferencesKey, preferenceValue: categorySelected)
            aspireProfile.appUserPreferences?.append(categorySelectedPreference)
        }
        AzureServices().updateAspireProfile(profile: aspireProfile) { result in
        }
    }

    func updateLanguageToAspireProfile() {
        guard let aspireProfile = CurrentSession.share.aspireProfile else { return }
        guard let appPreferences = aspireProfile.appUserPreferences else { return }
        var haveLanguageItem = false
        for preference in appPreferences {
            if preference.preferenceKey == languageSelectedAppUserPreferencesKey {
                preference.preferenceValue = CurrentSession.share.currentLanguage
                haveLanguageItem = true
            }
        }
        if haveLanguageItem == false {
            let languageSelectedPreference = AppUserPreference(appUserPreferenceID: nil, preferenceKey: languageSelectedAppUserPreferencesKey, preferenceValue: CurrentSession.share.currentLanguage)
            aspireProfile.appUserPreferences?.append(languageSelectedPreference)
        }
        AzureServices().updateAspireProfile(profile: aspireProfile) { result in
        }
    }

    func getRequestHistory(completion: @escaping(Result<RequestList, Error>) -> Void) {
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.getrequesthistory")

        var totalError: Error?

        serialQueue.async {
            serialQueue.suspend()
            OktaServices().refreshUserToken { (results) in
                switch results {
                case .success(_):
                    break
                case.failure(let err):
                    totalError = err
                }
                serialQueue.resume()
            }
        }

        if let pID = CurrentSession.share.aspireProfile?.partyID, pID.isEmpty, totalError == nil {
            serialQueue.suspend()
            AzureServices().getAspireProfile { results in
                switch results {
                case .success(_):
                    break
                case.failure(let err):
                    totalError = err
                }
                serialQueue.resume()
            }
        }

        serialQueue.async {
            if totalError == nil {
                serialQueue.suspend()
                AspireConnection.shared.request(AzureRouter.getRequestHistory) { (data, error) in
                    if error != nil {
                        print(error!)
                        completion(.failure(error!))
                    } else {
                        if let dataJson = data {
                            do {
                                let jsonResponse = try JSONDecoder().decode(RequestList.self, from: dataJson)
                                completion(.success(jsonResponse))
                            } catch {
                                print(error)
                                completion(.failure(error))
                            }
                        } else {
                            completion(.failure(NetworkError.unknown))
                        }
                    }
                    serialQueue.resume()
                }
            } else {
                completion(.failure(totalError!))
            }
        }
    }


    func cancelRequest(request: RequestItem, completion: @escaping(Result<Void, Error>) -> Void) {
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.cancelrequest")
        var totalError: Error?
        serialQueue.async {
            serialQueue.suspend()
            OktaServices().refreshUserToken { (results) in
                switch results {
                case .success(_):
                    break
                case.failure(let err):
                    totalError = err
                }
                serialQueue.resume()
            }
        }
        serialQueue.async {
            if totalError == nil {
                serialQueue.suspend()
                AspireConnection.shared.request(AzureRouter.cancelRequest(request: request)) { data, error in
                    if error != nil {
                        completion(.failure(error!))
                    } else {
                        if let dataJson = data {
                            do {
                                if let jsonResponse = try JSONSerialization.jsonObject(with: dataJson, options: []) as? [String: Any], let status = jsonResponse["status"] as? Int, status == 200 {
                                    completion(.success(()))
                                } else {
                                    completion(.failure(NetworkError.unknown))
                                }
                            } catch {
                                print(error)
                                completion(.failure(error))
                            }
                        } else {
                            totalError = NetworkError.unknown
                        }
                    }
                    serialQueue.resume()
                }
            } else {
                completion(.failure(totalError!))
            }
        }
    }

    func createRequest(request: CreateRequest, completion: @escaping(Result<Void, Error>) -> Void) {
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.createrequest")
        var totalError: Error?
        serialQueue.async {
            serialQueue.suspend()
            OktaServices().refreshUserToken { (results) in
                switch results {
                case .success(_):
                    break
                case.failure(let err):
                    totalError = err
                }
                serialQueue.resume()
            }
        }

        serialQueue.async {
            if totalError == nil {
                serialQueue.suspend()
                AspireConnection.shared.request(AzureRouter.createRequest(requestdata: request)) { data, error in
                    if error != nil {
                        totalError = error
                    } else {
                        if let dataJson = data {
                            do {
                                if let jsonResponse = try JSONSerialization.jsonObject(with: dataJson, options: []) as? [String: Any], let status = jsonResponse["status"] as? Int, status == 200 {
                                } else if let jsonResponse = try JSONSerialization.jsonObject(with: dataJson, options: []) as? [String: Any], let _ = jsonResponse["CaseID"] as? String, let mess = jsonResponse["Message"] as? String, mess.contains("Successfully") {
                                } else {
                                    totalError = NetworkError.unknown
                                }
                            } catch {
                                print(error)
                                totalError = error
                            }
                        } else {
                            totalError = NetworkError.unknown
                        }
                    }
                    serialQueue.resume()
                }
            }
        }
        serialQueue.async {
            if let error = totalError {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func updateRequest(request: CreateRequest, completion: @escaping(Result<Void, Error>) -> Void) {
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.updaterequest")
        var totalError: Error?
        serialQueue.async {
            serialQueue.suspend()
            OktaServices().refreshUserToken { (results) in
                switch results {
                case .success(_):
                    break
                case.failure(let err):
                    totalError = err
                }
                serialQueue.resume()
            }
        }

        serialQueue.async {
            if totalError == nil {
                serialQueue.suspend()
                request.sourceSystem = "Concierge"
                AspireConnection.shared.request(AzureRouter.updateRequest(requestdata: request)) { data, error in
                    if error != nil {
                        totalError = error
                    } else {
                        if let dataJson = data {
                            do {
                                if let jsonResponse = try JSONSerialization.jsonObject(with: dataJson, options: []) as? [String: Any], let msg = jsonResponse["Message"] as? String, msg.contains("Updated Successfully") {

                                } else {
                                    totalError = NetworkError.unknown
                                }
                            } catch {
                                print(error)
                                totalError = error
                            }
                        } else {
                            totalError = NetworkError.unknown
                        }
                    }
                    serialQueue.resume()
                }
            }
        }
        serialQueue.async {
            if let error = totalError {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    func getQuote(request: GetQuoteRequest) async throws -> GetQuoteResponse {
        do {
            let _ = try await OktaServices().refreshUserToken()
        } catch {
            throw error
        }

        return try await withCheckedThrowingContinuation { continuation in
            AspireConnection.shared.request(AzureRouter.limoGetQuote(request: request)) { (data, error) in
                guard error == nil else {
                    continuation.resume(throwing: error ?? NetworkError.unknown)
                    return
                }

                guard let dataJson = data else {
                    continuation.resume(throwing: NetworkError.unknown)
                    return
                }

                do {
                    let jsonResponse = try JSONDecoder().decode(GetQuoteResponse.self, from: dataJson)
                    if (jsonResponse.quoteID != nil) {
                        continuation.resume(returning: jsonResponse)
                    } else {
                        continuation.resume(throwing: error ?? NetworkError.unknown)
                    }

                } catch {
                    continuation.resume(throwing: error)
                }

            }
        }
    }
    func getQuote(request: GetQuoteRequest, completion: @escaping (Result<GetQuoteResponse, Error>) -> Void) {
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.getQuote")
        var totalError: Error?
        serialQueue.async {
            serialQueue.suspend()
            OktaServices().refreshUserToken { (results) in
                switch results {
                case .success(_):
                    break
                case.failure(let err):
                    totalError = err
                }
                serialQueue.resume()
            }
        }

        serialQueue.async {
            if totalError == nil {
                serialQueue.suspend()
                AspireConnection.shared.request(AzureRouter.limoGetQuote(request: request)) { (data, error) in
                    if error != nil {
                        print(error!)
                        completion(.failure(error!))
                    } else {
                        if let dataJson = data {
                            do {
                                let jsonResponse = try JSONDecoder().decode(GetQuoteResponse.self, from: dataJson)
                                if (jsonResponse.quoteID != nil) {
                                    completion(.success(jsonResponse))
                                } else {
                                    completion(.failure(NetworkError.unknown))
                                }

                            } catch {
                                print(error)
                                completion(.failure(error))
                            }
                        } else {
                            completion(.failure(NetworkError.unknown))
                        }
                    }
                    serialQueue.resume()
                }
            } else {
                completion(.failure(totalError!))
            }
        }
    }
    func limoMakeBooking(request: MakeBookingRequest) async throws -> MakeBookingResponse {
        do {
            let _ = try await OktaServices().refreshUserToken()
        } catch {
            throw error
        }

        return try await withCheckedThrowingContinuation { continuation in
            AspireConnection.shared.request(AzureRouter.limoMakeBooking(request: request)) { data, error in
                guard error == nil else {
                    continuation.resume(throwing: error ?? NetworkError.unknown)
                    return
                }

                guard let dataJson = data else {
                    continuation.resume(throwing: NetworkError.unknown)
                    return
                }
                do {
                    let jsonResponse = try JSONDecoder().decode(MakeBookingResponse.self, from: dataJson)
                    continuation.resume(returning: jsonResponse)
                } catch {
                    continuation.resume(throwing: error)
                }

            }
        }
    }
    func limoMakeBooking(request: MakeBookingRequest, completion: @escaping(Result<MakeBookingResponse, Error>) -> Void) {
        //TODO: service make booking in here
        let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.makebooking")
        var totalError: Error?
        serialQueue.async {
            serialQueue.suspend()
            OktaServices().refreshUserToken { (results) in
                switch results {
                case .success(_):
                    break
                case.failure(let err):
                    totalError = err
                }
                serialQueue.resume()
            }
        }

        serialQueue.async {
            if totalError == nil {
                serialQueue.suspend()
                AspireConnection.shared.request(AzureRouter.limoMakeBooking(request: request)) { data, error in
                    if error != nil {
                        totalError = error
                    } else {
                        if let dataJson = data {
                            do {
                                let jsonResponse = try JSONDecoder().decode(MakeBookingResponse.self, from: dataJson)
                                completion(.success(jsonResponse))
                            } catch {
                                print(error)
                                totalError = error
                            }
                        } else {
                            totalError = NetworkError.unknown
                        }
                    }
                    serialQueue.resume()
                }
            }
        }
        serialQueue.async {
            if let error = totalError {
                completion(.failure(error))
            }
        }
    }
    func getBookingServices(bookingId: String, completion: @escaping(Result<GetBookingResponse, Error>) -> Void) {
        AspireConnection.shared.request(AzureRouter.limoGetBooking(bookingId: bookingId)) { data, error in
            let serialQueue = DispatchQueue(label: "com.aspirelifestyles.ios.gma.makebooking")
            var totalError: Error?
            serialQueue.async {
                serialQueue.suspend()
                OktaServices().refreshUserToken { (results) in
                    switch results {
                    case .success(let success):
                        break
                    case.failure(let err):
                        totalError = err
                    }
                    serialQueue.resume()
                }
            }

            serialQueue.async {
                if totalError == nil {
                    serialQueue.suspend()
                    AspireConnection.shared.request(AzureRouter.limoGetBooking(bookingId: bookingId)) { data, error in
                        if error != nil {
                            totalError = error
                        } else {
                            if let dataJson = data {
                                do {
                                    let jsonResponse = try JSONDecoder().decode(GetBookingResponse.self, from: dataJson)
                                    if !jsonResponse.isEmpty {
                                        completion(.success(jsonResponse))
                                    } else {
                                        completion(.failure(NetworkError.unknown))
                                    }
                                } catch {
                                    print(error)
                                    totalError = error
                                }
                            } else {
                                totalError = NetworkError.unknown
                            }
                        }
                        serialQueue.resume()
                    }
                }
            }
            serialQueue.async {
                if let error = totalError {
                    completion(.failure(error))
                }
            }
        }
    }
}
