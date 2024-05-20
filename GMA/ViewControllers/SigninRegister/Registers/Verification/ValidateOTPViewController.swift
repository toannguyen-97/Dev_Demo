//
//  ValidateOTPViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//

import Foundation
import UIKit
import ACProgressHUD_Swift
import FirebaseCrashlytics

class ValidateOTPViewController: BaseWithBlurViewController{
    
    private var titleLabel: UILabel!
    private var textLabel: UILabel!
    private var otpView: OTPStackView!
    private var resendButton: UIButton!
    private var totalTime = 30
    private var mailID: String!
    private var flowType: flowType!
    private var isFactorEnrolled: Bool!
    private var isEmail: Bool!
    private var smsFactorId : String?
    private var maskedString: String?
    private var forPhoneVerification = false
    private var profileDetailsView: ProfileDetailsView!
    var timer: Timer?
    // CMS String
    var cmsKErrorVerificationCode = "Incorrect verification code. Make sure you enter the code correctly and try again."
    var cmsResendInString = "Resend in {second} sec"
    var cmsProcessingString = "Processing.."
    var cmsVerificationString = "Verification Code"
    var cmsPleaseEnterTheCodeString = "Please enter the 6-digit code that was sent to [email]"
    var cmsResendButtonString = "Resend"
    
    convenience init(flow: flowType, factor: Bool, email: Bool, smsFactorId: String?, forVerification: Bool){
        self.init()
        self.flowType = flow
        self.isFactorEnrolled = factor
        self.isEmail = email
        self.smsFactorId = smsFactorId
        self.forPhoneVerification = forVerification
    }
    
    override func viewDidLoad() {
        self.kenticoCodeName = "app___registration"
        self.kenticoDepth = 3
        super.viewDidLoad()
        startCount()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showOtpView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ACProgressHUD.shared.progressText = ""
        self.timer?.invalidate()
        self.timer = nil
    }
    override func setNavBarItems(){
        super.setNavBarItems()
        if MainTabbarController.shared == nil && flowType != .forgotPasswordFlow{
            navigationItem.setHidesBackButton(true, animated: true)
        }else {
            self.createBackBarButton()
        }
        createRightBarButtonWithTitle(title: cmsResendInString.withReplacedCharacters("{second}", by: "\(totalTime)"))
        resendButton = navigationItem.rightBarButtonItem?.customView as? UIButton
        resendButton.isEnabled = false
    }
    
    override func setText() {
        super.setText()
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___registration_verification_code.elements.description.value") as? String {
            cmsResendInString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___registration_verification_code.elements.watermark_text.value") as? String {
            cmsProcessingString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___registration_verification_code.elements.title.value") as? String {
            cmsVerificationString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___registration_verification_code.elements.description_1.value") as? String {
            cmsPleaseEnterTheCodeString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___registration_verification_code.elements.cta_text1.value") as? String {
            cmsResendButtonString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___incorrect_verification_code.elements.description.value") as? String {
            cmsKErrorVerificationCode = str
        }
        if resendButton != nil {
            resendButton.setTitle(cmsResendInString.withReplacedCharacters("{second}", by: "\(totalTime)"), for: .normal)
        }
        ACProgressHUD.shared.progressText = cmsProcessingString
        var components = maskedString!.components(separatedBy: "@")
        var result = hideMidChars(components.first!) + "@" + components.last!
        if !isEmail{
            components = maskedString!.components(separatedBy: ".")
            result = hideMidChars(components.first!)
        }
        titleLabel.attributedText = cmsVerificationString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleGreeting, color: UIColor.white, lineSpacing: 5)
        textLabel.attributedText = cmsPleaseEnterTheCodeString.withReplacedCharacters("[email]", by: result).toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: UIColor(named: "whiteTextColor")!, lineSpacing: 5)
    }

    override func setupUI() {
        super.setupUI()
        ACProgressHUD.shared.progressText = cmsProcessingString
        if flowType == .registrationFlow{
            if let aspireProfile = CurrentSession.share.aspireProfile {
                mailID = aspireProfile.emails?.first?.emailAddress
            } else {
                mailID = RegisterData.share.emailAES?.aesDecrypt()
            }
            maskedString = mailID
        }else{
            if isEmail{
                mailID = CurrentSession.share.oktaProfile?.profile.email
                maskedString = mailID
            }else{
                if let pmaProfile = CurrentSession.share.pmaProfile, let countryCode = pmaProfile.phoneCountryCode, let phoneNumber = pmaProfile.phoneNumber {
                    maskedString = countryCode+phoneNumber
                }else{
                    if let phone = CurrentSession.share.aspireProfile?.phones?.first, let code = phone.phoneCountryCode , let number = phone.phoneNumber{
                        maskedString = code+number
                    }else{
                        maskedString = ""
                    }
                    
                }
            }
            
        }
        titleLabel = {
            let label = UILabel()
            label.attributedText = cmsVerificationString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleGreeting, color: UIColor.white, lineSpacing: 5)
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            return label
        }()
        textLabel = {
            let label = UILabel()
            var components = maskedString!.components(separatedBy: "@")
            var result = hideMidChars(components.first!) + "@" + components.last!
            if !isEmail{
                components = maskedString!.components(separatedBy: ".")
                result = hideMidChars(components.first!)
            }
            label.attributedText = cmsPleaseEnterTheCodeString.withReplacedCharacters("[email]", by: result).toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: UIColor(named: "whiteTextColor")!, lineSpacing: 5)
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            return label
        }()
        
        otpView = {
            let view = OTPStackView()
            view.delegate = self
            return view
        }()
      
        [titleLabel,textLabel, otpView].forEach({view.addSubview($0)})
        
        titleLabel.setupConstraints(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 120, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 110))
        textLabel.setupConstraints(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 20, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 0))
        otpView.setupConstraints(top: textLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 60*SCREEN_HEIGHT_SCALE, left: 32, bottom: 0, right: 32), size: .init(width: 0, height: 60*SCREEN_HEIGHT_SCALE))
    }
    
    func hideMidChars(_ value: String) -> String {
       return String(value.enumerated().map { index, char in
          return [0, 1, value.count - 1, value.count - 2].contains(index) ? char : "*"
       })
    }
    
    private func showOtpView(){
        DispatchQueue.main.async { [weak self] in
            if let self = self{
                self.otpView.isHidden = false
                for tf in self.otpView.textFieldsCollection{
                    tf.text = ""
                }
            }
        }
    }
    
    private func hideOtpView(){
        DispatchQueue.main.async { [weak self] in
            if let self = self{
                self.otpView.isHidden = true
            }
        }
    }
    
    override func righBarItemTouch() {
        resendButton.isEnabled = false
        totalTime = 30
        startCount()
        if flowType == .registrationFlow || isEmail{
            var otpType = "PasswordReset"
            if flowType == .registrationFlow {
                otpType = "CustomerVerification"
            }
            ACProgressHUD.shared.showHUD()
            AzureServices().generateEmailOTP(emailID: mailID, type: otpType) { results in
                ACProgressHUD.shared.hideHUD()
                switch results{
                case .success(let response):
                    print(response.message)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }else{
            if isFactorEnrolled{
                guard let stateToken = self.smsFactorId else {
                    self.otpView.textFieldsCollection.last?.showErrorMessage(message: COMMON_ERROR, rightButtonTitle: nil, rightButtonAction: nil)
                    return;
                }
                OktaServices().resendOTP(statetoken: stateToken) {[weak self] result in
                    switch result{
                    case .success( _):
                        print("rrrrrr")
                    case .failure(let err):
                        print(err.localizedDescription)
                        self?.otpView.textFieldsCollection.last?.showErrorMessage(message: err.localizedDescription, rightButtonTitle: nil, rightButtonAction: nil)
                    }
                }
            }else{
                guard let factorID = self.smsFactorId else {
                    return
                }
                OktaServices().resend(factorID: factorID) {[weak self]  result in
                    switch result{
                    case .success( _):
                        print("")
                    case .failure(let err):
                        print(err.localizedDescription)
                        self?.otpView.textFieldsCollection.last?.showErrorMessage(message: err.localizedDescription, rightButtonTitle: nil, rightButtonAction: nil)
                    }
                }
            }
        }
    }
   
    func startCount(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.totalTime >= 0 {
                self.resendButton.isEnabled = false
                self.updateCount(count: self.totalTime)
                self.totalTime -= 1
            } else {
                Timer.invalidate()
                self.resetResendButton()
            }
        }
    }
  
 //Update the button UI
    func updateCount(count: Int) {
        DispatchQueue.main.async(execute: { [self] in
            let countSring = cmsResendInString.withReplacedCharacters("{second}", by: "\(count)")
            self.resendButton.setTitle(countSring, for: .normal)
        })
    }

    func resetResendButton(){
        DispatchQueue.main.async {
            self.resendButton.setTitle(self.cmsResendButtonString, for: .normal)
            self.resendButton.contentHorizontalAlignment = .right
            self.resendButton.isEnabled = true
        }
    }
    
    private func goToCreateNewPasswordScreen(statetoken: String? = nil){
        DispatchQueue.main.async { [weak self] in
            if let self = self{
                let passwordVC = CreateNewPasswordViewController(flow: self.flowType, factor: self.isFactorEnrolled, email: self.isEmail, stateToken: statetoken)
                self.navigationController?.pushViewController(passwordVC, animated: true)
            }
        }
    }
    
}

extension ValidateOTPViewController: OTPDelegate{
    func didChangeValidity(isValid: Bool, otpText: String?) {
        self.otpView.textFieldsCollection.last?.hideError()
        if isValid == true{
            if let text = otpText{
                if isEmail{
                    emailVerification(otpString: text)
                }else{
                    if forPhoneVerification == true{
                        smsVerificationToVerifymobileNumber(otpString: text)
                    }else{
                        smsVerification(otpString: text)
                    }
                }
            }
        }
    }
    
    
    private func emailVerification(otpString: String){
        ACProgressHUD.shared.showHUD()
        hideOtpView()
        AzureServices().validateOTP(emailID: mailID, otp: otpString) {[weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let response):
                if response.message.elementsEqual("OTP Validated Successfully"){
                    if self.flowType == .registrationFlow{
                        OktaServices().enrollEmailFactorAutomatically { [weak self] result in
                            guard let self = self else  {return}
                            ACProgressHUD.shared.hideHUD()
                            switch result{
                            case .success(let response):
                                print(response)
                                self.goToMainScreen()
//                                FirebaseTracking.share.logEvent(event: FirebaseEvent.registration_journey_step5_for_success_registration, viewController: self, parameter: ["registration_stage": "registration_journey_success"])
//                                FirebaseTracking.share.logEvent(event: FirebaseEvent.registration_step4_two_factor_authentication, viewController: self
//                                                                , parameter: ["registration_stage": "two_factor_authentication_success"])
                            case .failure(let error):
                                print(error.localizedDescription)
                                self.showOtpView()
                            }
                        }
                    }else{
                        if self.isFactorEnrolled {
                            ACProgressHUD.shared.hideHUD()
                            self.goToCreateNewPasswordScreen()
                        }else {
                            OktaServices().enrollEmailFactorAutomatically { result in
                                ACProgressHUD.shared.hideHUD()
                                switch result{
                                case .success(let response):
                                    print(response)
                                    self.goToCreateNewPasswordScreen()
                                case .failure(let error):
                                    print(error.localizedDescription)
                                    self.showOtpView()
                                }
                            }
                        }
                    }
                }else if response.message.elementsEqual("OTP In-valid or Expired"){
                    self.showOtpView()
                    ACProgressHUD.shared.hideHUD()
                    self.otpView.textFieldsCollection.first?.showErrorMessage(message: self.cmsKErrorVerificationCode, rightButtonTitle: nil, rightButtonAction: nil)
                    
//                    FirebaseTracking.share.logEvent(event: FirebaseEvent.registration_step4_two_factor_authentication, viewController: self, parameter: ["registration_stage": "two_factor_authentication_failure", "failure_reason": self.cmsKErrorVerificationCode])
                }else {
                    self.showOtpView()
                    ACProgressHUD.shared.hideHUD()
                    self.otpView.textFieldsCollection.first?.showErrorMessage(message: self.cmsKErrorVerificationCode, rightButtonTitle: nil, rightButtonAction: nil)
                }
            case .failure(let err):
                //show error
                self.showOtpView()
                ACProgressHUD.shared.hideHUD()
                print(err.localizedDescription)
                self.otpView.textFieldsCollection.first?.showErrorMessage(message: err.localizedDescription, rightButtonTitle: nil, rightButtonAction: nil)
            }
        }
    }
    
    private func smsVerification(otpString: String){
        guard let stateToken = self.smsFactorId else {
            self.otpView.textFieldsCollection.last?.showErrorMessage(message: COMMON_ERROR, rightButtonTitle: nil, rightButtonAction: nil)
            return;
        }
        ACProgressHUD.shared.showHUD()
        self.hideOtpView()
        if isFactorEnrolled{
            OktaServices().verifySMSRecoveryFactor(statetoken:stateToken , passcode: otpString) { [weak self] (result) in
                guard let self = self else {return}
                ACProgressHUD.shared.hideHUD()
                switch result{
                case .success(let response):
                    print(response)
                    self.goToCreateNewPasswordScreen(statetoken: stateToken)
                case .failure(let err):
                    print(err.localizedDescription)
                    self.showOtpView()
                    self.otpView.textFieldsCollection.first?.showErrorMessage(message: self.cmsKErrorVerificationCode, rightButtonTitle: nil, rightButtonAction: nil)
                }
            }
        }else{
            let factorID = stateToken
            OktaServices().activateSMSFactor(factorID: factorID, passCode: otpString) { [weak self] result in
                guard let self = self else {return}
                ACProgressHUD.shared.hideHUD()
                switch result{
                case .success(let response):
                    print(response)
                    self.goToCreateNewPasswordScreen(statetoken: stateToken)
                case .failure(let err):
                    print(err.localizedDescription)
                    self.showOtpView()
                    self.otpView.textFieldsCollection.first?.showErrorMessage(message: self.cmsKErrorVerificationCode, rightButtonTitle: nil, rightButtonAction: nil)
                }
            }
            
        }
    }
    
    private func smsVerificationToVerifymobileNumber(otpString: String){
        guard let factorID = self.smsFactorId else {
            self.otpView.textFieldsCollection.last?.showErrorMessage(message: COMMON_ERROR, rightButtonTitle: nil, rightButtonAction: nil)
            return;
        }
        ACProgressHUD.shared.showHUD()
        self.hideOtpView()
        OktaServices().activateSMSFactor(factorID: factorID, passCode: otpString) {[weak self] result in
            guard let self else {return}
            switch result{
            case .success( _):
                OktaServices().getListFactorEnrolled { result in
                    ACProgressHUD.shared.hideHUD()
                    switch result{
                    case .success( _):
                            if self.flowType == .verifyPhoneNumberFlow{
                                self.goToSettingsScreen()
                            }else{
                                self.goToMainScreen()
                            }
                    case .failure(let error):
                        print(error)
                        Crashlytics.crashlytics().record(error: error)
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
                Crashlytics.crashlytics().record(error: err)
                ACProgressHUD.shared.hideHUD()
                self.showOtpView()
                self.otpView.textFieldsCollection.first?.showErrorMessage(message: self.cmsKErrorVerificationCode, rightButtonTitle: nil, rightButtonAction: nil)
            }
        }
    }
    
    private func goToSettingsScreen(){
        if let _ = self.navigationController?.tabBarController {
             self.navigationController?.popToRootViewController(animated: true)
           }else {
             self.goToMainScreen()
           }
    }
    
}
