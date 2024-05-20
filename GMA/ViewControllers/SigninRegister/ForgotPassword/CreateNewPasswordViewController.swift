//
//  CreateNewPasswordViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//

import Foundation
import UIKit
import ACProgressHUD_Swift
import FirebaseCrashlytics

class CreateNewPasswordViewController: BaseWithBlurViewController {
    
    private var titleLabel: UILabel!
    private var passwordTF: UITextField!
    private var repeatPasswordTF: UITextField!
    private var showPsButton: UIButton!
    private var textLabel: UILabel!
    private var leftStack: UIStackView!
    private var rightStack: UIStackView!
    private var setPasswordButton: UIButton!
    
    private var upperCondition: ConditionView!
    private var lowerCondition: ConditionView!
    private var digitCondition: ConditionView!
    private var specialCondition: ConditionView!
    private var lenghtCondition: ConditionView!
    private var flowType: flowType!
    private var isFactorEnrolled: Bool!
    private var isEmail: Bool!
    private var stateToken: String?
    
    convenience init(flow: flowType, factor: Bool, email: Bool, stateToken: String?){
        self.init()
        self.flowType = flow
        self.isFactorEnrolled = factor
        self.isEmail = email
        self.stateToken = stateToken
    }
    
    override func viewDidLoad() {
        self.kenticoCodeName = "app___forgot_password"
        self.kenticoDepth = 3
        super.viewDidLoad()
    }
    
//    var cmsCreatePasswordString = "Create new \npassword"
//    var cmsPasswordString = "Password"
//    var cmsRepeatPasswordString = "Repeat Password"
//    var cmsCreatePasswordButtonString = "Create New Password"
//    var cmsNotUseFirstLastNameString = "Please do not use your first or last name in a password"
//    var cmsUpperCondString = "Uppercase"
//    var cmsLowerCondString = "Lowercase"
//    var cmsDigitCondString = "Digit"
//    var cmsSpecialCondString = "Special character"
//    var cmsLenghtCondString = "At least 10 characters long"
//    var cmsKErrorEmptyPassword = "Please provide a password."
//    var cmsKPasswordNotMatchRequirements = "Please provide a password that matches all requirement described above."
//    var cmsKPasswordDontMatch = "These passwords don’t match, try again."
//    var cmsKPasswordTooRecently = "You cannot use the same password as the last 10 passwords"
    var cmsCreatePasswordString = ""
    var cmsPasswordString = ""
    var cmsRepeatPasswordString = ""
    var cmsCreatePasswordButtonString = ""
    var cmsNotUseFirstLastNameString = ""
    var cmsUpperCondString = ""
    var cmsLowerCondString = ""
    var cmsDigitCondString = ""
    var cmsSpecialCondString = ""
    var cmsLenghtCondString = ""
    var cmsKErrorEmptyPassword = ""
    var cmsKPasswordNotMatchRequirements = ""
    var cmsKPasswordDontMatch = ""
    var cmsKPasswordTooRecently = ""
    var cmsKPasswordContainsPartEmailNameString = ""
    
    var cmsShowPsString = "Show Password"
    var cmsHidePsString = "Hide Password"
    
    override func setText() {
        super.setText()
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app_create_password.elements.description_1.value") as? String {
            cmsCreatePasswordString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___new_password.elements.watermark_message.value") as? String {
            cmsPasswordString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___repeat_password.elements.watermark_message.value") as? String {
            cmsRepeatPasswordString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app_create_password.elements.cta_text1.value") as? String {
            cmsCreatePasswordButtonString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___password_requirement.elements.watermark_message.value") as? String {
            cmsNotUseFirstLastNameString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___uppercase.elements.text.value") as? String {
            cmsUpperCondString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___uppercase.elements.text.value") as? String {
            cmsUpperCondString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___lowercase.elements.text.value") as? String {
            cmsLowerCondString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___digit.elements.text.value") as? String {
            cmsDigitCondString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___special_character.elements.text.value") as? String {
            cmsSpecialCondString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___at_least_10_characters_long.elements.text.value") as? String {
            cmsLenghtCondString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app_password_required_field_error_message.elements.description.value") as? String {
            cmsKErrorEmptyPassword = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___no_matching_error_message.elements.description.value") as? String {
            cmsKPasswordNotMatchRequirements = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___password_and_repeat_password_not_match.elements.description.value") as? String {
            cmsKPasswordDontMatch = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___cannot_use_the_same_password_error_message.elements.description.value") as? String {
            cmsKPasswordTooRecently = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___the_password_includes_username__first_name__.elements.description.value") as? String{
            cmsKPasswordContainsPartEmailNameString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app_create_password.elements.cta_text3.value") as? String {
               cmsShowPsString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app_create_password.elements.cta_text4.value") as? String {
               cmsHidePsString = str
        }
        
        titleLabel.text = cmsCreatePasswordString
        passwordTF.attributedPlaceholder = cmsPasswordString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
        repeatPasswordTF.attributedPlaceholder = cmsRepeatPasswordString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
        textLabel.attributedText = cmsNotUseFirstLastNameString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.headerText, color: Colors.navigationBarButtonItemTitle, lineSpacing: 5)
        self.showPsButton.setTitle(cmsShowPsString, for: .normal)
        upperCondition.title = cmsUpperCondString
        lowerCondition.title = cmsLowerCondString
        digitCondition.title = cmsDigitCondString
        specialCondition.title = cmsSpecialCondString
        lenghtCondition.title = cmsLenghtCondString
        setPasswordButton.setTitle(cmsCreatePasswordButtonString, for: .normal)
    }
    
    override func setupUI() {
        super.setupUI()
        createBackBarButton()
        titleLabel = {
            let label = UILabel()
            label.text = cmsCreatePasswordString
            label.font = UIFont(name: Fonts.regularFont, size: Sizes.titleGreeting)
            label.textColor = Colors.navigationBarTitle
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        
        passwordTF = {
            let textField = UITextField()
            textField.setCommonStyle()
            textField.attributedPlaceholder = cmsPasswordString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
            textField.addBorderWithDarkAtBottom(color: Colors.navigationBarTitle)
            textField.clearButtonMode = .whileEditing
            textField.tintColor = Colors.placeholderTextColor
            textField.delegate = self
            textField.isSecureTextEntry = true
            textField.accessibilityIdentifier = "passwordField"
            return textField
        }()
        
        repeatPasswordTF = {
            let textField = UITextField()
            textField.setCommonStyle()
            textField.attributedPlaceholder = cmsRepeatPasswordString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
            textField.addBorderWithDarkAtBottom(color: Colors.navigationBarTitle)
            textField.clearButtonMode = .whileEditing
            textField.tintColor = Colors.placeholderTextColor
            textField.delegate = self
            textField.isSecureTextEntry = true
            textField.accessibilityIdentifier = "repeatPasswordField"
            return textField
        }()
        
        showPsButton = {
           let btn = UIButton()
            btn.contentHorizontalAlignment = .right
            btn.backgroundColor = Colors.clear
            btn.setTitleColor(Colors.navigationBarButtonItemTitle, for: .normal)
            btn.titleLabel?.font = UIFont(name: Fonts.regularFont, size: Sizes.headerText)
            btn.addTarget(self, action: #selector(showPsTapped), for: .touchUpInside)
            return btn
        }()
        
        textLabel = {
            let label = UILabel()
            label.attributedText = cmsNotUseFirstLastNameString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.headerText, color: Colors.navigationBarButtonItemTitle, lineSpacing: 5)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        
        upperCondition = {
            let view = ConditionView()
            view.btnCheck.tintColor = Colors.navigationBarButtonItemTitle
            view.title = cmsUpperCondString
            view.isValid = false
            return view
        }()
        
        lowerCondition = {
            let view = ConditionView()
            view.btnCheck.tintColor = Colors.navigationBarButtonItemTitle
            view.title = cmsLowerCondString
            view.isValid = false
            return view
        }()
        
        digitCondition = {
            let view = ConditionView()
            view.btnCheck.tintColor = Colors.navigationBarButtonItemTitle
            view.title = cmsDigitCondString
            view.isValid = false
            return view
        }()
        
        specialCondition = {
            let view = ConditionView()
            view.btnCheck.tintColor = Colors.navigationBarButtonItemTitle
            view.title = cmsSpecialCondString
            view.isValid = false
            return view
        }()
        
        lenghtCondition = {
            let view = ConditionView()
            view.btnCheck.tintColor = Colors.navigationBarButtonItemTitle
            view.title = cmsLenghtCondString
            view.isValid = false
            return view
        }()
        
        leftStack = {
            let stackView = UIStackView(arrangedSubviews: [upperCondition, lowerCondition, digitCondition])
            stackView.distribution = .fillEqually
            stackView.axis = .vertical
            return stackView
        }()
        
        rightStack = {
            let stackView = UIStackView(arrangedSubviews: [specialCondition, lenghtCondition])
            stackView.distribution = .fillEqually
            stackView.axis = .vertical
            return stackView
        }()
        
        setPasswordButton = {
            let button = UIButton()
            button.setTitle(cmsCreatePasswordButtonString, for: .normal)
            button.setCommonButtonStyle()
            button.isEnabled = false
            button.addTarget(self, action: #selector(action_setPassword), for: .touchUpInside)
            return button
        }()
        
        [titleLabel, passwordTF, repeatPasswordTF, showPsButton, textLabel, leftStack, rightStack,setPasswordButton].forEach({view.addSubview($0)})
        
        titleLabel.setupConstraints(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 40, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 100))
        passwordTF.setupConstraints(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 30, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 60*SCREEN_HEIGHT_SCALE))
        repeatPasswordTF.setupConstraints(top: passwordTF.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 20, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 60*SCREEN_HEIGHT_SCALE))
        showPsButton.setupConstraints(top: repeatPasswordTF.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 8, left: 20, bottom: 0, right: 20), size: .init(width: 200, height: 35))
        textLabel.setupConstraints(top: showPsButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 15, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 17))
        leftStack.setupConstraints(top: textLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, withPadding: .init(top: 20, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 110))
        leftStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2, constant: -25).isActive = true
        rightStack.setupConstraints(top: textLabel.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 20, left: 0, bottom: 0, right: 20), size: .init(width: 0, height: 70))
        rightStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2, constant: -5).isActive = true
        setPasswordButton.setupConstraints(top: leftStack.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 40, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 60*SCREEN_HEIGHT_SCALE))
    }
    
    private func validatePsw() -> Bool {
        return upperCondition.isValid && lowerCondition.isValid && digitCondition.isValid && specialCondition.isValid && lenghtCondition.isValid
    }
    
    @objc func showPsTapped() {
        self.repeatPasswordTF.isSecureTextEntry = !self.repeatPasswordTF.isSecureTextEntry
        self.passwordTF.isSecureTextEntry = !self.passwordTF.isSecureTextEntry
        self.showPsButton.setTitle(self.passwordTF.isSecureTextEntry ? cmsShowPsString:cmsHidePsString, for: .normal)
    }
    
    @objc func action_setPassword(){
        if passwordTF.text != repeatPasswordTF.text{
            repeatPasswordTF.showErrorMessage(message: cmsKPasswordDontMatch)
        }else{
            if validatePsw(){
                if let password = passwordTF.text{
                    if self.isFactorEnrolled && self.flowType == .forgotPasswordFlow && !self.isEmail{
                        ACProgressHUD.shared.showHUD()
                        OktaServices().resetPassword(stateToken: self.stateToken!, password: password) { result in
                            ACProgressHUD.shared.hideHUD()
                            switch result{
                            case .success(let response):
                                print(response)
                                self.moveToNextVC()
                            case .failure(let error):
                                Crashlytics.crashlytics().record(error: error)
                                if let networkErr = error as? NetworkError, networkErr == NetworkError.noInternet { return }
                                if let apiError = error as? APIError {
                                    if apiError == APIError.password_too_recently {
                                        self.repeatPasswordTF.showErrorMessage(message: self.cmsKPasswordTooRecently)
                                        Crashlytics.crashlytics().record(error: APIError.password_too_recently)
                                    }else if apiError == APIError.password_contains_part_email_fullName {
                                        self.repeatPasswordTF.showErrorMessage(message: self.cmsKPasswordContainsPartEmailNameString)
                                        Crashlytics.crashlytics().record(error: APIError.password_contains_part_email_fullName)
                                    }else {
                                        Crashlytics.crashlytics().record(error: error)
                                        self.repeatPasswordTF.showErrorMessage(message: error.localizedDescription)
                                    }
                                }else {
                                    self.repeatPasswordTF.showErrorMessage(message: APIError.password_contains_part_email_fullName.localizedDescription)
                                    Crashlytics.crashlytics().record(error: APIError.password_contains_part_email_fullName)
                                }
                            }
                        }
                    }else{
                        ACProgressHUD.shared.showHUD()
                        OktaServices().setOktaPassword(with: password) { result in
                            ACProgressHUD.shared.hideHUD()
                            switch result{
                            case .success( _):
                                self.moveToNextVC()
                            case .failure(let error):
                                Crashlytics.crashlytics().record(error: error)
                                if let networkErr = error as? NetworkError, networkErr == NetworkError.noInternet { return }
                                if let err =  error as? APIError {
                                    if err == APIError.password_too_recently {
                                        self.repeatPasswordTF.showErrorMessage(message: self.cmsKPasswordTooRecently)
                                    }else if err == APIError.password_contains_part_email_fullName {
                                        self.repeatPasswordTF.showErrorMessage(message: self.cmsKPasswordContainsPartEmailNameString)
                                    }else {
                                        self.repeatPasswordTF.showErrorMessage(message: error.localizedDescription)
                                    }
                                }else {
                                    self.repeatPasswordTF.showErrorMessage(message: error.localizedDescription)
                                }
                            }
                        }
                    }
                }
            }else{
                repeatPasswordTF.showErrorMessage(message: cmsKPasswordNotMatchRequirements)
            }
        }
    }
    
    private func moveToNextVC(){
        DispatchQueue.main.async { [weak self] in
            let newPasswordCreatedVC = NewPasswordCreatedViewController()
            self?.navigationController?.pushViewController(newPasswordCreatedVC, animated: true)
        }
    }
    
    override func backViewController() {
        if flowType == .forgotPasswordFlow {
            if let viewcontrollers = self.navigationController?.viewControllers {
                for vc in viewcontrollers {
                    if vc.isKind(of: ForgotPasswordViewController.self) {
                        self.navigationController?.popToViewController(vc, animated: true)
                        return
                    }
                }
            }
            super.backViewController()
        }else {
            super.backViewController()
        }
    }
}

extension CreateNewPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.hideError()
        if let psw = passwordTF.text, !psw.isEmpty, let confirmPsw = repeatPasswordTF.text, !confirmPsw.isEmpty {
            setPasswordButton.isEnabled = true
        } else {
            setPasswordButton.isEnabled = false
        }
        self.validateAndUpdateUI()
    }
    
    private func validateAndUpdateUI(){
//        guard let pwdStr = passwordTF.text else {
//            return
//        }
//        self.lenghtCondition.isValid = (pwdStr.count >= kMinLengthOfPsw)
//        
//        let lowerCondPredic = NSPredicate(format: "SELF MATCHES %@", kConditionOneLowcase)
//        self.lowerCondition.isValid = lowerCondPredic.evaluate(with: pwdStr)
//        
//        let upperCondPredic = NSPredicate(format: "SELF MATCHES %@", kConditionOneUppercase)
//        self.upperCondition.isValid = upperCondPredic.evaluate(with: pwdStr)
//        
//        let digitCondPredic = NSPredicate(format: "SELF MATCHES %@", kConditionOneDigit)
//        self.digitCondition.isValid = digitCondPredic.evaluate(with: pwdStr)
//        
//        let specialCondPredic = NSPredicate(format: "SELF MATCHES %@", kConditionOneSpecialCharater)
//        self.specialCondition.isValid = specialCondPredic.evaluate(with: pwdStr)
    }
    
}
