//
//  personalInfoViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//


import Foundation
import UIKit
import EasyTipView
import ACProgressHUD_Swift
import LocalAuthentication
import SafariServices
import FirebaseCrashlytics
let kConditionOktaName = "[A-Za-z0-9-À-ÖØ-öø-ÿœŒōūŪŌ_@#$%&.,!;:|{}?'\"() ,/+=\\u3000-\\u303F\\u3040-\\u309F\\u30A0-\\u30FF\\uFF00-\\uFFEF\\u4E00-\\u9FAF\\u2605-\\u2606\\u2190-\\u2195\\uac00-\\ud7a3\\u3040-\\u30ff\\u4e00-\\u9FFF\\u0080-\\u00FF\\u0100-\\u024F\\u1E00-\\u1EFF\\u0300-\\u036F\\u0980-\\u09FF\\u0900-\\u097F\\u0400-\\u04FF\\u0D80-\\u0DFF\\u1000-\\u109F\\u0600-\\u06FF\\u0E00-\\u0E7F\\u203B\\u2e80-\\u2FD5\\u3220-\\u337F\\u31f0\\u314B-\\u337F]*$"
class personalInfoViewController: BaseWithBlurViewController{
   
    private var personalInfoLabel: UILabel!
    private var firstNameTF: UITextField!
    private var lastNameTF: UITextField!
    private var dropDownView: UIView!
    private var mobileNumberTF: UITextField!
    private var biometricsLabel: UILabel!
    private var infoButton: UIButton!
    private var biometriSwitch: UISwitch!
    private var createAccountButton: UIButton!
    private var flagImageView: UIImageView!
    private var mobileCodeLabel: UILabel!
    private var dropDownButton: UIButton!
    private var termsLabel: UILabel!
    private var isTipActive = false
    private var tipView: EasyTipView!
    private var tipViewPreferences: EasyTipView.Preferences!
    private lazy var laContext = LAContext()
    
    var currentCountry: CountryDetail?
    var ary_countryDetails: Array<CountryDetail> = []
    
    override func viewDidLoad() {
        self.kenticoCodeName = "app___registration"
        self.kenticoDepth = 3
        super.viewDidLoad()
        self.getCountryList()
        setDataFromPMAProfile()
        let gesture = UITapGestureRecognizer(target: self, action: #selector (touchAnywhere))
        self.view.addGestureRecognizer(gesture)
        self.firstNameTF.becomeFirstResponder()
    }
    
    private func getCountryList(){
        ACProgressHUD.shared.showHUD()
        AspireServices().getCountryList {[weak self] result in
            ACProgressHUD.shared.hideHUD()
            switch result{
            case .success(let response):
                self?.ary_countryDetails = response
                self?.setDefaultCountryData()
            case .failure(let error):
                Crashlytics.crashlytics().record(error: error)
                print(error.localizedDescription)
            }
        }
    }
    
    override func setNavBarItems(){
        super.setNavBarItems()
        createBackBarButton()
        createRightBarButtonWithTitle(title: "3/3")
    }

    
  
    @objc func touchAnywhere(){
        self.view.endEditing(true)
        if isTipActive{
            tipView.dismiss()
            isTipActive = false
        }
    }
    
    var cmsRegisterString = "Register"
    var cmsPersonalInfoString = "Personal Info"
    var cmsFirstNameString = "First Name"
    var cmsLastNameString = "Last Name"
    var cmsMobilePhoneString = "Mobile Phone"
    var cmsUseBiometricString = "Use Biometrics"
    var cmsCreateAccountString = "Create Account"
    var cmsTermAndPrivacyString  = "By proceeding, you agree to the {Terms of Use} and {Privacy Policy} "
    var cmsKErrorMobileNumber = "Please enter the phone number less than 19 characters."
    var cmsKEnterAllFields = "The form has not been completed. Please fill in all fields to continue."
    var cmsBiometricTipString = "Face ID, or facial recognition system, will let you log in to the app fast and securely"
    var cmsSetupBiometricString = "Please setup Biometric in your device"
    var cmsCancelString = "Cancel"
    var cmsSettingString = "Settings"
    var cmsTheNameIncorrect = ""
    var cmsPasswordIncludesName = ""
    var cmsCreateAccountError = ""
    
    override func setText() {
        super.setText()
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app___registration_personal_info.elements.title.value") as? String{
            cmsRegisterString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app___registration_personal_info.elements.description.value") as? String{
            cmsPersonalInfoString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app___first_name.elements.watermark_message.value") as? String{
            cmsFirstNameString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app___last_name.elements.watermark_message.value") as? String{
            cmsLastNameString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app___phone_number.elements.watermark_message.value") as? String{
            cmsMobilePhoneString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app___biometrics.elements.label.value") as? String{
            cmsUseBiometricString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app___registration_personal_info.elements.cta_text1.value") as? String{
            cmsCreateAccountString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app___term_and_privacy.elements.watermark_message.value") as? String{
            cmsTermAndPrivacyString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app___phone_number_too_long_error_message.elements.description.value") as? String{
            cmsKErrorMobileNumber = str
        }
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app_profile_required_field_error_message.elements.description.value") as? String{
            cmsKEnterAllFields = str
        }
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app___biometrics.elements.additional_information.value") as? String{
            cmsBiometricTipString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app___biometric_setting_message.elements.description.value") as? String{
            cmsSetupBiometricString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app___biometric_setting_message.elements.cta_text2.value") as? String{
            cmsSettingString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app___biometric_setting_message.elements.cta_text1.value") as? String{
            cmsCancelString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app___the_name_field_is_incorrect.elements.description.value") as? String{
            cmsTheNameIncorrect = str
        }
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app___the_first_name_and_last_name.elements.description.value") as? String{
            cmsPasswordIncludesName = str
        }
        if let str = KenticoServices.getKenticoValue(dict: kenticoDic, path: "modular_content.app___program_error_message.elements.description.value") as? String{
            cmsCreateAccountError = str
        }

        title = cmsRegisterString
        personalInfoLabel.text = cmsPersonalInfoString
        biometricsLabel.text = cmsUseBiometricString
        firstNameTF.attributedPlaceholder = cmsFirstNameString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
        lastNameTF.attributedPlaceholder = cmsLastNameString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
        mobileNumberTF.attributedPlaceholder = cmsMobilePhoneString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
        createAccountButton.setTitle(cmsCreateAccountString, for: .normal)
        termsLabel.attributedText = self.generateTermAndPrivacyAttributeString()
    }
    
    override func setupUI() {
        super.setupUI()
        title = cmsRegisterString
        personalInfoLabel = {
            let label = UILabel()
            label.text = cmsPersonalInfoString
            label.font = UIFont(name: Fonts.regularFont, size: Sizes.titleGreeting)
            label.textColor = Colors.navigationBarTitle
            return label
        }()
        
        firstNameTF = {
            let textField = UITextField()
            textField.setCommonStyle()
            textField.attributedPlaceholder = cmsFirstNameString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
            textField.addBorderWithDarkAtBottom(color: Colors.navigationBarTitle)
            textField.clearButtonMode = .whileEditing
            textField.tintColor = Colors.placeholderTextColor
            textField.returnKeyType = .done
            textField.delegate = self
            textField.accessibilityIdentifier = "firstNameField"
            return textField
        }()
    
        lastNameTF = {
            let textField = UITextField()
            textField.setCommonStyle()
            textField.attributedPlaceholder = cmsLastNameString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
            textField.addBorderWithDarkAtBottom(color: Colors.navigationBarTitle)
            textField.clearButtonMode = .whileEditing
            textField.tintColor = Colors.placeholderTextColor
            textField.returnKeyType = .done
            textField.delegate = self
            textField.accessibilityIdentifier = "lastNameField"
            return textField
        }()
        
        dropDownView = {
            let view = UIView()
            view.addBorderWithDarkAtBottom(color: Colors.navigationBarTitle)
            return view
        }()
        
        flagImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(systemName: "photo")
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
            imgView.tintColor = Colors.placeholderTextColor
            return imgView
        }()
        
        mobileCodeLabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
            label.text = ""
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
        
        dropDownButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            button.tintColor = .white
            button.addTarget(self, action: #selector(presentCountryListView), for: .touchUpInside)
            return button
        }()
        
        mobileNumberTF = {
            let textField = UITextField()
            textField.setCommonStyle()
            textField.attributedPlaceholder = cmsMobilePhoneString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
            textField.addBorderWithDarkAtBottom(color: Colors.navigationBarTitle)
            textField.clearButtonMode = .whileEditing
            textField.tintColor = Colors.placeholderTextColor
            textField.delegate = self
            textField.keyboardType = .numberPad
            textField.returnKeyType = .done
            textField.accessibilityIdentifier = "mobileField"
            return textField
        }()
        
        biometricsLabel = {
            let label = UILabel()
            label.text = cmsUseBiometricString
            label.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
            label.adjustsFontSizeToFitWidth = true
            label.textColor = Colors.placeholderTextColor
            return label
        }()
        
        infoButton = {
            let infoButton = UIButton()
            infoButton.setImage(UIImage(named: "ic_info"), for: .normal)
            infoButton.contentVerticalAlignment = .fill
            infoButton.contentHorizontalAlignment = .fill
            infoButton.tintColor = .white
            infoButton.addTarget(self, action: #selector(showToolTipView), for: .touchUpInside)
            return infoButton
        }()
        
        biometriSwitch = {
            let bioSwitch = UISwitch()
            bioSwitch.isOn = false
            bioSwitch.addTarget(self, action: #selector(biometricAction), for: .valueChanged)
            return bioSwitch
        }()
        
        createAccountButton = {
            let button = UIButton()
            button.setTitle(cmsCreateAccountString, for: .normal)
            button.setCommonButtonStyle()
            button.addTarget(self, action: #selector(createCustomerAccount), for: .touchUpInside)
            return button
        }()
        
        termsLabel = {
            let label = UILabel()
            label.backgroundColor = .clear
            label.isUserInteractionEnabled = true
            label.textColor = Colors.navigationBarButtonItemTitle
            label.numberOfLines = 2
            label.font = UIFont(name: Fonts.regularFont, size: Sizes.headerText)
            label.attributedText = self.generateTermAndPrivacyAttributeString()
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tappedOnTermsPrivacy(_:)))
            tapGesture.numberOfTouchesRequired = 1
            label.addGestureRecognizer(tapGesture)
            label.accessibilityIdentifier = "TermsPolicyLabel"
            return label
        }()
        
        [personalInfoLabel, firstNameTF,lastNameTF, dropDownView, mobileNumberTF, biometricsLabel, infoButton, biometriSwitch, createAccountButton, termsLabel].forEach({view.addSubview($0)})
        //Adding Constraints to UI Components.
        personalInfoLabel.setupConstraints(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 130, left: 25, bottom: 2, right: 25), size: .init(width: 0, height: 70))
        firstNameTF.setupConstraints(top: personalInfoLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 20, left: 25, bottom: 2, right: 25), size: .init(width: 0, height: 60*SCREEN_HEIGHT_SCALE))
        lastNameTF.setupConstraints(top: firstNameTF.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 25, left: 25, bottom: 2, right: 25), size: .init(width: 0, height: 60*SCREEN_HEIGHT_SCALE))
        dropDownView.setupConstraints(top: lastNameTF.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, withPadding: .init(top: 25, left: 25, bottom: 2, right: 10), size: .init(width: 120, height: 60*SCREEN_HEIGHT_SCALE))
        mobileNumberTF.setupConstraints(top: lastNameTF.bottomAnchor, leading: dropDownView.trailingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 25, left: 10, bottom: 2, right: 25), size: .init(width: 0, height: 60*SCREEN_HEIGHT_SCALE))
        biometricsLabel.setupConstraints(top: dropDownView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, withPadding: .init(top: 25, left: 25, bottom: 2, right: 10), size: .init(width: 0, height: 40))
//        biometricsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        infoButton.setupConstraints(top: nil, leading: biometricsLabel.trailingAnchor, bottom: nil, trailing: nil, withPadding: .init(top: 0, left: 10, bottom: 2, right: 10), size: .init(width: 24, height: 24))
        infoButton.centerYAnchor.constraint(equalTo: biometricsLabel.centerYAnchor).isActive = true
        biometriSwitch.setupConstraints(top: nil, leading: nil, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 0, left: 10, bottom: 2, right: 40), size: .init(width: 50, height: 0))
        biometriSwitch.centerYAnchor.constraint(equalTo: biometricsLabel.centerYAnchor).isActive = true
        createAccountButton.setupConstraints(top: biometricsLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 35, left: 25, bottom: 2, right: 25), size: .init(width: 0, height: 60*SCREEN_HEIGHT_SCALE))
        termsLabel.setupConstraints(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, withPadding: .init(top: 2, left: 25, bottom: 30, right: 25), size: .init(width: 0, height: 60))
        
        [flagImageView, mobileCodeLabel, dropDownButton].forEach({dropDownView.addSubview($0)})
        flagImageView.setupConstraints(top: nil, leading: dropDownView.leadingAnchor, bottom: nil, trailing: nil, withPadding: .init(top: 10, left: 10, bottom: 10, right: 5), size: .init(width: 25, height: 20))
        flagImageView.centerYAnchor.constraint(equalTo: dropDownView.centerYAnchor).isActive = true
        dropDownButton.setupConstraints(top: nil, leading: nil, bottom: nil, trailing: dropDownView.trailingAnchor, withPadding: .init(top: 10, left: 5, bottom: 10, right: 5), size: .init(width: 30, height: 20))
        dropDownButton.centerYAnchor.constraint(equalTo: dropDownView.centerYAnchor).isActive = true
        mobileCodeLabel.setupConstraints(top: nil, leading: flagImageView.trailingAnchor, bottom: nil, trailing: dropDownButton.leadingAnchor, withPadding: .init(top: 10, left: 5, bottom: 10, right: 5), size: .init(width: 0, height: 30))
        mobileCodeLabel.centerYAnchor.constraint(equalTo: dropDownView.centerYAnchor).isActive = true
        
        tipViewPreferences = EasyTipView.Preferences()
        tipViewPreferences.drawing.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText) ?? UIFont.systemFont(ofSize: Sizes.titleText)
        tipViewPreferences.drawing.foregroundColor = UIColor(named: "textColor")!
        tipViewPreferences.drawing.backgroundColor = UIColor.white
        tipViewPreferences.drawing.arrowPosition = .bottom
        
        biometriSwitch.layer.cornerRadius = 16.0
        biometriSwitch.layer.borderWidth = 1.0
        biometriSwitch.layer.borderColor = Colors.secondPlacholderText.cgColor
    }
    
    private func generateTermAndPrivacyAttributeString() -> NSAttributedString{
        if cmsTermAndPrivacyString.isEmpty {
            return NSAttributedString()
        }
        let termString = cmsTermAndPrivacyString.slice(from: "{", to: "}") ?? "Terms of Use"
        let temString = cmsTermAndPrivacyString.replacingOccurrences(of: "{\(termString)}", with: "")
        let privaceString = temString.slice(from: "{", to: "}") ?? "Privacy Policy"
        let attributedText = NSMutableAttributedString(string: cmsTermAndPrivacyString.withReplacedCharacters("{", by: "").withReplacedCharacters("}", by: ""))
        let termsRange = attributedText.mutableString.range(of: termString)
        let privacyRange = attributedText.mutableString.range(of: privaceString)
        attributedText.addAttribute(.underlineStyle, value: 1, range: termsRange)
        attributedText.addAttribute(.font, value: UIFont(name: Fonts.boldFont, size: Sizes.headerText) ?? UIFont.systemFont(ofSize: Sizes.headerText), range: termsRange)
        attributedText.addAttribute(.underlineStyle, value: 1, range: privacyRange)
        attributedText.addAttribute(.font, value: UIFont(name: Fonts.boldFont, size: Sizes.headerText) ?? UIFont.systemFont(ofSize: Sizes.headerText), range: privacyRange)
        return attributedText
    }
    
    private func setDataFromPMAProfile() {
        if let pmaProfile = CurrentSession.share.pmaProfile {
            if let fname = pmaProfile.firstName {
                firstNameTF.text = fname
            }
            if let lname = pmaProfile.lastName{
                lastNameTF.text = lname
            }
            if  let phone = pmaProfile.phoneNumber {
                mobileNumberTF.text = phone
            }
        }
    }
    
    private func setDefaultCountryData() {
        var defaultCountry:CountryDetail?
        if let phoneCountryCode = CurrentSession.share.pmaProfile?.phoneCountryCode {
            let defaultCountries = ary_countryDetails.filter { (country) -> Bool in
                return country.phoneCode == phoneCountryCode
            }
            defaultCountry = defaultCountries.first
        } else {
            if let programInfoCountryCode = CurrentSession.share.programDetail?.country {
                let countriesFromPrograms = ary_countryDetails.filter { (country) -> Bool in
                    return country.alpha3Code == programInfoCountryCode
                }
                defaultCountry = countriesFromPrograms.first
            }
        }
        if let country = defaultCountry {
            updateCountryDetails(CountryDetail: country)
        } else if let firstCountry = ary_countryDetails.first{
            updateCountryDetails(CountryDetail: firstCountry)
        }
    }
    
    @objc func biometricAction(){
        if isTipActive{
            tipView.dismiss()
        }
        if biometriSwitch.isOn{
            BiometricManager.shared.canEvaluatePolicy { result in
                switch result{
                case .success( _):
                    BiometricManager.shared.setIsEnabledBiometric(isEnable: true)
                case .failure(  _):
                    let alertController = UIAlertController(title: nil, message: self.cmsSetupBiometricString, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: self.cmsCancelString, style: .cancel) { action in
                        self.biometriSwitch.isOn = false }
                    let settingsAction = UIAlertAction(title: self.cmsSettingString, style: .default) { action in
                        self.biometriSwitch.isOn = false
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url, options: [:])
                        }
                    }
                    cancelAction.accessibilityIdentifier = "Biometric Cancel"
                    settingsAction.accessibilityIdentifier = "Biometric Open Settings"
                    alertController.addAction(cancelAction)
                    alertController.addAction(settingsAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }else{
            BiometricManager.shared.setIsEnabledBiometric(isEnable: false)
        }
    }
    
    @objc func showToolTipView(){
        if !isTipActive {
            let tipText = cmsBiometricTipString
            DispatchQueue.main.async {
                self.tipView = EasyTipView(text: tipText, preferences: self.tipViewPreferences)
                self.tipView.accessibilityIdentifier = "TipView"
                self.tipView.show(forView: self.infoButton, withinSuperview: self.view)
                self.isTipActive = true
            }
        }else{
            tipView.dismiss()
            isTipActive = false
        }
        
    }
    
    @objc func presentCountryListView(){
        let countrytListVC = CountryListViewController(countries: ary_countryDetails)
        countrytListVC.delegate = self
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.present(countrytListVC, animated: true, completion: nil)
        }
    }
    
    @objc func createCustomerAccount(){
        self.view.endEditing(true)
        if let fname = firstNameTF.text?.trim(), !fname.isEmpty, let lname = lastNameTF.text?.trim(), !lname.isEmpty, let mobile = mobileNumberTF.text?.trim(), !mobile.isEmpty{
            let specialCondPredic = NSPredicate(format: "SELF MATCHES %@", kConditionOktaName)
            if !specialCondPredic.evaluate(with: fname) {
                self.firstNameTF.showErrorMessage(message: cmsTheNameIncorrect)
                return
            }
            if !specialCondPredic.evaluate(with: lname) {
                self.lastNameTF.showErrorMessage(message: cmsTheNameIncorrect)
                return
            }
            
            firstNameTF.hideError()
            createCustomer()
        }else{
            self.firstNameTF.showErrorMessage(message: cmsKEnterAllFields, rightButtonTitle: nil, rightButtonAction: nil)
        }
    }
    
    func createCustomer(){
        if mobileNumberTF.text!.count > AppContants.phoneNumberLengLimit{
            mobileNumberTF.showErrorMessage(message: cmsKErrorMobileNumber)
            return
        }
        guard let email = RegisterData.share.emailAES?.aesDecrypt(), let password = RegisterData.share.pswAES?.aesDecrypt(), let accesscode = RegisterData.share.accessCodeAES?.aesDecrypt() else {
            return
        }
        
        let  appUserPreferences = NSMutableArray()
        appUserPreferences.add([
            "preferenceKey": languageSelectedAppUserPreferencesKey,
            "preferenceValue": CurrentSession.share.currentLanguage
        ])
        if let temperature = CurrentSession.share.programDetail?.getTemperatureUnit() {
            appUserPreferences.add([
                "preferenceKey": TemperatureSelectedAppUserPreferencesKey,
                "preferenceValue": temperature
            ])
        }
        if let distanceUnit = CurrentSession.share.programDetail?.getDistanceUnit(){
            var distanceU = DistanceUnit.Mi.stringValue
            if distanceUnit.lowercased() == DistanceUnit.Km.stringValue {
                distanceU = DistanceUnit.Km.stringValue
            }
            appUserPreferences.add([
                "preferenceKey": DistanceUnitSelectedAppUserPreferencesKey,
                "preferenceValue": distanceU
            ])
        }
        
        
        let profileDic = [
            "account": [
                "username": NetworkConstants.organizationString + "_" + email,
                "password": password,
                "email": email,
                "activate": true
            ],
            "profile": [
                "localeId": CurrentSession.share.currentLanguage,
                "firstName": firstNameTF.text!.trim(),
                "lastName": lastNameTF.text!.trim(),
                "residentCountry": currentCountry!.alpha3Code!,
                "homeCountry": currentCountry!.alpha3Code!,
                "emails": [
                    [
                        "emailType": "Primary",
                        "emailAddress": email
                    ]
                ],
                "phones": [
                    [
                        "phoneType": "Mobile",
                        "phoneCountryCode": currentCountry!.phoneCode,
                        "phoneAreaCode": "",
                        "phoneNumber": mobileNumberTF.text!.trim(),
                        "phoneExtension": ""
                    ]
                ],
                "memberships": [
                    [
                        "membershipCategory": "Digital Program Code",
                        "referenceName": "",
                        "referenceNumber": accesscode,
                        "externalReferenceNumber": "",
                        "uniqueIdentifier": "",
                        "program": NetworkConstants.programName
                    ]
                ],
                "preferences": [],
                "appUserPreferences": appUserPreferences,
                "partyVerifications": [
                    [
                        "verificationKey": "accessCode",
                        "verificationValue": accesscode
                    ]
                ]
            ],
            "verificationMetadata": [
                "bin": accesscode
            ]
        ]
        ACProgressHUD.shared.showHUD()
        AzureServices().createAccount(profileDict: profileDic) { [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let response):
                if response.message.contains("User account already exists") {
                    ACProgressHUD.shared.hideHUD()
                    self.firstNameTF.showErrorMessage(message: self.cmsPasswordIncludesName)
                }else {
                    let partyID = response.partyID
                    AzureServices().loginWith(username: email, psw: password) { results in
                        if let pID = CurrentSession.share.aspireProfile?.partyID, pID.isEmpty {
                            CurrentSession.share.aspireProfile?.partyID = partyID
                        }
                        CurrentSession.share.firstLogin = true
                        ACProgressHUD.shared.hideHUD()
                        print(response.message)
                        self.pushToVerifyEmailVC()
                    }
                }
            case.failure(let error):
                ACProgressHUD.shared.hideHUD()
                Crashlytics.crashlytics().record(error: error)
                if let phonN = CurrentSession.share.programDetail?.phoneNumber {
                    var message = self.cmsCreateAccountError
                    let phonenumberStr = message.slice(from: "{", to: "}") ?? "program phone number"
                    message = message.withReplacedCharacters("{\(phonenumberStr)}", by: phonN)
                    let mutableAttributeStr = NSMutableAttributedString(attributedString: message.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.headerText, color: Colors.navigationBarTitle, lineSpacing: 0))
                    let range = mutableAttributeStr.mutableString.range(of: phonN)
                    mutableAttributeStr.addAttribute(.underlineStyle, value: 1, range: range)
                    mutableAttributeStr.addAttribute(.font, value: UIFont(name: Fonts.mediumFont, size: Sizes.headerText) ?? UIFont.systemFont(ofSize: Sizes.headerText) , range: range)
                    self.firstNameTF.showErrorMessageWithAttributeString(attString: mutableAttributeStr) {
                        UtilServices.shared.callToPhoneNumber(phoneNumber: phonN)
                    }
                }
                print(error.localizedDescription)
            }
        }
        
    }
    
    func pushToVerifyEmailVC(){
       DispatchQueue.main.async { [weak self] in
           let vc = VerifyViaEmailViewController(flow: .registrationFlow)
           self?.navigationController?.pushViewController(vc, animated: true)
       }
   }
    
    
}

extension personalInfoViewController: countryDetailDelegate{
    
    func updateCountryDetails(CountryDetail: CountryDetail) {
        self.currentCountry = CountryDetail
        let imageURL = URL(string: CountryDetail.flag!)
        DispatchQueue.main.async { [weak self] in
            self?.flagImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "photo"))
            self?.mobileCodeLabel.text = CountryDetail.phoneCode
        }
        
    }
    
}

extension personalInfoViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if isTipActive{
            tipView.dismiss()
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        firstNameTF.hideError()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == mobileNumberTF{
            let text = textField.text
            let newLength = text!.count + string.count - range.length
            if newLength <= AppContants.phoneNumberLengLimit{
                textField.hideError()
                return true
            }else{
                textField.showErrorMessage(message: cmsKErrorMobileNumber)
                return true
            }
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.hideError()
        return true
    }
}

extension personalInfoViewController{
    
    @objc func tappedOnTermsPrivacy(_ gesture: UITapGestureRecognizer) {
            guard let text = termsLabel.text else { return }
        let termString = cmsTermAndPrivacyString.slice(from: "{", to: "}") ?? "Terms of Use"
        let temString = cmsTermAndPrivacyString.replacingOccurrences(of: "{\(termString)}", with: "")
        let privaceString = temString.slice(from: "{", to: "}") ?? "Privacy Policy"
            let termsRange = (text as NSString).range(of: termString)
            let PrivacyRange = (text as NSString).range(of: privaceString)
            if gesture.didTapAttributedTextInLabel(label: self.termsLabel, inRange: termsRange) {
                pushToWebViewController(type: .termsOfUse)
            } else if gesture.didTapAttributedTextInLabel(label: self.termsLabel, inRange: PrivacyRange) {
                pushToWebViewController(type: .privacyPolicy)
            }
        }
    
    private func pushToWebViewController(type: contentType){
        DispatchQueue.main.async { [weak self] in
            let webVC = WebViewController(type: type, forRregistrationFlow: true)
            webVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(webVC, animated: true)
        }
    }
}

extension personalInfoViewController : EasyTipViewDelegate{
    func easyTipViewDidTap(_ tipView: EasyTipView) {
        print("did tap")
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        print("did dismiss")
    }
    
    
}

