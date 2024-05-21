//
//  CreatePasswordViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//


import Foundation
import UIKit


let  kConditionOneDigit = ".*[0-9]+.*"
let  kConditionOneLowcase = ".*[a-z]+.*"
let  kConditionOneUppercase = ".*[A-Z]+.*"
let  kConditionOneSpecialCharater = ".*[\"!#$%&'()*+,-./\\:;<=>?@\\[\\\\\\]^`{|}~]+.*"
let  kMinLengthOfPsw = 12
class CreatePasswordViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet private var bg: UIImageView!
    @IBOutlet private var lblDes: UILabel!
    @IBOutlet private var tfPD: UITextField!
    @IBOutlet private var showPsButton: UIButton!
    @IBOutlet private var tfBorderView: UIView!
    @IBOutlet private var btnNext: UIButton!
    @IBOutlet private var lblSubDes: UILabel!
    //List Condition
    @IBOutlet private var upperCond: ConditionItemView!
    @IBOutlet private var lowerCond: ConditionItemView!
    @IBOutlet private var digitCond: ConditionItemView!
    @IBOutlet private var specialCond: ConditionItemView!
    @IBOutlet private var lenghtCond: ConditionItemView!
    // CMS String
    var cmsRegisterString = "Register"
    var cmsCreatePasswordString = "Create a\npassword"
    var cmsDoNotUseFirstLastNameString = "Please do not use your first or last name in a password"
    var cmsPasswordString = "Password"
    var cmsUpperCondString = "Uppercase"
    var cmsLowerCondString = "Lowercase"
    var cmsDigitCondString = "Digit"
    var cmsSpecialCondString = "Special character"
    var cmsLenghtCondString = "At least 10 characters long"
    var cmsKErrorEmptyPassword = "Please provide a password."
    var cmsKErrorInvalidPassword = "Please provide a password that matches all requirement described above."
    var cmsShowPsString = "Show Password"
    var cmsHidePsString = "Hide Pasword"
    
    override func viewDidLoad() {
        self.kenticoCodeName = "app___registration"
        self.kenticoDepth = 3
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        self.createBackBarButton()
        self.createRightBarButtonWithTitle(title: "2/3")
        self.tfBorderView.addBorderWithDarkAtBottom(color: Colors.navigationBarTitle)
        self.bg.addBlur(blurStyle: .systemChromeMaterialDark)
        self.tfPD.setCommonStyle()
        
        self.showPsButton.backgroundColor = Colors.clear
        self.showPsButton.setTitleColor(Colors.navigationBarButtonItemTitle, for: .normal)
        self.showPsButton.titleLabel?.font = UIFont(name: Fonts.regularFont, size: Sizes.headerText)
        
        self.btnNext.setImage(UIImage(named: "btn_next_white"), for: .normal)
        self.btnNext.setImage(UIImage(named: "btn_next_disabled"), for: .disabled)
        self.btnNext.setImage(UIImage(named: "btn_next_disabled"), for: .highlighted)
        upperCond.isValid = false
        lowerCond.isValid = false
        digitCond.isValid = false
        specialCond.isValid = false
        lenghtCond.isValid = false
        
    }
    
    override func setText() {
        super.setText()
        if let registerString = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app_create_password.elements.title.value") as? String {
            cmsRegisterString = registerString
        }
        if let createPasswordString = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app_create_password.elements.description.value") as? String {
            cmsCreatePasswordString = createPasswordString
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___password_requirement.elements.watermark_message.value") as? String {
            cmsDoNotUseFirstLastNameString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___password_requirement.elements.watermark_message.value") as? String {
            cmsDoNotUseFirstLastNameString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___new_password.elements.watermark_message.value") as? String {
            cmsPasswordString = str
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
            cmsKErrorInvalidPassword = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app_create_password.elements.cta_text3.value") as? String {
               cmsShowPsString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app_create_password.elements.cta_text4.value") as? String {
               cmsHidePsString = str
        }

        self.title = cmsRegisterString
        self.lblDes.attributedText = cmsCreatePasswordString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleGreeting, color: Colors.navigationBarTitle, lineSpacing: 0)
        self.lblSubDes.attributedText = cmsDoNotUseFirstLastNameString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.headerText, color: Colors.navigationBarButtonItemTitle, lineSpacing: 0)
        self.tfPD.attributedPlaceholder = cmsPasswordString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
        self.showPsButton.setTitle(cmsShowPsString, for: .normal)
        upperCond.title = cmsUpperCondString
        lowerCond.title = cmsLowerCondString
        digitCond.title = cmsDigitCondString
        specialCond.title = cmsSpecialCondString
        lenghtCond.title = cmsLenghtCondString
    }
    
    
    // MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func textfieldDidChange(sender:UITextField) {
        sender.hideError()
        self.validateAndUpdateUI()
    }
    
    @IBAction func action_showPs(sender: UIButton) {
        self.tfPD.isSecureTextEntry = !self.tfPD.isSecureTextEntry
        self.showPsButton.setTitle(self.tfPD.isSecureTextEntry ? cmsShowPsString:cmsHidePsString, for: .normal)
    }
    
    @IBAction private func goNextStep(sender:UIButton) {
        guard let ps = self.tfPD.text, !ps.isEmpty else {
            self.tfPD.showErrorMessage(message: cmsKErrorEmptyPassword)
            return
        }
        
        if validatePsw() {
            if let str = self.tfPD.text {
                RegisterData.share.pswAES = str.aesEncrypt()
            }
            let personalInfoScreen = personalInfoViewController()
            self.navigationController?.pushViewController(personalInfoScreen, animated: true)
//            FirebaseTracking.share.logEvent(event: FirebaseEvent.registration_step3_password, viewController: self, parameter: ["registration_stage": "password_creation_success", "failure_reason": ""])
        } else {
            self.tfPD.showErrorMessage(message: cmsKErrorInvalidPassword)
//            FirebaseTracking.share.logEvent(event: FirebaseEvent.registration_step3_password, viewController: self, parameter: ["registration_stage": "password_creation_failure", "failure_reason": "invalid password forma"])
        }
    }
    
    private func validatePsw() -> Bool {
        return self.upperCond.isValid && self.lowerCond.isValid && self.digitCond.isValid && self.specialCond.isValid && self.lenghtCond.isValid
    }
    
    private func validateAndUpdateUI(){
        guard let pwdStr = self.tfPD.text else {
            return
        }
        self.lenghtCond.isValid = (pwdStr.count >= kMinLengthOfPsw)
        
        let lowerCondPredic = NSPredicate(format: "SELF MATCHES %@", kConditionOneLowcase)
        self.lowerCond.isValid = lowerCondPredic.evaluate(with: pwdStr)
        
        let upperCondPredic = NSPredicate(format: "SELF MATCHES %@", kConditionOneUppercase)
        self.upperCond.isValid = upperCondPredic.evaluate(with: pwdStr)
        
        let digitCondPredic = NSPredicate(format: "SELF MATCHES %@", kConditionOneDigit)
        self.digitCond.isValid = digitCondPredic.evaluate(with: pwdStr)
        
        let specialCondPredic = NSPredicate(format: "SELF MATCHES %@", kConditionOneSpecialCharater)
        self.specialCond.isValid = specialCondPredic.evaluate(with: pwdStr)
    }
}

class ConditionItemView: UIView {
    
    @IBOutlet private var btnCheck:UIButton!
    @IBOutlet private var lblTitle:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnCheck.setImage(UIImage(named: "check_normal"), for: .normal)
        self.btnCheck.setImage(UIImage(named: "check_active"), for: .selected)
    }

    var title:String = "" {
        didSet{
            self.lblTitle.attributedText = title.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.headerText, color: Colors.navigationBarButtonItemTitle, lineSpacing: 0)
        }
    }
    
    var isValid:Bool{
        set{
            btnCheck.isSelected = newValue
        }
        get{
            return btnCheck.isSelected
        }
    }
}
