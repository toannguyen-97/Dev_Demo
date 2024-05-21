//
//  HomeTopView.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//



import UIKit
import FirebaseCrashlytics

class HomeTopView: BaseCustomView {
    
    @IBOutlet private var lblWelCome: UILabel!
    @IBOutlet private var locationView: UIView!
    @IBOutlet private var lblTemperature: UILabel!
    
    
    @IBOutlet private var btnCurrentLocation: UIButton!
    @IBOutlet private var btnSearchLocation: UIButton!
    var locationCity: ASCity? {
        didSet {
            self.loadData()
            if let dic = self.kenticoDic {
                self.setText(dic: dic)
            }
        }
    }
    var weatherData : OpenWeatherMap?
    
//    private func setAccessibilityID() {
//        self.lblWelCome.accessibilityIdentifier = "TopViewlblWelCome"
//        self.btnCurrentLocation.accessibilityIdentifier = "TopViewbtnLocation"
//        self.lblTemperature.accessibilityIdentifier = "TopViewlblTemperature"
//        self.locationView.accessibilityIdentifier = "TopViewlocationView"
//        self.btnSearchLocation.accessibilityIdentifier = "TopViewbtnSearchLocation"
//    }
    
    override func setupUI() {
        super.setupUI()
//        self.setAccessibilityID()
        self.locationView.backgroundColor = Colors.blueBackground
        self.locationView.layer.cornerRadius = self.locationView.frame.size.height/2
        self.locationView.layer.borderWidth = 1
        self.locationView.layer.borderColor = Colors.navigationBarButtonItemTitle.cgColor
        
        self.btnSearchLocation.titleLabel?.font =  UIFont(name: Fonts.mediumFont, size: Sizes.headerText)
        self.btnSearchLocation.setTitleColor(Colors.navigationBarTitle, for: .normal)
        self.btnCurrentLocation.backgroundColor = Colors.blueBackground
        self.btnCurrentLocation.layer.cornerRadius = self.btnCurrentLocation.frame.size.width/2
        self.btnCurrentLocation.clipsToBounds = true
        self.lblTemperature.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        self.lblTemperature.textColor = Colors.navigationBarTitle
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTemperature), name: NSNotification.Name(K_TEPERATURE_UNIT_CHANGE), object: nil)
    }
    
    override func setText(dic: [String : Any]) {
        super.setText(dic: dic)
        self.btnSearchLocation.setTitle("Search location", for: .normal)
//        if let firstName = CurrentSession.share.aspireProfile?.firstName,
//           let welcome = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app_homepage_welcome_select_location.elements.title.value") as? String {
            self.lblWelCome.attributedText = "Welcome \nIos".toAttributeStringWith(fontName: Fonts.mediumFont, fontSize: Sizes.profileTitle, color: Colors.blueBackground, lineSpacing: 0)
//        }
        if let locationSelect =  KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app_homepage_welcome_select_location.elements.cta_text1.value") as? String {
            if let locationN = self.locationCity?.name {
                self.btnSearchLocation.setTitle("location", for: .normal)
            }else {
                self.btnSearchLocation.setTitle("locationSelect", for: .normal)
            }
        }
    }
    
    override func loadData() {
        super.loadData()
        
    }
    
    @IBAction func chooseLocation(sender: UIButton) {
        if let homeVC = self.parrentVC as? HomeViewController {
            homeVC.chooseLocation()
        }
    }
    
    @IBAction func useCurrentUserLocation(sender: UIButton) {
        
    }
    
    @objc func homeScreenLocationChange() {
        
    }
    
    @objc func updateTemperature() {
        
    }
    
    private func temperatureStringToDisplay(){
        
        
    }
}
