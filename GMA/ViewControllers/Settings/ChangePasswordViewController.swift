//
//  ChangePasswordViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//

import Foundation
import UIKit
import ACProgressHUD_Swift

class ChangePasswordViewController: BaseViewController{
    var isWarningPsExpired: Bool = false
    var forceChangePassword: Bool {
        if let rootView = self.navigationController?.viewControllers.first, rootView == self {
            return false
        }
        return true
    }
    private var currentPasswordLabel: UILabel!
    private var newPasswordLabel: UILabel!
    private var repeatPasswordLabel: UILabel!
    private var currentPasswordTF: UITextField!
    private var newPasswordTF: UITextField!
    private var repeatPasswordTF: UITextField!
    private var showPsButton: UIButton!
    private var textLabel: UILabel!
    
    private var upperCondition: ConditionView!
    private var lowerCondition: ConditionView!
    private var digitCondition: ConditionView!
    private var specialCondition: ConditionView!
    private var lenghtCondition: ConditionView!
    private var ary_conditions: [String] = []
    
    private var leftStack: UIStackView!
    private var rightStack: UIStackView!
    private var setNewPasswordButton: UIButton!
    
    // CMS String
    var cmsTitle = "Change Password"
    var cmsKPasswordNotMatchRequirements = "Please provide a password that matches all requirement described above."
    var cmsKPasswordDontMatch = "These passwords don’t match, try again."
    
    var cmsKPasswordTooRecentlyString = ""
    var cmsKPasswordContainsPartEmailNameString = ""
    var cmsKOldPasswordNotCorrectString = ""
    
    
    var cmsShowPsString = "Show Password"
    var cmsHidePsString = "Hide Password"
    
    convenience init(dic: [String: Any]?){
        self.init()
        self.kenticoDic = dic
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.navigationBarTitle
    }
    
    override func setText() {
        super.setText()
        let textColors = self.forceChangePassword ? Colors.placeholderTextColor : Colors.headerTitle
        if let dic = kenticoDic {
            if let title = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___change_password.elements.title.value") as? String{
                cmsTitle = title
                self.title = cmsTitle
            }
            if let str = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___cannot_use_the_same_password_error_message.elements.description.value") as? String{
                cmsKPasswordTooRecentlyString = str
            }
            if let str = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___the_current_password_is_incorrect.elements.description.value") as? String{
                cmsKOldPasswordNotCorrectString = str
            }
            if let str = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___the_password_includes_username__first_name__.elements.description.value") as? String{
                cmsKPasswordContainsPartEmailNameString = str
            }
            if let setPassword = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___change_password.elements.cta_text1.value") as? String{
                setNewPasswordButton.setTitle(setPassword, for: .normal)
            }
            if let str = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___no_matching_error_message.elements.description.value") as? String{
                cmsKPasswordNotMatchRequirements = str
            }
            if let str = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___password_and_repeat_password_not_match.elements.description.value") as? String{
                cmsKPasswordDontMatch = str
            }
            if let currentpassword = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___current_password.elements.label.value") as? String{
                currentPasswordLabel.attributedText = currentpassword.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.headerText, color: textColors, lineSpacing: 0)
            }
            if let newpassword = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___new_password.elements.label.value") as? String{
                newPasswordLabel.attributedText = newpassword.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.headerText, color: textColors, lineSpacing: 0)
            }
            if let repeatpassword = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___repeat_password.elements.label.value") as? String{
                repeatPasswordLabel.attributedText = repeatpassword.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.headerText, color: textColors, lineSpacing: 0)
            }
            if let description = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___password_requirement.elements.watermark_message.value") as? String{
                textLabel.attributedText = description.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.headerText, color: textColors, lineSpacing: 5)
            }
            if let str = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___change_password.elements.cta_text2.value") as? String {
                   cmsShowPsString = str
            }
            if let str = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___change_password.elements.cta_text3.value") as? String {
                   cmsHidePsString = str
            }
            
            
            self.showPsButton.setTitleColor(textColors, for: .normal)
            self.showPsButton.setTitle(cmsShowPsString, for: .normal)
            if let conditions = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___password_requirement.elements.list_items.value") as? [String]{
                conditions.forEach { condition in
                    if let item = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.\(condition).elements.text.value") as? String{
                        ary_conditions.append(item)
                    }
                }
                if ary_conditions.count == 5{
                    if self.forceChangePassword {
                        upperCondition.title = ary_conditions[0]
                        specialCondition.title = ary_conditions[1]
                        lowerCondition.title = ary_conditions[2]
                        lenghtCondition.title = ary_conditions[3]
                        digitCondition.title = ary_conditions[4]
                        self.currentPasswordTF.applyWhiteTintToClearButton()
                        self.newPasswordTF.applyWhiteTintToClearButton()
                        self.repeatPasswordTF.applyWhiteTintToClearButton()
                    }else {
                        upperCondition.title2 = ary_conditions[0]
                        specialCondition.title2 = ary_conditions[1]
                        lowerCondition.title2 = ary_conditions[2]
                        lenghtCondition.title2 = ary_conditions[3]
                        digitCondition.title2 = ary_conditions[4]
                    }
                }
            }
        }
    }
    
    override func setupUI() {
        super.setupUI()
        let borderColors = self.forceChangePassword ? Colors.navigationBarTitle : Colors.blueBackground
        let tfTintColor = self.forceChangePassword ? Colors.placeholderTextColor : Colors.black
        let tfTextColors = self.forceChangePassword ? Colors.navigationBarTitle : Colors.black
        let conditionTextColor = self.forceChangePassword ? Colors.placeholderTextColor : Colors.headerTitle
        if forceChangePassword {
            title = self.cmsTitle
            let backgroundImage = {
                let imageView = UIImageView(frame: UIScreen.main.bounds)
                imageView.image = UIImage(named: "splash")
                imageView.contentMode = .scaleToFill
                imageView.addBlur(blurStyle: .systemChromeMaterialDark)
                return imageView
            }()
            view.insertSubview(backgroundImage, at: 0)
            if isWarningPsExpired {
                self.createBackBarButton()
            }
        }else {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.blueBackground]
            let leftBarBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            leftBarBtn.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
            leftBarBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
            leftBarBtn.contentVerticalAlignment = .fill
            leftBarBtn.contentHorizontalAlignment = .fill
            leftBarBtn.tintColor = Colors.blueBackground
            let leftItem  = UIBarButtonItem(customView: leftBarBtn)
            self.navigationItem.leftBarButtonItem = leftItem
        }
        currentPasswordLabel = {
            let label = UILabel()
            return label
        }()
        newPasswordLabel = {
            let label = UILabel()
            return label
        }()
        repeatPasswordLabel = {
            let label = UILabel()
            return label
        }()
        
       
        
        currentPasswordTF = {
            let textField = UITextField()
            textField.addBorderWithDarkAtBottom(color: borderColors)
            textField.clearButtonMode = .whileEditing
            textField.tintColor = tfTintColor
            textField.isSecureTextEntry = true
            textField.textColor = tfTextColors
            textField.setLeftPadding(15)
            textField.delegate = self
            textField.enablePasswordToggle()
            textField.accessibilityIdentifier = "currentPasswordField"
            return textField
        }()
        newPasswordTF = {
            let textField = UITextField()
            textField.addBorderWithDarkAtBottom(color: borderColors)
            textField.clearButtonMode = .whileEditing
            textField.tintColor = tfTintColor
            textField.isSecureTextEntry = true
            textField.textColor = tfTextColors
            textField.setLeftPadding(15)
            textField.delegate = self
            textField.enablePasswordToggle()
            textField.accessibilityIdentifier = "newPasswordField"
            return textField
        }()
        repeatPasswordTF = {
            let textField = UITextField()
            textField.addBorderWithDarkAtBottom(color: borderColors)
            textField.clearButtonMode = .whileEditing
            textField.tintColor = tfTintColor
            textField.isSecureTextEntry = true
            textField.textColor = tfTextColors
            textField.setLeftPadding(15)
            textField.delegate = self
            textField.enablePasswordToggle()
            textField.accessibilityIdentifier = "repeatPasswordField"
            return textField
        }()
        showPsButton = {
           let btn = UIButton()
            btn.contentHorizontalAlignment = .right
            btn.setTitle("Show Password", for: .normal)
            btn.backgroundColor = Colors.clear
            btn.setTitleColor(tfTextColors, for: .normal)
            btn.titleLabel?.font = UIFont(name: Fonts.regularFont, size: Sizes.headerText)
            btn.addTarget(self, action: #selector(action_showPs), for: .touchUpInside)
            return btn
        }()
        
        textLabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        
        upperCondition = {
            let view = ConditionView()
            view.btnCheck.tintColor = conditionTextColor
            view.isValid = false
            return view
        }()
        
        lowerCondition = {
            let view = ConditionView()
            view.btnCheck.tintColor = conditionTextColor
            view.isValid = false
            return view
        }()
        
        digitCondition = {
            let view = ConditionView()
            view.btnCheck.tintColor = conditionTextColor
            view.isValid = false
            return view
        }()
        
        specialCondition = {
            let view = ConditionView()
            view.btnCheck.tintColor = conditionTextColor
            view.isValid = false
            return view
        }()
        
        lenghtCondition = {
            let view = ConditionView()
            view.btnCheck.tintColor = conditionTextColor
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
        setNewPasswordButton = {
            let button = UIButton()
            button.clipsToBounds = true
            button.layer.cornerRadius = 12.0
            button.titleLabel?.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
            button.backgroundColor = self.forceChangePassword ? Colors.navigationBarTitle : Colors.greenBackground
            button.setTitleColor(Colors.blueBackground, for: .normal)
            button.isEnabled = false
            button.addTarget(self, action: #selector(action_setNewPassword), for: .touchUpInside)
            return button
        }()
        
        [currentPasswordLabel, currentPasswordTF, newPasswordLabel,newPasswordTF, repeatPasswordLabel, repeatPasswordTF, showPsButton, textLabel, leftStack, rightStack,setNewPasswordButton].forEach({view.addSubview($0)})
        
        currentPasswordLabel.setupConstraints(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 30, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 25))
        currentPasswordTF.setupConstraints(top: currentPasswordLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 10, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 60))
        newPasswordLabel.setupConstraints(top: currentPasswordTF.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 30, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 25))
        newPasswordTF.setupConstraints(top: newPasswordLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 10, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 60))
        repeatPasswordLabel.setupConstraints(top: newPasswordTF.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 30, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 25))
        repeatPasswordTF.setupConstraints(top: repeatPasswordLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 10, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 60))
        showPsButton.setupConstraints(top: repeatPasswordTF.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 5, left: 20, bottom: 0, right: 20), size: .init(width: 200, height: 35))
        textLabel.setupConstraints(top: showPsButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 15, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 0))
        leftStack.setupConstraints(top: textLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, withPadding: .init(top: 20, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 110))
        leftStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2, constant: -25).isActive = true
        rightStack.setupConstraints(top: textLabel.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 20, left: 0, bottom: 0, right: 20), size: .init(width: 0, height: 70))
        rightStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2, constant: -5).isActive = true
        setNewPasswordButton.setupConstraints(top: leftStack.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 30, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 50))
        
    }
    
    @objc func dismissViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func backViewController() {
        self.goToMainScreen()
    }
    
    private func validatePsw() -> Bool {
        return upperCondition.isValid && lowerCondition.isValid && digitCondition.isValid && specialCondition.isValid && lenghtCondition.isValid
    }
    
    @objc func action_showPs() {
        self.repeatPasswordTF.isSecureTextEntry = !self.repeatPasswordTF.isSecureTextEntry
        self.newPasswordTF.isSecureTextEntry = !self.newPasswordTF.isSecureTextEntry
        self.currentPasswordTF.isSecureTextEntry = !self.currentPasswordTF.isSecureTextEntry
        self.showPsButton.setTitle(self.repeatPasswordTF.isSecureTextEntry ? cmsShowPsString:cmsHidePsString, for: .normal)
    }
    
    @objc func action_setNewPassword(){
        
        if newPasswordTF.text != repeatPasswordTF.text{
            newPasswordTF.showErrorMessage(message: cmsKPasswordDontMatch)
        }else{
            if validatePsw(){
                ACProgressHUD.shared.showHUD()
                OktaServices().changePassword(oldPassword: currentPasswordTF.text!, newPassword: newPasswordTF.text!) { result in
                    ACProgressHUD.shared.hideHUD()
                    switch result{
                    case .success( _):
                        self.moveToNextVC()
                    case .failure(let error):
                        if let networkErr = error as? NetworkError, networkErr == NetworkError.noInternet { return }
                        if let apiError = error as? APIError {
                            if apiError == APIError.password_too_recently {
                                self.repeatPasswordTF.showErrorMessage(message: self.cmsKPasswordTooRecentlyString)
                            } else if apiError == APIError.old_password_not_correct {
                                self.repeatPasswordTF.showErrorMessage(message: self.cmsKOldPasswordNotCorrectString)
                            }else if apiError == APIError.password_contains_part_email_fullName {
                                self.repeatPasswordTF.showErrorMessage(message: self.cmsKPasswordContainsPartEmailNameString)
                            }else {
                                self.repeatPasswordTF.showErrorMessage(message: apiError.localizedDescription)
                            }
                        }else {
                            self.repeatPasswordTF.showErrorMessage(message: APIError.password_contains_part_email_fullName.localizedDescription)
                        }
                    }
                }
            }else{
                repeatPasswordTF.showErrorMessage(message: cmsKPasswordNotMatchRequirements)
            }
        }
        
    }
    
    private func moveToNextVC(){
        if forceChangePassword {
            DispatchQueue.main.async { [weak self] in
                let newPasswordCreatedVC = NewPasswordCreatedViewController()
                newPasswordCreatedVC.forceChangePassword = true
                self?.navigationController?.pushViewController(newPasswordCreatedVC, animated: true)
            }
        }else {
            DispatchQueue.main.async { [weak self] in
                let newPasswordCreatedVC = NewPasswordCreatedViewController()
                newPasswordCreatedVC.isChangePassword = true
                self?.navigationController?.pushViewController(newPasswordCreatedVC, animated: true)
            }
        }
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.hideError()
        if let currentPasw = currentPasswordTF.text, !currentPasw.isEmpty, let newPsw = newPasswordTF.text, !newPsw.isEmpty, let repeatNewPsw = repeatPasswordTF.text, !repeatNewPsw.isEmpty {
            setNewPasswordButton.isEnabled = true
        } else {
            setNewPasswordButton.isEnabled = false
        }
        self.validateAndUpdateUI()
    }
    

    private func validateAndUpdateUI(){
        guard let pwdStr = newPasswordTF.text else {
            return
        }
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
