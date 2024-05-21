//
//  SelectLocationViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//



import UIKit
import ACProgressHUD_Swift
import CoreLocation


struct City : Codable {
    var name: String?
    var country: String?
    var image: String?
    var countryCode: String?
    var englishName: String?
    init() {
        
    }
    
    init(name: String?, country: String?, image: String, countryCode: String, englishName: String?) {
        self.name = name
        self.country = country
        self.image = image
    }
}

protocol SelectLocationDelegate {
    func locationDidSelected(city:ASCity)
}

class SelectLocationViewController: BaseViewController {
    
    @IBOutlet private var navigationBarView: UIView!
    @IBOutlet private var lblTitle: UILabel!

    @IBOutlet private var btnSearch: UIButton!
    @IBOutlet private var btnLocation: UIButton!
    
    @IBOutlet private var btnAsia: UIButton!
    @IBOutlet private var btnAmericas: UIButton!
    @IBOutlet private var btnEurope: UIButton!
    
    @IBOutlet private var tableView: UITableView!
    
    @IBOutlet private var headerView: UIView!
    @IBOutlet private var indicatorView: UIView!
    @IBOutlet private var indicatorViewLeadingConstraint: NSLayoutConstraint!
    
    // CMS String
    var cmsLabelStr = ""
    var cmsAsiaStr = ""
    var cmsAmeracasStr = ""
    var cmsEuropeStr = ""
    var cmsLocationButtonStr = ""
    
    
    var displayCities:[City] = []
    var asiaCities:[City] = []
    var americasCities:[City] = []
    var europeCities:[City] = []

    convenience  init(isUpdate: Bool = false) {
        self.init()
        isUpdateFlow = isUpdate
    }
    var delegate: SelectLocationDelegate?
//    var selectedCity:ASCity? = CurrentSession.share.citySelected{
//        didSet {
//            if let city = selectedCity {
//                self.delegate?.locationDidSelected(city: city)
//            }
//        }
//    }
    var isUpdateFlow = false
    
    override func viewDidLoad() {
        if !isUpdateFlow {
            ACProgressHUD.shared.showHUD()
            self.kenticoCodeName = "app___categories_locations"
            self.kenticoDepth = 3
        }
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        loadCMSTextFinish()
    }
    
    
    override func loadCMSTextFinish() {
        super.loadCMSTextFinish()
        ACProgressHUD.shared.hideHUD()
        guard let kenDic = self.kenticoDic else {return}
        if let title = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.app___categories_list.elements.title.value") as? String {
            self.title = title
        }
        self.americasCities = []
        self.europeCities = []
        self.asiaCities = []
        ["app___americas", "app___asia_pacific", "app___europe"].forEach { regionCode in
            if let countries = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.\(regionCode).elements.countries.value") as? [String] {
                countries.forEach { countryCode in
                    if let cities = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.\(countryCode).elements.major_markets.value") as? [String],
                        let coutryName = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.\(countryCode).elements.name.value") as? String {
                        let countryCode = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.\(countryCode).elements.country_code.value") as? String
                        cities.forEach { cityName in
                            var city = City()
                            city.countryCode = countryCode
                            city.country = coutryName
                            if let cityName = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.\(cityName).elements.name.value") as? String {
                                city.name = cityName
                            }
                            if let cityName = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.\(cityName).elements.value.value") as? String {
                                city.englishName = cityName
                            }else {
                                city.englishName = city.name
                            }
                            
                            if let cityImage = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.\(cityName).elements.image.value") as? [[String:Any]], let imageURL = cityImage.first?["url"] as? String {
                                city.image = imageURL
                            }
                            if regionCode == "app___asia_pacific" {
                                self.asiaCities.append(city)
                            }else if regionCode == "app___americas" {
                                self.americasCities.append(city)
                            }else {
                                self.europeCities.append(city)
                            }
                        }
                    }
                }
            }
        }
        self.asiaCities = self.asiaCities.sorted(by: {($0.name ?? "") < ($1.name ?? "")})
        self.americasCities = self.americasCities.sorted(by: {($0.name ?? "") < ($1.name ?? "")})
        self.europeCities = self.europeCities.sorted(by: {($0.name ?? "") < ($1.name ?? "")})
        self.displayDefaultTab()
    }
    

    override func setupUI() {
        super.setupUI()
        self.lblTitle.textColor = Colors.blueBackground
        self.lblTitle.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
        self.navigationBarView.isHidden = isUpdateFlow
        self.tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "CityTableViewCell")
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        self.btnLocation.backgroundColor = Colors.blueBackground
        self.btnLocation.layer.cornerRadius = self.btnSearch.frame.size.height/2
        self.btnSearch.backgroundColor = Colors.blueBackground
        self.btnSearch.setTitleColor(Colors.navigationBarTitle, for: .normal)
        self.btnSearch.titleLabel?.font = UIFont(name: Fonts.mediumFont, size: Sizes.headerText)
        self.btnSearch.layer.cornerRadius = self.btnLocation.frame.size.height/2
        self.btnLocation.clipsToBounds = true
        self.indicatorView.backgroundColor = Colors.blueBackground
        
        let segmentButtons = [btnAsia, btnAmericas, btnEurope]
        segmentButtons.forEach { button in
            button?.titleLabel?.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
            button?.setTitleColor(Colors.blueBackground, for: .normal)
        }
        self.tableView.tableHeaderView = self.headerView
        
        self.lblTitle.text = cmsLabelStr
        self.btnAsia.setTitle(cmsAsiaStr, for: .normal)
        self.btnAmericas.setTitle(cmsAmeracasStr, for: .normal)
        self.btnEurope.setTitle(cmsEuropeStr, for: .normal)
//        if let currentCity = CurrentSession.share.citySelected {
//            self.btnSearch.setTitle(currentCity.name, for: .normal)
//        }else {
//            self.btnSearch.setTitle(cmsLocationButtonStr, for: .normal)
//        }
        self.btnAsia.centerVertically()
        self.btnAmericas.centerVertically()
        self.btnEurope.centerVertically()
    }
    
   
    override func setText() {
        super.setText()
//        if let dic = kenticoDic{
//            if let selectLocation = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___location.elements.title.value") as? String {
//                cmsLabelStr = selectLocation
//            }
//            if let asiaPacific = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___asia_pacific.elements.name.value") as? String {
//                cmsAsiaStr = asiaPacific
//            }
//            if let americas = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___americas.elements.name.value") as? String {
//                cmsAmeracasStr = americas
//            }
//            if let europe = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___europe.elements.name.value") as? String {
//                cmsEuropeStr = europe
//            }
//            if let useMyLocation = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___location.elements.description.value") as? String {
//                cmsLocationButtonStr = useMyLocation
//            }
//        }
//        
//        if self.btnAsia != nil {
//            self.lblTitle.text = cmsLabelStr
//            self.btnAsia.setTitle(cmsAsiaStr, for: .normal)
//            self.btnAmericas.setTitle(cmsAmeracasStr, for: .normal)
//            self.btnEurope.setTitle(cmsEuropeStr, for: .normal)
//            if let currentCity = CurrentSession.share.citySelected {
//                self.btnSearch.setTitle(currentCity.name, for: .normal)
//            }else {
//                self.btnSearch.setTitle(cmsLocationButtonStr, for: .normal)
//            }
//            self.btnAsia.centerVertically()
//            self.btnAmericas.centerVertically()
//            self.btnEurope.centerVertically()
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.btnAsia.centerVertically()
        self.btnAmericas.centerVertically()
        self.btnEurope.centerVertically()
        [self.btnAmericas, self.btnAsia, self.btnEurope].forEach { button in
            if let btn = button, btn.isSelected {
                self.indicatorViewLeadingConstraint.constant = btn.frame.origin.x
            }
        }
    }
    
    @IBAction func searchTapped(sender: UIButton) {
//        gotoLocationSearchScreen { locationCity in
//            DispatchQueue.main.async {
//                self.selectedCity = locationCity
//                self.btnSearch.setTitle(locationCity.name, for: .normal)
//                self.nextStep()
//            }
//        }
    }
    
    private func gotoLocationSearchScreen(changeLocationHanler:@escaping (_ locationCity:ASCity)-> Void) {
        let searchLocationScreen = LocationSearchViewController()
        searchLocationScreen.hidesBottomBarWhenPushed = true
//        searchLocationScreen.changeLocationHanler = changeLocationHanler
        self.navigationController?.pushViewController(searchLocationScreen, animated: true)
    }
    
    @IBAction func myLocationTapped(sender: UIButton) {
        if let currentCity = LocationManager.shared.currentUserASCity {
            self.btnSearch.setTitle(currentCity.name, for: .normal)
//            self.selectedCity = ASCity(name: currentCity.name, countryCode: currentCity.countryCode, coordinate: currentCity.coordinate, types: nil,cityNameInEnglish: currentCity.cityNameInEnglish)
            self.nextStep()
        }else {
            let alertController = UIAlertController(title: AppContants.shared.cmsLocationDisableString, message: AppContants.shared.cmsEnableLocationMessageString, preferredStyle: .alert)
            let openAlert = UIAlertAction(title: AppContants.shared.cmsSettingSystemString, style: .default) { [self] (alertAction) in
                NotificationCenter.default.addObserver(self, selector: #selector(locationChange), name: NSNotification.Name(kLOCATION_UPDATE), object: nil)
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            alertController.addAction(openAlert)
            let defaultAction = UIAlertAction(title: AppContants.shared.cmsCancelSytemString, style: .default, handler: nil)
            defaultAction.accessibilityIdentifier = "LocationAlertCancel"
            openAlert.accessibilityIdentifier = "LocationAlertOpenSetting"
            alertController.addAction(defaultAction)
            DispatchQueue.main.async {
                UIApplication.shared.topMostViewController()?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func locationChange() {
        if let location = LocationManager.shared.exposedLocation {
            LocationManager.shared.getPlace(for: location) { placeMarkCity in
                if let pCity = placeMarkCity {
                    self.btnSearch.setTitle(pCity.name, for: .normal)
//                    self.selectedCity =  ASCity(name: pCity.name, countryCode: pCity.countryCode, coordinate: pCity.coordinate, types: nil, cityNameInEnglish: pCity.cityNameInEnglish)
                    self.nextStep()
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func displayDefaultTab() {
        if self.tableView == nil {
            return
        }
//        guard let city = self.selectedCity?.name else {
//            self.segmentButtonTapped(sender: btnAsia)
//            return
//        }
//        if let countryCode = self.selectedCity?.countryCode {
//            if self.americasCities.contains(where: {$0.name == city && $0.countryCode == countryCode }) {
//                self.segmentButtonTapped(sender: btnAmericas)
//            }else if self.europeCities.contains(where: {$0.name == city && $0.countryCode == countryCode }) {
//                self.segmentButtonTapped(sender: btnEurope)
//            }else {
//                self.segmentButtonTapped(sender: btnAsia)
//            }
//        }else {
//            if self.americasCities.contains(where: {$0.name == city}) {
//                self.segmentButtonTapped(sender: btnAmericas)
//            }else if self.europeCities.contains(where: {$0.name == city}) {
//                self.segmentButtonTapped(sender: btnEurope)
//            }else {
//                self.segmentButtonTapped(sender: btnAsia)
//            }
//        }
    }
    
    
    @IBAction func segmentButtonTapped(sender: UIButton) {
        if sender.isSelected {
            return
        }
        btnAsia.isSelected = false
        btnAmericas.isSelected = false
        btnEurope.isSelected = false
        sender.isSelected = true
        UIView.animate(withDuration: 0.1) {
            self.indicatorViewLeadingConstraint.constant = sender.frame.origin.x
            self.view.layoutIfNeeded()
            self.tableView.contentOffset = CGPoint.zero
        }
        if sender ==  self.btnAsia{
            self.displayCities = self.asiaCities
        }else if sender == self.btnAmericas {
            self.displayCities = self.americasCities
        }else {
            self.displayCities = self.europeCities
        }
        if self.tableView != nil {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func closeTapped(sender: UIButton) {
        self.backViewController()
    }
    
    func nextStep() {
//        if !isUpdateFlow {
//            if let delegate = delegate {
//                if let city = self.selectedCity {
//                    delegate.locationDidSelected(city: city)
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }else {
//                CurrentSession.share.citySelected = self.selectedCity
//                if let _ = CurrentSession.share.categorySelected {
//                    MainTabbarController.shared.switchToExploreScreen()
//                }else {
//                    let categoryScreen = SelectCategoryViewController()
//                    self.navigationController?.pushViewController(categoryScreen, animated: true)
//                }
//            }
//           
//        }else {
//            if let city = self.selectedCity {
//                self.delegate?.locationDidSelected(city: city)
//            }
//        }
    }
}

//extension SelectLocationViewController : UITableViewDataSource, UITableViewDelegate {
//   
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.displayCities.count
//    }
//    
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
////        cell.cityItem = self.displayCities[indexPath.row]
////        if cell.cityItem?.name == self.selectedCity?.name {
////            cell.selectedView.isHidden = false
////        }else {
////            cell.selectedView.isHidden = true
////        }
////        
////        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        let city = self.displayCities[indexPath.row]
////        self.selectedCity = ASCity(name: city.name ?? "", countryCode: city.countryCode, coordinate: nil, types: nil, cityNameInEnglish: city.englishName)
////        self.tableView.reloadData()
////        nextStep()
//    }
//
//}

