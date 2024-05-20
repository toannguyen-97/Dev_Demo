//
//  VerifyViaEmailViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//

import Foundation
import UIKit
import ACProgressHUD_Swift
import FirebaseCrashlytics

class VerifyViaEmailViewController: BaseWithBlurViewController{
    private var logoImageView: UIImageView!
    private var verifyAccountLabel: UILabel!
    private var textLabel: UILabel!
    private var verifyEmailButton: UIButton!
    private var verifyTextButton: UIButton!
    private var orLabel: UILabel!
    private var stackView: UIStackView!
    private var emailID: String!
    private var flowType: flowType!
    var emailEnrolled = false
    var smsEnrolled = false
    var isEmailVerify = false // Email or SMS
    
    override func viewDidLoad() {
        self.kenticoCodeName = "app___registration"
        self.kenticoDepth = 3
        super.viewDidLoad()
    }
    
    override func setNavBarItems() {
        super.setNavBarItems()
        self.navigationItem.setHidesBackButton(true, animated: false)
        if flowType == .forgotPasswordFlow {
            self.createBackBarButton()
        }
    }
    
    convenience init(flow: flowType){
        self.init()
        self.flowType = flow
    }
    
    // CMS String
//    var cmsVerifyEmailString = "Verify via Email"
//    var cmsVerifySMSString = "Verify via Text Message (SMS)"
//    var cmsOrString = "or"
//    var cmsNeedToVerifyString = "Before we continue, we need to verify your identity."
//    var cmsWouldLikeConfirmAccountString = "We would like to confirm you are the owner of this account. Please select one of the verification methods."
//    var cmsPleaseVerifyString = "Please verify \nyour identity"
//    var invalid_Phone_number = "The phone number is invalid. Please try again. "
    var cmsVerifyEmailString = ""
    var cmsVerifySMSString = ""
    var cmsOrString = ""
    var cmsNeedToVerifyString = ""
    var cmsWouldLikeConfirmAccountString = ""
    var cmsPleaseVerifyString = ""
    var invalid_Phone_number = ""
    var otpTimeErrorMessageString = ""
    
    
    override func setText() {
        super.setText()
        // register
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___verification_menthods.elements.cta_text1.value") as? String {
            cmsVerifyEmailString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___verification_menthods.elements.cta_text2.value") as? String {
            cmsVerifySMSString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___registration_verification.elements.description.value") as? String {
            cmsNeedToVerifyString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___registration_verification.elements.title.value") as? String {
            cmsPleaseVerifyString = str
        }
        // forgot password
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___forgot_password_verification.elements.description.value") as? String {
            cmsWouldLikeConfirmAccountString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___verification_menthods.elements.watermark_text.value") as? String {
            cmsOrString = str
        }
        if let invalid_Phone_numberString =  KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___invalid_phone_number.elements.description.value") as? String {
            self.invalid_Phone_number = invalid_Phone_numberString
        }
        if let str =  KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___otp_time_error_message.elements.description.value") as? String {
            self.otpTimeErrorMessageString = str
        }
        
        verifyEmailButton.setTitle(cmsVerifyEmailString, for: .normal)
        verifyTextButton.setTitle(cmsVerifySMSString, for: .normal)
        orLabel.attributedText = cmsOrString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: UIColor(named: "whiteTextColor")!, lineSpacing: 5)
        orLabel.textAlignment = .center
        let text = flowType == .registrationFlow ? cmsNeedToVerifyString : cmsWouldLikeConfirmAccountString
        textLabel.attributedText = text.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: UIColor(named: "whiteTextColor")!, lineSpacing: 5)
        verifyAccountLabel.attributedText = cmsPleaseVerifyString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleGreeting, color: UIColor.white, lineSpacing: 2)
    }
    
    override func setupUI() {
        super.setupUI()
        if flowType == .registrationFlow{
            if let profile = CurrentSession.share.aspireProfile {
                emailID = profile.emails?.first?.emailAddress
            } else {
                emailID = RegisterData.share.emailAES?.aesDecrypt()
            }
        }else{
            emailID = CurrentSession.share.oktaProfile?.profile.email
        }
        
        logoImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "user_active")
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            return imageView
        }()
        
        verifyEmailButton = {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 60*SCREEN_HEIGHT_SCALE))
            button.setTitle(cmsVerifyEmailString, for: .normal)
            button.addTarget(self, action: #selector(action_VerifyEmial), for: .touchUpInside)
            button.setCommonButtonStyle()
            return button
        }()
        
        verifyTextButton = {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 60*SCREEN_HEIGHT_SCALE))
            button.setTitle(cmsVerifySMSString, for: .normal)
            button.addTarget(self, action: #selector(action_VerifyTextSMS), for: .touchUpInside)
            button.setCommonButtonStyle()
            return button
        }()
        
        orLabel = {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 30*SCREEN_HEIGHT_SCALE))
            label.attributedText = cmsOrString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: UIColor(named: "whiteTextColor")!, lineSpacing: 5)
            label.textAlignment = .center
            return label
        }()
        
        stackView = {
            let view = UIStackView(arrangedSubviews: flowType == .registrationFlow ? [verifyEmailButton] : [verifyEmailButton, orLabel, verifyTextButton])
            view.axis = .vertical
            view.distribution = .fill
            return view
        }()
        
        textLabel = {
            let label = UILabel()
            let text = flowType == .registrationFlow ? cmsNeedToVerifyString : cmsWouldLikeConfirmAccountString
            label.attributedText = text.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: UIColor(named: "whiteTextColor")!, lineSpacing: 5)
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            return label
        }()
        
        verifyAccountLabel = {
            let label = UILabel()
            label.attributedText = cmsPleaseVerifyString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleGreeting, color: UIColor.white, lineSpacing: 2)
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            return label
        }()
        
        [logoImageView, stackView, textLabel, verifyAccountLabel].forEach({view.addSubview($0)})
        
        logoImageView.setupConstraints(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, withPadding: .init(top: 60, left: 0, bottom: 0, right: 0), size: .init(width: 180*SCREEN_HEIGHT_SCALE, height: 180*SCREEN_HEIGHT_SCALE))
        if flowType == .forgotPasswordFlow {
            verifyTextButton.setupConstraints(top: nil, leading: stackView.leadingAnchor, bottom: nil, trailing: stackView.trailingAnchor, withPadding: .zero, size: .init(width: 0, height: 60*SCREEN_HEIGHT_SCALE))
            orLabel.setupConstraints(top: nil, leading: stackView.leadingAnchor, bottom: nil, trailing: stackView.trailingAnchor, withPadding: .zero, size: .init(width: 0, height: 30*SCREEN_HEIGHT_SCALE))
        }
        verifyEmailButton.setupConstraints(top: nil, leading: stackView.leadingAnchor, bottom: nil, trailing: stackView.trailingAnchor, withPadding: .zero, size: .init(width: 0, height: 60*SCREEN_HEIGHT_SCALE))
        
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.setupConstraints(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, withPadding: .init(top: 0, left: 25, bottom: 10, right: 25), size: .init(width: 0, height: flowType == .registrationFlow ? 60*SCREEN_HEIGHT_SCALE : 0))
        textLabel.setupConstraints(top: nil, leading: view.leadingAnchor, bottom: stackView.topAnchor, trailing: view.trailingAnchor, withPadding: .init(top: 10, left: 25, bottom: 35, right: 25), size: .init(width: 0, height: 0))
        verifyAccountLabel.setupConstraints(top: nil, leading: view.leadingAnchor, bottom: textLabel.topAnchor, trailing: view.trailingAnchor, withPadding: .init(top: 0, left: 25, bottom: 20, right: 25), size: .init(width: 0, height: 0))
        
    }
    
    

    @objc func action_VerifyEmial(){
        isEmailVerify = true
        if flowType == .registrationFlow{
            emailRegistrationFlowProcess()
        }else{
            forgotPasswordFlowProcess()
        }
    }
    
    @objc func action_VerifyTextSMS(){
        isEmailVerify = false
        self.forgotPasswordFlowProcess()
    }
    
    private func emailRegistrationFlowProcess(){
        ACProgressHUD.shared.showHUD()
        AzureServices().generateEmailOTP(emailID: emailID, type: "CustomerVerification") { results in
            ACProgressHUD.shared.hideHUD()
            switch results{
            case .success(let response):
                print(response.message)
                self.showValidateOTPScreen(isEmail: true)
            case .failure(let error):
                print(error.localizedDescription)
                Crashlytics.crashlytics().record(error: error)
                if let networkErr = error as? NetworkError, networkErr == NetworkError.noInternet { return }
                self.showAlert(withTitle: "", andMessage: COMMON_ERROR)
            }
        }
    }
    
    private func forgotPasswordFlowProcess(){
        ACProgressHUD.shared.showHUD()
        OktaServices().getListFactorEnrolled {[weak self] results in
            guard let self = self else {
                return;
            }
            switch results {
            case .success(let factors):
                for arr in factors {
                    let factorType = arr.factorType
                    let status = arr.status
                    if status == "ACTIVE"{
                        if factorType == "email"{
                            self.emailEnrolled = true
                        }else if factorType == "sms"{
                            self.smsEnrolled = true
                        }
                    }
                }
                if(self.isEmailVerify) {
                    self.generateForgotPasswordOTPViaEmail()
                } else {
                    self.generateForgotPasswordOTPViaSMS()
                }
            case .failure(let error):
                ACProgressHUD.shared.hideHUD()
                Crashlytics.crashlytics().record(error: error)
                if let networkErr = error as? NetworkError, networkErr == NetworkError.noInternet { return }
                self.showAlert(withTitle: "", andMessage: COMMON_ERROR)
            }
        }
    }
    
    private func generateForgotPasswordOTPViaSMS() {
        if smsEnrolled{
            //forgot password with sms factor
            OktaServices().forgotPasswordWithSMSFactor { result in
                ACProgressHUD.shared.hideHUD()
                switch result{
                case .success(let factor):
                    self.showValidateOTPScreen(isEmail: false, smsFactorId: factor.stateToken)
                case .failure( let error):
                    Crashlytics.crashlytics().record(error: error)
                    print(error.localizedDescription)
                    if let networkErr = error as? NetworkError, networkErr == NetworkError.noInternet { return }
                    if let err = error  as? APIError, err == APIError.invalid_Phone_number {
                        self.showAlert(withTitle: "", andMessage: "\(self.invalid_Phone_number)")
                    }else if let err = error  as? APIError, err == APIError.OTPWasRecentlySent {
                        self.showAlert(withTitle: "", andMessage: self.otpTimeErrorMessageString)
                    }else {
                        self.showAlert(withTitle: "", andMessage: COMMON_ERROR)
                    }
                }
            }
        }else{
            OktaServices().enrollOktaSMSFactor(forVerification: false) { result in
                ACProgressHUD.shared.hideHUD()
                switch result{
                case .success(let factor):
                    self.showValidateOTPScreen(isEmail: false, smsFactorId: factor.id)
                case .failure( let error):
                    print(error.localizedDescription)
                    Crashlytics.crashlytics().record(error: error)
                    if let networkErr = error as? NetworkError, networkErr == NetworkError.noInternet { return }
                    if let err = error  as? APIError, err == APIError.invalid_Phone_number {
                        self.showAlert(withTitle: "", andMessage: "\(self.invalid_Phone_number)")
                    }else if let err = error  as? APIError, err == APIError.OTPWasRecentlySent {
                        self.showAlert(withTitle: "", andMessage: self.otpTimeErrorMessageString)
                    }else {
                        self.showAlert(withTitle: "", andMessage: "\(error)")
                    }
                }
            }
        }
    }
    
    private func generateForgotPasswordOTPViaEmail(){
        ACProgressHUD.shared.showHUD()
        AzureServices().generateEmailOTP(emailID: emailID, type: "PasswordReset") { results in
            ACProgressHUD.shared.hideHUD()
            switch results{
            case .success(let response):
                print(response.message)
                self.showValidateOTPScreen(isEmail: true)
            case .failure(let error):
                Crashlytics.crashlytics().record(error: error)
                if let networkErr = error as? NetworkError, networkErr == NetworkError.noInternet { return }
                if let err = error  as? APIError, err == APIError.OTPWasRecentlySent {
                    self.showAlert(withTitle: "", andMessage: self.otpTimeErrorMessageString)
                }else {
                    print(error.localizedDescription)
                    self.showAlert(withTitle: "", andMessage: COMMON_ERROR)
                }
            }
        }
    }
    

    private func showValidateOTPScreen(isEmail: Bool, smsFactorId : String? = nil){
        DispatchQueue.main.async { [weak self] in
            if let self = self{
                var factorEnrolled = self.smsEnrolled
                if isEmail {
                    factorEnrolled = self.emailEnrolled
                }
                let otpVC = ValidateOTPViewController(flow: self.flowType, factor: factorEnrolled, email: isEmail, smsFactorId: smsFactorId, forVerification: false)
                self.navigationController?.pushViewController(otpVC, animated: true)
            }
        }
    }
}
