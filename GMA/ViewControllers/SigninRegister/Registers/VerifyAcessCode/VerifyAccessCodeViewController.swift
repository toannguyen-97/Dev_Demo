//
//  VerifyAccessCodeViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//


import UIKit
import ACProgressHUD_Swift
import FirebaseCrashlytics

class VerifyAccessCodeViewController: BaseViewController, UITextFieldDelegate {
    var isUpdateAccessCode = false
    var numberFailRequest = 0
    
    @IBOutlet private weak var lblAccesscode :UILabel!
    @IBOutlet private weak var tfBorderView :UIView!
    @IBOutlet private weak var tfAC : UITextField!
    @IBOutlet private weak var btnSubmit :UIButton!
    @IBOutlet private weak var lblHaveAccount :UILabel!
    @IBOutlet private weak var btnSignin : UIButton!
    @IBOutlet private weak var btnWhatCanDo :UIButton!
    @IBOutlet private weak var bottomSafeView :UIView!
    // CMS String
    

    var cmsLanguageString = ""
    var cmsAccessCodeString =  ""
    var cmsEnterAccessCodeString = ""
    var cmsSubmitString = ""
    var cmsAlreadyHaveAccountString = ""
    var cmsSigninString = ""
    var cmsSeeWhatWeCanDoString = ""
    var cmsKErrorAccessCodeInvalid = ""
    var cmsKErrorConfirmAccessCode = ""
    var cmsKErrorEmptyAccessCode =  ""
    
    override func viewDidLoad() {
        self.kenticoCodeName = "app___registration"
        self.kenticoDepth = 3
        self.navigationItem.setHidesBackButton(true, animated: false)
        super.viewDidLoad()
        if isUpdateAccessCode {
            self.createBackBarButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.numberFailRequest = 0
    }
    
    override func setupUI() {
        super.setupUI()
        self.createRightBarButtonWithTitle(title: cmsLanguageString)
        self.btnSignin.addBlur(blurStyle: .systemUltraThinMaterialLight)
        self.tfBorderView.addBlur(blurStyle: .systemUltraThinMaterialDark)
        self.tfBorderView.alpha = 0.9
        if self.view.safeAreaInsets.bottom > 0 {
            self.btnWhatCanDo.titleEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 8, right: -15)
        }
        self.lblHaveAccount.textAlignment = .center
        self.tfAC.keyboardDistanceFromTextField = self.btnSubmit.frame.size.height + 20
        self.tfBorderView.addBorderWithDarkAtBottom(color: Colors.navigationBarTitle)
        self.btnWhatCanDo.titleLabel?.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        self.btnWhatCanDo.backgroundColor =  Colors.blueBackground
        self.bottomSafeView.backgroundColor = Colors.blueBackground
        
        self.tfAC.setCommonStyle()
        self.btnSubmit.setCommonStyle()
        self.btnSignin.setTranparentStyle()
    }
    
    override func setText() {
        super.setText()
        if let tileStr = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___access_code.elements.label.value") as? String {
            cmsAccessCodeString = tileStr
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___registration_access_code.elements.description.value") as? String {
            cmsAlreadyHaveAccountString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___access_code.elements.watermark_message.value") as? String {
            cmsEnterAccessCodeString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___registration_access_code.elements.cta_text1.value") as? String {
            cmsSubmitString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___registration_access_code.elements.cta_text2.value") as? String {
            cmsSigninString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___registration_access_code.elements.cta_text3.value") as? String {
            cmsSeeWhatWeCanDoString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___invalid_access_code.elements.description.value") as? String {
            self.cmsKErrorAccessCodeInvalid = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___invalid_access_code__4_times_.elements.description.value") as? String {
            self.cmsKErrorConfirmAccessCode = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___required_field_error_message.elements.description.value") as? String {
            self.cmsKErrorEmptyAccessCode = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___registration_access_code.elements.cta_text4.value") as? String {
            self.cmsLanguageString = str
        }
        
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___no_internet_connection_popup.elements.title.value") as? String {
            AppContants.shared.cmsNoInternetTitleSystemString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___no_internet_connection_popup.elements.description.value") as? String {
            AppContants.shared.cmsNoInternetMessageSystemString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___no_internet_connection_popup.elements.cta_text1.value") as? String {
            AppContants.shared.cmsOkSystemString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___no_internet_connection_popup.elements.cta_text2.value") as? String {
            AppContants.shared.cmsSettingSystemString = str
        }
        
        self.btnRightItem?.setTitle(cmsLanguageString, for: .normal)
        self.btnRightItem?.sizeToFit()
        self.lblAccesscode.attributedText = cmsAccessCodeString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.descriptionText, color: Colors.placeholderTextColor, lineSpacing: 0)
        self.lblHaveAccount.attributedText = cmsAlreadyHaveAccountString.removeHTMLTag().toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.descriptionText, color: Colors.placeholderTextColor, lineSpacing: 0)
        self.lblHaveAccount.textAlignment = .center
        self.tfAC.attributedPlaceholder = cmsEnterAccessCodeString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
        self.btnSubmit.setTitle(cmsSubmitString, for: .normal)
        self.btnSignin.setTitle(cmsSigninString, for: .normal)
        self.btnWhatCanDo.setTitle(cmsSeeWhatWeCanDoString, for: .normal)
    }
    
    override func righBarItemTouch() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
//         show Language Screen
////        let languageScreen = SelectLanguageViewController()
//        self.navigationController?.pushViewController(languageScreen, animated: true)
    }
    
    
    // MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func textfieldDidChange(sender:UITextField) {
        self.tfAC.hideError()
    }
    
    @IBAction func submitAccessCode() {
        self.view.endEditing(true)
        guard let str = self.tfAC.text, !str.isEmpty else {
            self.tfAC.showErrorMessage(message: cmsKErrorEmptyAccessCode)
            return
        }
        ACProgressHUD.shared.showHUD()
        AzureServices().getProgramInfoWith(bin: str) { [weak self](results) in
            guard let self = self else {return}
            switch results{
            case .success(let programDetail):
                if(programDetail.status == 1) {  //valid
                    if self.isUpdateAccessCode {
                        self.updateUserProfileWith(accesscode: str)
                    }else {
                        ACProgressHUD.shared.hideHUD()
                        self.goNextStep()
                    }
                }else { // expired
                    ACProgressHUD.shared.hideHUD()
                    self.numberFailRequest += 1
                    self.showErrorMessage()
                }
            case.failure(let err):
                ACProgressHUD.shared.hideHUD()
                Crashlytics.crashlytics().record(error: err)
                if let networkErr = err as? NetworkError, networkErr == NetworkError.noInternet { return }
                if let error = err as? APIError, error == APIError.accesscodeInvalid { // invalid
                    self.numberFailRequest += 1
                    self.showErrorMessage()
                }else {
                    self.tfAC.showErrorMessage(message: NetworkError.unauthorized.localizedDescription)
                }
            }
        }
        
        if !isUpdateAccessCode {
//            FirebaseTracking.share.logEvent(event: FirebaseEvent.registration_initiated, viewController: self, parameter: ["registration_stage": "registration_initiated"])
        }
    }
    
    @IBAction func signInTouch(sender: UIButton) {
        self.goToSiginScreenWith(email: nil)
    }
    
    @IBAction func seeWhatWeCanDoTaped(sender : UIButton) {
//        let seeWhatWeCanDoScreen = SeeWhatWeCanDoScreen()
//        self.navigationController?.pushViewController(seeWhatWeCanDoScreen, animated: true)
    }
    
    private func goNextStep() {
        DispatchQueue.main.async { [weak self] in
            if let ac = self?.tfAC.text {
                RegisterData.share.accessCodeAES = ac.aesEncrypt()
            }
            let verifyEmailScreen = VerifyEmailViewController()
            self?.navigationController?.pushViewController(verifyEmailScreen, animated: true)
        }
        
    }
    
    private func updateUserProfileWith(accesscode: String) {
        if let userProfile = CurrentSession.share.aspireProfile {
            if let partyV = userProfile.partyVerifications?.first {
                partyV.verificationValue = accesscode
            }
            if let membership = userProfile.memberships?.first {
                membership.referenceNumber = accesscode
            }
            AzureServices().updateAspireProfile(profile: userProfile) { results in
                ACProgressHUD.shared.hideHUD()
                switch results{
                case .success(()):
                    self.goToSiginScreenWith(email: nil)
                case.failure(let err):
                    Crashlytics.crashlytics().record(error: err)
                    self.tfAC.showErrorMessage(message: err.localizedDescription, rightButtonTitle: nil, rightButtonAction: nil)
                }
            }
        }else {
            ACProgressHUD.shared.hideHUD()
        }
    }
    
    
    func showErrorMessage() {
        DispatchQueue.main.async {
            if let accesscode = self.tfAC.text, !accesscode.isEmpty {
//                if(self.numberFailRequest < 4) {
                    self.tfAC.showErrorMessage(message: self.cmsKErrorAccessCodeInvalid)
//                }else {
//                    let mutableAttString  = NSMutableAttributedString()
//                    let message = self.cmsKErrorConfirmAccessCode
//                    let range = (message as NSString).range(of: " 877-288-6503")
//                    mutableAttString.append(NSAttributedString(string: message))
//                    mutableAttString.addAttribute(.underlineStyle, value: 1, range: range)
//                    mutableAttString.addAttribute(.font, value: UIFont(name: Fonts.mediumFont, size: Sizes.headerText)!, range: range)
//                    self.tfAC.showErrorMessageWithAttributeString(attString: mutableAttString) {
//                        UtilServices.shared.callToPhoneNumber(phoneNumber: AppContants.phoneSupport)
//                    }
//                }
            } else {
                self.tfAC.showErrorMessage(message: self.cmsKErrorEmptyAccessCode)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
