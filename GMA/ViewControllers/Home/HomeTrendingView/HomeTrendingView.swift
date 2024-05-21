//
//  HomeTrendingView.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//


import Foundation
import UIKit

class HomeTrendingView: BaseCustomView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private var lblTitle : UILabel!
    @IBOutlet private var tblTrending : UITableView!
    @IBOutlet private var tblTrendingHeightContraint : NSLayoutConstraint!
    
    var titleInStr = "Trending In [City]"
    var titleNearStr = "Trending Near [City]"
    var locationCity:ASCity? {
        didSet {
            if let locationN = locationCity?.name {
                self.isHidden = false
                self.lblTitle.attributedText = self.getCMSTitle().withReplacedCharacters("[City]", by: locationN).toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.headerTitle, lineSpacing: 0)
                self.getData()
            }else {
                self.isHidden = true
            }
        }
    }
    var dataArray: [Trend] = []
    
    private func setAccessibilityID() {
        self.lblTitle.accessibilityIdentifier = "TrendinglblTitle"
        self.tblTrending.accessibilityIdentifier = "TrendingtblTrending"
    }
    
    override func setupUI() {
        super.setupUI()
        self.setAccessibilityID()
        self.tblTrending.dataSource = self
        self.tblTrending.delegate = self
        self.tblTrending.separatorStyle = .none
        self.tblTrending.register(UINib(nibName: "HomeCommonTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeCommonTableViewCell")
        
        self.lblTitle.textColor = Colors.headerTitle
        self.lblTitle.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        self.lblTitle.backgroundColor = UIColor.clear
    }
    
    override func setText(dic: [String : Any]) {
        super.setText(dic: dic)
        if let title = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app_home_trending_worldwide.elements.title.value") as? String {
            self.titleInStr = title
        }
        if let title = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app_home_trending_worldwide.elements.value.value") as? String {
            self.titleNearStr = title
        }
        if let  locationN = self.locationCity?.name {
            self.lblTitle.attributedText = self.getCMSTitle().withReplacedCharacters("[City]", by: locationN).toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.headerTitle, lineSpacing: 0)
        }
//        self.tblTrending.reloadData()
    }
    
    private func getCMSTitle() -> String{
        if LocationManager.shared.locationIsCity(asCity: self.locationCity) {
            return self.titleInStr
        }else {
            return self.titleNearStr
        }
    }
    
    func getData(){
//        self.showLoader()
//        let clientAvailability = ["Default", "Restricted", "Excluded"]
//        let qualityRating = ["3", "4", "5"]
//        TrendyServices().getTrendyContent(city: self.locationCity?.getValueToSendRequest()?.correctCityName() ?? "") {[weak self] result in
//            DispatchQueue.main.async {
//                guard let self = self else {return}
//                self.hideLoader()
//                switch result {
//                case .success(let recommendations):
//                    if recommendations.count > 0{
//                        self.isHidden = false
//                        self.dataArray = recommendations.filter{ qualityRating.contains($0.qualityRating) && clientAvailability.contains($0.client_availability) && $0.category.lowercased() != offerCategoryType.lowercased()}
//                        self.tblTrending.reloadData()
//                    }else {
//                        self.isHidden = true
//                    }
//                case .failure(_):
//                    self.isHidden = true
//                }
//            }
//        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var itemCount = self.dataArray.count
//        if(itemCount >= 8) {
//            itemCount = 8
//        } else {
//            itemCount = self.dataArray.count
//        }
//        self.isHidden = itemCount <= 0
//        self.tblTrendingHeightContraint.constant = 130.0*CGFloat(itemCount) + 30.0
//        return itemCount
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCommonTableViewCell", for: indexPath) as! HomeCommonTableViewCell
        //        cell.locationName = self.locationCity?.name ?? ""
        //        cell.kenticoDic = self.kenticoDic
        //        cell.trend = self.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let data = self.dataArray[indexPath.row]
        //        if let homeVC = self.parrentVC as? HomeViewController {
        //            if data.category.lowercased() == diningCategory.lowercased() {
        //                homeVC.openTopicDetail(topicID: "ASPIRE_\(data.contentID)", isDining: true)
        //            }else {
        //                homeVC.openTopicDetail(topicID: "\(data.contentID)", isDining: false)
        //            }
        //        }
        //    }
        
    }
}
