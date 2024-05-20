//
//  BiometricManager.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//



import Foundation
import LocalAuthentication
import KeychainAccess
import FirebaseCrashlytics

let kBIOMETRIC = "KO6pedHiBN"
let kBIOMETRIC_STATUS = "BKEYIOMETRICSTATUS"


class BiometricManager {
    
    static let shared = BiometricManager()
    private var keyChain : Keychain!
    init(){
        let serviceName:String = (Bundle.main.bundleIdentifier != nil) ? Bundle.main.bundleIdentifier! : "com.aspirelifestyles.ios.gma"
        keyChain = Keychain(service: serviceName)
    }
    
    func setIsEnabledBiometric(isEnable:Bool){
        UserDefaults.standard.set(isEnable, forKey: kBIOMETRIC_STATUS)
        UserDefaults.standard.synchronize()
        if let userToken = CurrentSession.share.userToken, !userToken.refreshToken.isEmpty{
            BiometricManager.shared.saveBiometricData()
        }
    }
    
    func getIsEnabledBiometric()-> Bool {
        return UserDefaults.standard.bool(forKey: kBIOMETRIC_STATUS)
    }
    
    enum BiometricType {
        case none
        case faceID
        case touchID
    }
    
    func biometricType() -> BiometricType {
        let authContext = LAContext()
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch authContext.biometryType{
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        default:
            return .none
        }
    }
    
    func saveBiometricData(){
        if self.getIsEnabledBiometric(){
            storeTokenInKeychain()
        }else{
            do {
                try keyChain.remove(kBIOMETRIC)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func canEvaluatePolicy(completion: @escaping(Result<String, BiometricError>) -> Void) {
        
        var error: NSError?
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            completion(.success("Biometric access granted"))
        }else{
            switch error!.code{
            case -6:
                completion(.failure(.deniedAccess))
            case -7:
                if context.biometryType == .faceID{
                    completion(.failure(.noFaceIdEnrolled))
                }else{
                    completion(.failure(.noFingerPrintEnrolled))
                }
            default:
                
                completion(.failure(.biometricError))
            }
        }
    }
    
    func storeTokenInKeychain(){
        DispatchQueue.global(qos: .background).async {
            if let userToken = CurrentSession.share.userToken, !userToken.refreshToken.isEmpty{
                DispatchQueue.global().async {
                    let encoder = JSONEncoder()
                    do {
                        try self.keyChain.remove(kBIOMETRIC)
                        let data = try encoder.encode(userToken)
                        if let encryptStr = String(data: data, encoding: .utf8)?.aesEncrypt() , let encryptData = encryptStr.data(using: .utf8) {
                            try self.keyChain
                                .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: [.biometryAny])
                                .set(encryptData, key: kBIOMETRIC)
                        }
                    } catch {
                        Crashlytics.crashlytics().record(error: error)
                        print(error)
                    }
                }
            }
        }
    }
    
    func authenticateUser(completion:@escaping(Result<Token, Error>) -> Void){
        DispatchQueue.global().async {
            do {
                let dataEncrypt = try self.keyChain
                    .authenticationPrompt("Authentication required to access")
                    .getData(kBIOMETRIC)
                
                guard let data = dataEncrypt, let decryptStr = String(data: data, encoding: .utf8)?.aesDecrypt(), let decryptData = decryptStr.data(using: .utf8)  else {
                    completion(.failure(BiometricError.biometricError))
                    return;
                }
                let decoder = JSONDecoder()
                do {
                    let object = try decoder.decode(Token.self, from: decryptData)
                    CurrentSession.share.userToken = object
                    CurrentSession.share.userToken?.accessToken = ""
                    completion(.success(object))
                } catch {
                    print(error)
                    Crashlytics.crashlytics().record(error: error)
                    completion(.failure(BiometricError.biometricError))
                }
            } catch {
                print(error)
                Crashlytics.crashlytics().record(error: error)
                completion(.failure(BiometricError.biometricError))
            }
        }
    }
}
