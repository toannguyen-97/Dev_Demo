//
//  ForgotPasswordViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//

import Foundation
import UIKit
import ACProgressHUD_Swift
import FirebaseCrashlytics

class ForgotPasswordViewController: BaseWithBlurViewController{
    private var titleLabel: UILabel!
    private var textLable: UILabel!
    private var emailTextField: UITextField!
    private var continueButton: UIButton!
    
    // CMS String
    var cmsForgotPasswordString = "Forgot your \npassword?"
    var cmsEnterEmailAddressString = "Enter the email address associated with your account so that we are able to assist you in accessing your account."
    var cmsEmailString = "Email"
    var cmsContinueString = "Continue"
    var cmsKErrorAccountExist = "We found your account, but you need to complete registration"
    var cmsKErrorAccountNotExist = "No account with this email address has been found"
    var cmsKInvalidEmail = "Please enter a valid email address"
    var cmsRegisterString = "Register"
    var cmsLanguageString = "Language"
    
    override func viewDidLoad() {
        self.kenticoCodeName = "app___forgot_password"
        self.kenticoDepth = 3
        super.viewDidLoad()
    }
    
    override func setText() {
        super.setText()
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___forgot_password_email.elements.description.value") as? String {
            cmsForgotPasswordString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___forgot_password_email.elements.description_1.value") as? String {
            cmsEnterEmailAddressString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___forgot_password_email_field.elements.watermark_message.value") as? String {
            cmsEmailString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___forgot_password_email.elements.cta_text1.value") as? String {
            cmsContinueString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___found_account_but_not_complete.elements.title.value") as? String {
            cmsKErrorAccountExist = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___found_account_but_not_complete.elements.description.value") as? String {
            cmsRegisterString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___no_account_with_email_error_message.elements.title.value") as? String {
            cmsKErrorAccountNotExist = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___email_required_field_error_message.elements.description.value") as? String {
            cmsKInvalidEmail = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___forgot_password_email.elements.cta_text2.value") as? String {
            cmsLanguageString = str
        }
        self.btnRightItem?.setTitle(cmsLanguageString, for: .normal)
        self.btnRightItem?.sizeToFit()
        titleLabel.text = cmsForgotPasswordString
        textLable.attributedText = cmsEnterEmailAddressString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.navigationBarTitle, lineSpacing: 5)
        emailTextField.attributedPlaceholder = cmsEmailString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
        continueButton.setTitle(cmsContinueString, for: .normal)
    }
    
    override func setupUI() {
        super.setupUI()
        createBackBarButton()
        self.createRightBarButtonWithTitle(title: cmsLanguageString)
        titleLabel = {
            let label = UILabel()
            label.text = cmsForgotPasswordString
            label.font = UIFont(name: Fonts.regularFont, size: Sizes.titleGreeting)
            label.textColor = Colors.navigationBarTitle
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        
        textLable = {
            let label = UILabel()
            label.attributedText = cmsEnterEmailAddressString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.navigationBarTitle, lineSpacing: 5)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        
        emailTextField = {
            let textField = UITextField()
            textField.setCommonStyle()
            textField.attributedPlaceholder = cmsEmailString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
            textField.addBorderWithDarkAtBottom(color: Colors.navigationBarTitle)
            textField.clearButtonMode = .whileEditing
            textField.tintColor = Colors.placeholderTextColor
            textField.delegate = self
            textField.accessibilityIdentifier = "emailField"
            return textField
        }()
        
        continueButton = {
            let button = UIButton()
            button.setTitle(cmsContinueString, for: .normal)
            button.setCommonButtonStyle()
            button.addTarget(self, action: #selector(action_forgotPassword), for: .touchUpInside)
            return button
        }()
        [titleLabel, textLable, emailTextField, continueButton].forEach({view.addSubview($0)})
        
        titleLabel.setupConstraints(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 10, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 100))
        textLable.setupConstraints(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 20, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 0))
        emailTextField.setupConstraints(top: textLable.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 30, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 60*SCREEN_HEIGHT_SCALE))
        continueButton.setupConstraints(top: emailTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 20, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 60*SCREEN_HEIGHT_SCALE))
    
    }
    
    override func righBarItemTouch() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        // show Language Screen
//        let languageScreen = SelectLanguageViewController()
//        self.navigationController?.pushViewController(languageScreen, animated: true)
    }
    
    @objc func action_forgotPassword(){
        guard let email = emailTextField.text?.trim() , !email.isEmpty else {
            emailTextField.showErrorMessage(message: cmsKInvalidEmail)
            return
        }
        guard email.isValidEmail() else {
            emailTextField.showErrorMessage(message: cmsKInvalidEmail)
            return
        }
        ACProgressHUD.shared.showHUD()
        OktaServices().getOktaProfileWithEmail(email: email) { result in
            switch result{
            case .success(let oktaProfile):
                if oktaProfile.status == "ACTIVE"{
                    SearchPartyServices().getPartyUserPofile(email: email) { result in
                        ACProgressHUD.shared.hideHUD()
                        switch result{
                        case .success(let pmaProfile):
                            print(pmaProfile)
                            self.moveToVerifyViaEmail()
                        case .failure(let pmaErr):
                            if let networkErr = pmaErr as? NetworkError, networkErr == NetworkError.noInternet { return }
                            if let error = pmaErr as? APIError, error == APIError.email_not_exits_pma{
                                self.emailTextField.showErrorMessage(message: self.cmsKErrorAccountNotExist, rightButtonTitle: self.cmsRegisterString) {
                                    self.moveToVerifyAccessCode()
                                }
                            }else {
                                self.emailTextField.showErrorMessage(message: pmaErr.localizedDescription)
                            }
                        }
                    }
                }else{
                    ACProgressHUD.shared.hideHUD()
                    self.moveToAccountBlockScreen()
                }
            case .failure(let err):
                Crashlytics.crashlytics().record(error: err)
                if let networkErr = err as? NetworkError, networkErr == NetworkError.noInternet { return }
                if let error = err as? APIError, error == APIError.email_not_exits_okta{
                    SearchPartyServices().getPartyUserPofile(email: email) { [weak self] (result) in
                        guard let self = self else {return}
                        ACProgressHUD.shared.hideHUD()
                        switch result{
                        case .success( _):
                            self.emailTextField.showErrorMessage(message: self.cmsKErrorAccountExist, rightButtonTitle: self.cmsRegisterString) {
                                self.moveToVerifyAccessCode()
                            }
                        case .failure(let err):
                            Crashlytics.crashlytics().record(error: err)
                            if let networkErr = err as? NetworkError, networkErr == NetworkError.noInternet { return }
                            if let error = err as? APIError, error == APIError.email_not_exits_pma{
                                self.emailTextField.showErrorMessage(message: self.cmsKErrorAccountNotExist, rightButtonTitle: self.cmsRegisterString) {
                                    self.moveToVerifyAccessCode()
                                }
                            }else {
                                self.emailTextField.showErrorMessage(message: err.localizedDescription)
                            }
                        }
                    }
                }else {
                    ACProgressHUD.shared.hideHUD()
                    self.emailTextField.showErrorMessage(message: err.localizedDescription)
                }
            }
        }
        
    }
    
    private func moveToVerifyAccessCode(){
        DispatchQueue.main.async { [weak self] in
            let accessCodeVC = VerifyAccessCodeViewController()
            self?.navigationController?.pushViewController(accessCodeVC, animated: true)
        }
    }
    
    private func moveToVerifyViaEmail(){
        DispatchQueue.main.async { [weak self] in
            let verifyEmailVC = VerifyViaEmailViewController(flow: .forgotPasswordFlow)
            self?.navigationController?.pushViewController(verifyEmailVC, animated: true)
        }
    }
    
    private func moveToAccountBlockScreen(){
        DispatchQueue.main.async { [weak self] in
            let blockScreen = AccountBlockOutViewController()
            self?.navigationController?.pushViewController(blockScreen, animated: true)
        }
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.hideError()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
