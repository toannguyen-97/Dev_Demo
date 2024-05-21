//
//  SplashViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//


import UIKit
import ACProgressHUD_Swift
import FirebaseCrashlytics

class SplashViewController: BaseViewController {
    
    var cmsUpdatePassword = ""
    var cmsPasswordExpired = ""
    var cmsPasswordWarning = ""
    var cmsPasswordWarningsingular = ""
    var cmsDismiss = ""
    var cmsUpdate = ""
    var cmsCityListDic:[String: Any]?

    override func viewDidLoad() {
        self.getCMSData()
        super.viewDidLoad()
        FirebaseTracking.share.setUserProperty()
    }
    
    private func getCMSData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        KenticoServices().getContent(codeName: "app___splash_screen", depth: 3) { result in
            switch result{
            case .success(let dic):
                self.kenticoDic = dic
            case .failure(_):
                break
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        KenticoServices().getContent(codeName: "app___categories_locations", depth: 3) { result in
            switch result{
            case .success(let dic):
                self.cmsCityListDic = dic
            case .failure(_):
                break
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.loadCMSTextFinish()
        }
    }

    
    
    override func loadCMSTextFinish() {
        super.loadCMSTextFinish()
        self.translateCurrentCityFromCMSIfNeeded()
        guard let kenDic = self.kenticoDic else {
            goToNextScreen()
            return
        }
       
        
        
        goToNextScreen()
    }
    
    
    func goToNextScreen() {
//        var debugMode = false
//#if DEBUG
//        debugMode = true
//#endif
        self.goToMainScreen()
//        if !debugMode && UIDevice.current.didImageChange {
//            print("This device has been compromised. Mobile Concierge is no longer available for use.")
//        } else {
//            if let userToken = CurrentSession.share.userToken, !userToken.refreshToken.isEmpty {
//                CurrentSession.share.getDataFromChangeLanguage()
//                if let _ = CurrentSession.share.aspireProfile, let _ = CurrentSession.share.oktaProfile, let _ = CurrentSession.share.programDetail, userToken.isValid() {
//                    self.goToMainScreen()
//                }else {
//                    self.autoSigninProcess()
//                }
//            }else {
//                self.goToAccessCodeScreen()
//            }
//        }
    }
    
    private func autoSigninProcess(){
//        ACProgressHUD.shared.showHUD()
        AzureServices().autoLoginWithRefreshToken {[weak self] results in
            switch results {
            case .success(()):
                self?.verifyBinAndNextProcess()
            case .failure(let error):
                Crashlytics.crashlytics().record(error: error)
                self?.goToAccessCodeScreen()
            }
        }
    }
    
    private func verifyBinAndNextProcess() {
        AzureServices().getProgramInfoWith(bin: CurrentSession.share.aspireProfile!.getAccessCode()) {[weak self] results in
            switch results {
            case .success(let programDetail):
                if(programDetail.status == 1) {  //accesscode valid
                    OktaServices().getListFactorEnrolled {[weak self] results in
//                        ACProgressHUD.shared.hideHUD()
                        guard let self = self else {
                            return;
                        }
                        switch results {
                        case .success(let factors):
                            var emailEnrolled = false
                            for arr in factors {
                                if arr.factorType == "email"{
                                    if arr.status == "ACTIVE"{
                                        emailEnrolled = true
                                    }
                                }else if arr.factorType == "sms" {
                                    if arr.status == "ACTIVE"{
                                        CurrentSession.share.isPhoneNumberVerified = true
                                    }
                                }
                            }
                            if emailEnrolled {
                                self.splashMoveToAppScreen()
                            }else {
                                self.moveToSiginScreen()
                            }
                        case .failure(let error):
                            Crashlytics.crashlytics().record(error: error)
                            self.splashMoveToAppScreen()
                        }
                    }
//                    FirebaseTracking.share.logEvent(event: FirebaseEvent.login, viewController: self!, parameter: ["login_stage": "log_in_success", "login_error": ""])
                }else { //accesscode expired
                    ACProgressHUD.shared.hideHUD()
                    self?.goToInvalidAccessCodeScreen()
                }
            case .failure(let error):
                ACProgressHUD.shared.hideHUD()
                Crashlytics.crashlytics().record(error: error)
                if let error = error as? APIError, error == APIError.accesscodeInvalid { //accesscode invalid
                    self?.goToInvalidAccessCodeScreen()
                }else {
                    self?.goToAccessCodeScreen()
                }
            }
        }
    }
    
    func moveToSiginScreen() {
        DispatchQueue.main.async {
            if let navig = self.navigationController{
                let signInVC = SignInViewController()
                navig.pushViewController(signInVC, animated: true)
                navig.viewControllers.insert(VerifyAccessCodeViewController(), at: navig.viewControllers.count - 1)
            }
        }
    }
    
    private func splashMoveToAppScreen() {
                if let delta = CurrentSession.share.oktaProfile?.getDayToPawdExpired() {
                    if delta >= dayToWarningExpiredPss {
                        self.psExpiredHandle(psAge: delta)
                    }else {
                        self.goToMainScreen()
                    }
                }else {
        self.goToMainScreen()
                }
    }
    
    private func psExpiredHandle(psAge: Int) {
        if psAge > dayToExpiredPss { // expired
            self.showAlert(withTitle: cmsUpdatePassword, andMessage:cmsPasswordExpired, btn1Title: cmsUpdate, btn1Action:  {
                self.openUpdatePassword()
            })
        }else {   // warning
            let leftDay = dayToExpiredPss - psAge
            var msg = cmsPasswordWarningsingular
            if leftDay >= 1 {
                msg = cmsPasswordWarning.withReplacedCharacters("[x]", by: "\(leftDay)")
            }
            self.showAlert(withTitle: cmsUpdatePassword, andMessage: msg, btn1Title: cmsDismiss, btn2Title: cmsUpdate) {
                self.goToMainScreen()
            } btn2Action: {
                self.openUpdatePassword(isWarning: true)
            }
        }
    }
    
    private func openUpdatePassword(isWarning: Bool = false) {
        let changePasswordVC = ChangePasswordViewController(dic: self.kenticoDic)
        changePasswordVC.isWarningPsExpired = isWarning
        self.navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    
    private func moveToVerifyViaEmail(){
        DispatchQueue.main.async { [weak self] in
            let verifyEmailVC = VerifyViaEmailViewController(flow: .registrationFlow)
            self?.navigationController?.pushViewController(verifyEmailVC, animated: true)
        }
    }
    
    private func goToInvalidAccessCodeScreen() {
        DispatchQueue.main.async {
            let invalidCodeScreen = AccessCodeExpiredViewController()
            self.navigationController?.pushViewController(invalidCodeScreen, animated: true)
        }
    }
    
    private func goToAccessCodeScreen(){
        DispatchQueue.main.async {
            let rootVC = UINavigationController(rootViewController: VerifyAccessCodeViewController())
            rootVC.setTranparent()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = rootVC
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    private func translateCurrentCityFromCMSIfNeeded() {
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
