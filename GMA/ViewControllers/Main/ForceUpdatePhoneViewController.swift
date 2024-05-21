//
//  ForceUpdatePhoneViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.


import Foundation
import UIKit
import ACProgressHUD_Swift
import FirebaseCrashlytics

class ForceUpdatePhoneViewController : BaseViewController{
    private var lblDescription: UILabel!
    private var dropDownView: UIView!
    private var mobileNumberTF: UITextField!
    private var flagImageView: UIImageView!
    private var mobileCodeLabel: UILabel!
    private var dropDownButton: UIButton!
    private var saveChangesButton: UIButton!
    private var ary_countryDetails: Array<CountryDetail>!
    private var currentCountry: CountryDetail?

  // CMS String
    private var  kEnterValidDetails = ""
    private var  longPhoneError = ""
    private var  cmsDescriptionString = ""
    override func viewDidLoad() {
        self.kenticoCodeName = "app___phone_number_migration"
        self.kenticoDepth = 2
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCountrylist()
        
    }
    
    override func loadCMSTextFinish() {
        super.loadCMSTextFinish()
        ACProgressHUD.shared.hideHUD()
    }
    
    override func setText() {
        super.setText()
        if let kenDic = self.kenticoDic{
            if let title = KenticoServices.getKenticoValue(dict: kenDic, path: "item.elements.title.value") as? String{
                self.title = title
            }
            if let save = KenticoServices.getKenticoValue(dict: kenDic, path: "item.elements.cta_text1.value") as? String{
                saveChangesButton.setTitle(save, for: .normal)
            }
            if let mobile = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.app___phone_number.elements.watermark_message.value") as? String{
                mobileNumberTF.attributedPlaceholder = mobile.toAttributeStringWith(fontName: Fonts.lightFont, fontSize: Sizes.titleText, color: Colors.black, lineSpacing: 0)
            }
            if let fieldsError = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.app___invalid_phone_number.elements.description.value") as? String{
                kEnterValidDetails = fieldsError
            }
            if let longPhoneNumberError = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.app___phone_number_too_long_error_message.elements.description.value") as? String{
                longPhoneError = longPhoneNumberError
            }

            if let str = KenticoServices.getKenticoValue(dict: kenDic, path: "item.elements.description.value") as? String{
                cmsDescriptionString = str
                self.lblDescription.attributedText = cmsDescriptionString.toAttributeStringWith(fontName: Fonts.mediumFont, fontSize: Sizes.titleText, color: Colors.black, lineSpacing: 0)
                self.lblDescription.textAlignment = .center
            }
        }
    }
    
    override func setupUI() {
        super.setupUI()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.blueBackground]
        
        lblDescription = {
           let lbl = UILabel()
            lbl.textAlignment = .center
            lbl.textColor = Colors.black
            lbl.numberOfLines = 0
            return lbl
        }()
        
        dropDownView = {
            let view = UIView()
            view.addBorderWithDarkAtBottom(color: Colors.blueBackground)
            return view
        }()
        
        mobileCodeLabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
            label.text = ""
            label.backgroundColor = .clear
            return label
        }()
        
        mobileNumberTF = {
            let textField = UITextField()
            textField.setLeftPadding(15)
            textField.addBorderWithDarkAtBottom(color: Colors.blueBackground)
            textField.clearButtonMode = .whileEditing
            textField.tintColor = Colors.blackBackground
            textField.delegate = self
            textField.textColor = Colors.blackBackground
            textField.keyboardType = .numberPad
            textField.applyGrayTintToClearButton()
            textField.accessibilityIdentifier = "mobileNumberField"
            textField.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
            return textField
        }()
        
        saveChangesButton = {
            let button = UIButton()
            button.clipsToBounds = true
            button.layer.cornerRadius = 0.0
            button.titleLabel?.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
            button.backgroundColor = Colors.greenBackground
            button.setTitleColor(Colors.navigationBarTitle, for: .normal)
            button.addTarget(self, action: #selector(action_saveChanges), for: .touchUpInside)
            button.accessibilityIdentifier = "edit profile save button"
            return button
        }()
        
        flagImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(systemName: "photo")
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
            imgView.tintColor = Colors.blueBackground
            imgView.accessibilityIdentifier = "edit_profile_flag_image"
            return imgView
        }()
        
        mobileCodeLabel = {
            let label = UILabel()
            label.textColor = Colors.blueBackground
            label.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
            label.text = ""
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.accessibilityIdentifier = "edit_profile_phone_code"
            return label
        }()
        
        dropDownButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            button.tintColor = Colors.blueBackground
            button.addTarget(self, action: #selector(presentCountryListView), for: .touchUpInside)
            button.accessibilityIdentifier = "edit_profile_phone_code"
            return button
        }()
        
        [lblDescription, dropDownView, mobileNumberTF, saveChangesButton].forEach({view.addSubview($0)})
        
        
        
        dropDownView.setupConstraints(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: nil, withPadding: .init(top: 0, left: 25, bottom: 0, right: 10), size: .init(width: 120, height: 60))
        dropDownView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50).isActive = true
        
        lblDescription.setupConstraints(top: nil, leading: view.leadingAnchor, bottom: dropDownView.topAnchor, trailing: view.trailingAnchor, withPadding: .init(top: 0, left: 25, bottom: 50, right: 25), size: .init(width: 0, height: 0))
        
        mobileNumberTF.setupConstraints(top: dropDownView.topAnchor, leading: dropDownView.trailingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 0, left: 10, bottom: 2, right: 25), size: .init(width: 0, height: 60))
        saveChangesButton.setupConstraints(top: mobileNumberTF.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 50, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 60))
        
        [flagImageView, mobileCodeLabel, dropDownButton].forEach({dropDownView.addSubview($0)})
        flagImageView.setupConstraints(top: nil, leading: dropDownView.leadingAnchor, bottom: nil, trailing: nil, withPadding: .init(top: 10, left: 10, bottom: 10, right: 5), size: .init(width: 25, height: 20))
        dropDownButton.setupConstraints(top: nil, leading: nil, bottom: nil, trailing: dropDownView.trailingAnchor, withPadding: .init(top: 10, left: 5, bottom: 10, right: 5), size: .init(width: 30, height: 20))
        mobileCodeLabel.setupConstraints(top: nil, leading: flagImageView.trailingAnchor, bottom: nil, trailing: dropDownButton.leadingAnchor, withPadding: .init(top: 0, left: 1, bottom: 0, right: 1))
        
        
        flagImageView.centerYAnchor.constraint(equalTo: dropDownView.centerYAnchor).isActive = true
        dropDownButton.centerYAnchor.constraint(equalTo: dropDownView.centerYAnchor).isActive = true
        mobileCodeLabel.centerYAnchor.constraint(equalTo: dropDownView.centerYAnchor, constant: -2 ).isActive = true
    }
    
    private func getCountrylist(){
        ary_countryDetails = Array()
        ACProgressHUD.shared.showHUD()
        AspireServices().getCountryList { [self] result in
            ACProgressHUD.shared.hideHUD()
            switch result{
            case .success(let countries):
                ary_countryDetails = countries
                setImageToFlag()
            case .failure(let error):
                print(error.localizedDescription)
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
    private func setImageToFlag(){
        if let countryCode = CurrentSession.share.programDetail?.country{
            var isHave = false
            for country in self.ary_countryDetails{
                if  countryCode == country.alpha3Code {
                    currentCountry = country
                    self.flagImageView.sd_setImage(with: URL(string: country.flag!), placeholderImage: UIImage(named: "photo"))
                    self.mobileCodeLabel.text = country.phoneCode
                    isHave = true
                }
            }
            if !isHave {
                currentCountry = self.ary_countryDetails.first
                self.flagImageView.sd_setImage(with: URL(string: currentCountry!.flag!), placeholderImage: UIImage(named: "photo"))
                self.mobileCodeLabel.text = currentCountry!.phoneCode
            }
        }
    }
    
    @objc func presentCountryListView(){
        let countrytListVC = CountryListViewController(countries: ary_countryDetails)
        countrytListVC.delegate = self
        DispatchQueue.main.async { [weak self] in
            self?.present(countrytListVC, animated: true, completion: nil)
        }
    }
    
    @objc func dismissViewController(){
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func action_saveChanges(){
        if let mobile = mobileNumberTF.text?.trim(), !mobile.isEmpty{
            if mobile.count > AppContants.phoneNumberLengLimit {
                if !self.mobileNumberTF.isEditing || self.mobileNumberTF.inputAccessoryView == nil {
                    self.mobileNumberTF.showErrorMessage(message: longPhoneError)
                }
                return
            }
            
            self.view.endEditing(true)
            guard let aspireProfile = CurrentSession.share.aspireProfile else {return}
            aspireProfile.phones?.first?.phoneNumber = mobileNumberTF.text!.trim()
            if let country = currentCountry{
                aspireProfile.phones?.first?.phoneCountryCode = country.phoneCode
                aspireProfile.residentCountry = country.alpha3Code
                aspireProfile.homeCountry = country.alpha3Code
            }
            updateAspireProfile(profile: aspireProfile)
        }else{
            mobileNumberTF.showErrorMessage(message: kEnterValidDetails, rightButtonTitle: nil, rightButtonAction: nil)
        }
    }
    
    func updateAspireProfile(profile: AspireProfile){
        ACProgressHUD.shared.showHUD()
        AzureServices().updateAspireProfile(profile: profile) { result in
            ACProgressHUD.shared.hideHUD()
            switch result {
            case .success( _):
                AzureServices().getAspireProfile { result in
                }
                self.dismissViewController()
            case .failure(let error):
                print(error.localizedDescription)
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
    
}

extension ForceUpdatePhoneViewController: countryDetailDelegate{
    
    func updateCountryDetails(CountryDetail: CountryDetail) {
        currentCountry = CountryDetail
        let imageURL = URL(string: CountryDetail.flag!)
        DispatchQueue.main.async { [weak self] in
            self?.flagImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "photo"))
            self?.mobileCodeLabel.text = CountryDetail.phoneCode
        }
        
    }
    
}

extension ForceUpdatePhoneViewController : UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.endEditing(true)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == mobileNumberTF{
            let text = textField.text
            let newLength = text!.count + string.count - range.length
            if newLength <= AppContants.phoneNumberLengLimit{
                textField.hideError()
                return true
            }else{
                textField.showErrorMessage(message: longPhoneError)
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
