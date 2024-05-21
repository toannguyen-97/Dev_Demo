//
//  SignInViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//



import Foundation
import UIKit
import LocalAuthentication
import ACProgressHUD_Swift
import FirebaseCrashlytics

class SignInViewController : BaseWithBlurViewController{
    var emailString : String?
    var isFromRegister = false
    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var showPsButton: UIButton!
    private var forgotPassworButton: UIButton!
    private var signInButton: UIButton!
    private var biometricButton: UIButton!
    
    // CMS String
    var cmsTitleString = "Sign in"
    var cmsWelcomeString = "Welcome back!"
    var cmsEmailString = "Email"
    var cmsPasswordString = "Password"
    var cmsLanguageString = "Language"
    var cmsFoundAccountWithEmailString = "We found a user account with this email address, please sign in."
    var cmsForgotPasswordString = "Forgot password?"
    var cmsSignInButtonString = "Sign in"
    var cmsKAccountInvalid = "Your email or password is incorrect. Please try again."
    var cmsKEmtpyCredentials = "Please provide your credentials"
    var cmsTurnOnBiometricString = "You need turn on Biometric in app setting first."
    var cmsDeviceTurnOnBiometricString = "Please set up Biometrics in your device settings."
    var cmsManyFailedBiometric = "Authentication was not successful,because there were too many failed biometry attempts and biometry is now locked."
    var cmsErrorString = "Error!"
    var cmsForceUpdatepasswordMessage = "The password is expired due to some security enhancements. Please update the new password."
    var cmsForceUpdatepasswordTitle = "Update Password"
    var cmsForceUpdatepasswordButton = "Update"
    var cmsShowPsString = "Show Password"
    var cmsHidePsString = "Hide Password"
    
    private var cmsUpdatePassword = ""
    private var cmsPasswordExpired = ""
    private var cmsPasswordWarning = ""
    private var cmsPasswordWarningsingular = ""
    private var cmsDismiss = ""
    private var cmsUpdate = ""
    
    override func viewDidLoad() {
        self.kenticoCodeName = "app___sign_in"
        self.kenticoDepth = 3
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CurrentSession.share.logout()
    }
    
    override func setText() {
        super.setText()
        if let titleStr = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___form_sign_in.elements.title.value") as? String {
            cmsTitleString = titleStr
        }
        if let welcomeStr = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___form_sign_in.elements.description.value") as? String {
            cmsWelcomeString = welcomeStr
        }
        if let emailStr = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___sign_in_email.elements.watermark_message.value") as? String {
            cmsEmailString = emailStr
        }
        if let languageStr = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___form_sign_in.elements.cta_text3.value") as? String {
            cmsLanguageString = languageStr
        }
        if let foundAccountWithEmailCMSStr = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___form_sign_in.elements.description_1.value") as? String {
            cmsFoundAccountWithEmailString = foundAccountWithEmailCMSStr
        }
        if let passwordStr = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___sign_in_password.elements.watermark_message.value") as? String {
            cmsPasswordString = passwordStr
        }
        if let forgotPasswordStr = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___form_sign_in.elements.cta_text2.value") as? String {
            cmsForgotPasswordString = forgotPasswordStr
        }
        if let signinStr = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___form_sign_in.elements.cta_text1.value") as? String {
            cmsSignInButtonString = signinStr
        }
        if let invalidAccountStr = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___incorrect_account.elements.description.value") as? String {
            cmsKAccountInvalid = invalidAccountStr
        }
        if let invalidAccountStr = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___missing_required_fields.elements.description.value") as? String {
            cmsKEmtpyCredentials = invalidAccountStr
        }
        if let turnOnBiometricString = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___biometric_message.elements.description.value") as? String {
            cmsTurnOnBiometricString = turnOnBiometricString
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___biometric_setting_message.elements.description.value") as? String {
            cmsDeviceTurnOnBiometricString = str
        }
        if let manyFailedBiometric = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___authentication_biometric.elements.description.value") as? String {
            cmsManyFailedBiometric = manyFailedBiometric
        }
        if let errorSring = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___biometric_message.elements.title.value") as? String {
            cmsErrorString = errorSring
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___force_to_update_the_password.elements.description.value") as? String {
            cmsForceUpdatepasswordMessage = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___force_to_update_the_password.elements.title.value") as? String {
            cmsForceUpdatepasswordTitle = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___force_to_update_the_password.elements.cta_text1.value") as? String {
            cmsForceUpdatepasswordButton = str
        }
        
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___change_password.elements.cta_text2.value") as? String {
            cmsShowPsString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___change_password.elements.cta_text3.value") as? String {
            cmsHidePsString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___password_policy.elements.title.value") as? String {
            cmsUpdatePassword = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___password_policy.elements.description_1.value") as? String {
            cmsPasswordExpired = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___password_policy.elements.description.value") as? String {
            cmsPasswordWarning = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___password_policy.elements.watermark_text.value") as? String {
            cmsPasswordWarningsingular = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___password_policy.elements.cta_text2.value") as? String {
            cmsDismiss = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___password_policy.elements.cta_text1.value") as? String {
            cmsUpdate = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___authentication_biometric.elements.cta_text1.value") as? String {
            AppContants.shared.cmsDoneSystemString = str
        }
        
        title = cmsTitleString
        titleLabel.text = cmsWelcomeString
        emailTextField.attributedPlaceholder = cmsEmailString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
        passwordTextField.attributedPlaceholder = cmsPasswordString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
        btnRightItem?.setTitle(cmsLanguageString, for: .normal)
        forgotPassworButton.setTitle(cmsForgotPasswordString, for: .normal)
        signInButton.setTitle(cmsSignInButtonString, for: .normal)
        self.showPsButton.setTitle(cmsShowPsString, for: .normal)
        if let email = self.emailString, !email.isEmpty {
            self.emailTextField.text = email
            subTitleLabel.attributedText = (isFromRegister ? cmsFoundAccountWithEmailString : "").toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
            passwordTextField.becomeFirstResponder()
        } else {
            subTitleLabel.text = ""
        }
    }
    
    override func setupUI() {
        super.setupUI()
        title = cmsTitleString
        createBackBarButton()
        createRightBarButtonWithTitle(title: cmsLanguageString)
        titleLabel = {
            let label = UILabel()
            label.text = cmsWelcomeString
            label.font = UIFont(name: Fonts.regularFont, size: Sizes.titleGreeting)
            label.textColor = Colors.navigationBarTitle
            return label
        }()
        
        subTitleLabel = {
            let label = UILabel()
            label.attributedText = cmsFoundAccountWithEmailString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
            label.numberOfLines = 0
            label.sizeToFit()
            label.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
            label.textColor = Colors.placeholderTextColor
            label.backgroundColor = UIColor.clear
            return label
        }()
        
        
        emailTextField = {
            let textField = UITextField()
            textField.setCommonStyle()
            textField.attributedPlaceholder = cmsEmailString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
            textField.addBorderWithDarkAtBottom(color: Colors.navigationBarTitle)
            textField.clearButtonMode = .whileEditing
            textField.keyboardType = .emailAddress
            textField.tintColor = Colors.placeholderTextColor
            textField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
            textField.accessibilityIdentifier = "emailField"
            return textField
        }()
        
        passwordTextField = {
            let textField = UITextField()
            textField.setCommonStyle()
            textField.attributedPlaceholder = cmsPasswordString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
            textField.addBorderWithDarkAtBottom(color: Colors.navigationBarTitle)
            textField.clearButtonMode = .whileEditing
            textField.isSecureTextEntry = true
            textField.tintColor = Colors.placeholderTextColor
            textField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
            textField.accessibilityIdentifier = "passwordField"
            return textField
        }()
        
        showPsButton = {
            let btn = UIButton()
            btn.contentHorizontalAlignment = .right
            btn.backgroundColor = Colors.clear
            btn.setTitleColor(Colors.navigationBarTitle, for: .normal)
            btn.titleLabel?.font = UIFont(name: Fonts.regularFont, size: Sizes.headerText)
            btn.addTarget(self, action: #selector(showPsAction), for: .touchUpInside)
            return btn
        }()
        
        forgotPassworButton = {
            let button = UIButton()
            button.setTitle(cmsForgotPasswordString, for: .normal)
            button.backgroundColor = .clear
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitleColor(UIColor.lightGray, for: .highlighted)
            button.titleLabel?.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
            button.addTarget(self, action: #selector(action_forgotPassword), for: .touchUpInside)
            return button
        }()
        
        signInButton = {
            let button = UIButton()
            button.setTitle(cmsSignInButtonString, for: .normal)
            button.setCommonButtonStyle()
            button.addTarget(self, action: #selector(action_signIn), for: .touchUpInside)
            return button
        }()
        
        biometricButton = {
            let button = UIButton()
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
            button.tintColor = .white
            button.imageView?.contentMode = .scaleToFill
            button.addTarget(self, action: #selector(action_biometric), for: .touchUpInside)
            button.accessibilityIdentifier = "signin_biometric_button"
            return button
        }()
        
        if BiometricManager.shared.biometricType() == .faceID{
            biometricButton.setImage(UIImage(systemName:  "faceid"), for: .normal)
        }else if BiometricManager.shared.biometricType() == .touchID{
            biometricButton.setImage(UIImage(systemName:  "touchid"), for: .normal)
        }
        
        
        [titleLabel,subTitleLabel, emailTextField, passwordTextField, self.showPsButton, forgotPassworButton, signInButton, biometricButton].forEach({view.addSubview($0)})
        
        titleLabel.setupConstraints(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 50, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 0))
        subTitleLabel.setupConstraints(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 30, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 0))
        emailTextField.setupConstraints(top: subTitleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 30, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 60*SCREEN_HEIGHT_SCALE))
        
        passwordTextField.setupConstraints(top: emailTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 20, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 60*SCREEN_HEIGHT_SCALE))
        showPsButton.setupConstraints(top: passwordTextField.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 8, left: 0, bottom: 0, right: 20), size: .init(width: 200, height: 35))
        forgotPassworButton.setupConstraints(top: showPsButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 20, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 30))
        signInButton.setupConstraints(top: forgotPassworButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 25, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 60*SCREEN_HEIGHT_SCALE))
        biometricButton.setupConstraints(top: signInButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, withPadding: .init(top: 30, left: 0, bottom: 0, right: 0), size: .init(width: 70, height: 70))
        biometricButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    override func righBarItemTouch() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func textFieldDidChange(sender:UITextField) {
        sender.hideError()
    }
    
    @objc func showPsAction() {
        self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
        self.showPsButton.setTitle(self.passwordTextField.isSecureTextEntry ? cmsShowPsString:cmsHidePsString, for: .normal)
    }
    
    @objc func action_signIn(){
        self.view.endEditing(true)
        guard let email = self.emailTextField.text?.trim(), let ps  = self.passwordTextField.text, !email.isEmpty , !ps.isEmpty else{
            self.emailTextField.showErrorMessage(message: cmsKEmtpyCredentials, rightButtonTitle: nil, rightButtonAction: nil)
            return
        }
        if  email.isValidEmail(){
            ACProgressHUD.shared.showHUD()
            AzureServices().loginWith(username: email, psw: ps) {[weak self] results in
                guard let _self = self else{ return}
                switch results {
                case .success(()):
                    _self.verifyBinAndNextProcess()
                case .failure(let err):
                    Crashlytics.crashlytics().record(error: err)
                    ACProgressHUD.shared.hideHUD()
                    _self.handleError(err: err)
                }
            }
        } else {
//            self.emailTextField.showErrorMessage(message: cmsKAccountInvalid, rightButtonTitle: nil, rightButtonAction: nil)
            self.moveToAppScreen()
        }
    }
    
    @objc func action_biometric(){
        if BiometricManager.shared.getIsEnabledBiometric(){
            BiometricManager.shared.canEvaluatePolicy { result in
                switch result{
                case .success( _):
                    BiometricManager.shared.authenticateUser {[weak self] results in
                        guard let self = self else {return}
                        switch results {
                        case .success(_):
                            self.biometricSigninProcess()
                        case .failure(let error):
                            Crashlytics.crashlytics().record(error: error)
                            self.showAlert(withTitle: self.cmsErrorString, andMessage: self.cmsManyFailedBiometric)
                        }
                    }
                case .failure(let error):
                    Crashlytics.crashlytics().record(error: error)
                    UtilServices.shared.showAlert(withTitle: self.cmsErrorString, andMessage: self.cmsDeviceTurnOnBiometricString, view: self)
                }
            }
        }else{
            UtilServices.shared.showAlert(withTitle: self.cmsErrorString, andMessage: self.cmsTurnOnBiometricString, view: self)
        }
    }
    
    
    private func biometricSigninProcess(){
        DispatchQueue.main.async {
            ACProgressHUD.shared.showHUD()
        }
        AzureServices().autoLoginWithRefreshToken {[weak self] results in
            switch results {
            case .success(()):
                self?.verifyBinAndNextProcess()
            case .failure(let error):
                ACProgressHUD.shared.hideHUD()
                Crashlytics.crashlytics().record(error: error)
                if let networkErr = error as? NetworkError, networkErr == NetworkError.noInternet { return }
                self?.emailTextField.showErrorMessage(message: error.localizedDescription)
//                FirebaseTracking.share.logEvent(event: FirebaseEvent.login, viewController: self!, parameter: ["login_stage": "log_in_failure", "login_error": error.localizedDescription])
            }
        }
    }
    
    private func verifyBinAndNextProcess() {
        AzureServices().getProgramInfoWith(bin: CurrentSession.share.aspireProfile!.getAccessCode()) {[weak self] results in
            switch results {
            case .success(let programDetail):
                if(programDetail.status == 1) {  //accesscode valid
                    OktaServices().getListFactorEnrolled {[weak self] results in
                        ACProgressHUD.shared.hideHUD()
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
                                self.moveToAppScreen()
                            }else {
                                self.moveToVerifyViaEmail()
                            }
                        case .failure(let error):
                            Crashlytics.crashlytics().record(error: error)
                            self.moveToAppScreen()
                        }
                    }
//                    FirebaseTracking.share.logEvent(event: FirebaseEvent.login, viewController: self, parameter: ["login_stage": "log_in_success", "login_error": ""])
                }else { //accesscode expired
                    ACProgressHUD.shared.hideHUD()
                    self?.goToInvalidAccessCodeScreen()
                }
            case .failure(let error):
                ACProgressHUD.shared.hideHUD()
                Crashlytics.crashlytics().record(error: error)
                if let networkErr = error as? NetworkError, networkErr == NetworkError.noInternet { return }
                if let error = error as? APIError, error == APIError.accesscodeInvalid { //accesscode invalid
                    self?.goToInvalidAccessCodeScreen()
                }else {
//                    FirebaseTracking.share.logEvent(event: FirebaseEvent.login, viewController: self!, parameter: ["login_stage": "log_in_failure", "login_error": error.localizedDescription])
//                    self?.emailTextField.showErrorMessage(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func moveToVerifyViaEmail(){
        DispatchQueue.main.async { [weak self] in
            let verifyEmailVC = VerifyViaEmailViewController(flow: .registrationFlow)
            self?.navigationController?.pushViewController(verifyEmailVC, animated: true)
        }
    }
    
    private func moveToAppScreen() {
        if let ps  = self.passwordTextField.text, (ps.count < kMinLengthOfPsw && !ps.isEmpty) {
//            self.showAlert(withTitle: self.cmsForceUpdatepasswordTitle, andMessage: self.cmsForceUpdatepasswordMessage, btn1Title: self.cmsForceUpdatepasswordButton, btn1Action:  {
//                let changePasswordVC = ChangePasswordViewController(dic: self.kenticoDic)
//                self.navigationController?.pushViewController(changePasswordVC, animated: true)
//            })
            self.goToMainScreen()
        }else {
            self.goToMainScreen()
        }
    }
    
    private func psSigninExpiredHandle(psAge: Int) {
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
        changePasswordVC.isWarningPsExpired = true
        self.navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    
    
    
    private func goToInvalidAccessCodeScreen() {
        DispatchQueue.main.async {
            let invalidCodeScreen = AccessCodeExpiredViewController()
            self.navigationController?.pushViewController(invalidCodeScreen, animated: true)
        }
    }
    
    private func goToLockOutScreen() {
        DispatchQueue.main.async {
            ACProgressHUD.shared.hideHUD()
            let lockScreen = AccountBlockOutViewController()
            self.navigationController?.pushViewController(lockScreen, animated: true)
        }
    }
    
    private func handleError(err:Error) {
        DispatchQueue.main.async {
            Crashlytics.crashlytics().record(error: err)
            if let networkErr = err as? NetworkError, networkErr == NetworkError.noInternet { return }
            if let error = err as? APIError {
                if error == APIError.account_locked_out {
                    self.goToLockOutScreen()
                } else if error == APIError.invalid_grant || error == APIError.email_not_exits_okta {
                    self.emailTextField.showErrorMessage(message: self.cmsKAccountInvalid, rightButtonTitle: nil, rightButtonAction: nil)
//                    FirebaseTracking.share.logEvent(event: FirebaseEvent.login, viewController: self, parameter: ["login_stage": "log_in_failure", "login_error": self.cmsKAccountInvalid])
                }
            } else {
                self.emailTextField.showErrorMessage(message: err.localizedDescription , rightButtonTitle: nil, rightButtonAction: nil)
//                FirebaseTracking.share.logEvent(event: FirebaseEvent.login, viewController: self, parameter: ["login_stage": "log_in_failure", "login_error": err.localizedDescription])
            }
        }
    }
    
    @objc func action_forgotPassword(){
        DispatchQueue.main.async { [weak self] in
            let forgotPasswordVC = ForgotPasswordViewController()
            self?.navigationController?.pushViewController(forgotPasswordVC, animated: true)
        }
    }
}
