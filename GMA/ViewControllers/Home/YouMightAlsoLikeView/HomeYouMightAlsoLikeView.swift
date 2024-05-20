//
//  HomeYouMightAlsoLikeView.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//


import Foundation
import UIKit
import FirebaseCrashlytics

class HomeYouMightAlsoLikeView: BaseCustomView, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private var lblTitle : UILabel!
    @IBOutlet private var tableView : UITableView!
    @IBOutlet private var tblHeightContraint : NSLayoutConstraint!
    
    var titleInStr = "You Might Also Like in [City]"
    var titleNearStr = "You Might Also Like near [City]"
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
    var dataArray: [ContentTopic] = []
    
    private func setAccessibilityID() {
        self.lblTitle.accessibilityIdentifier = "YouMightAlsoLikeLblTitle"
        self.tableView.accessibilityIdentifier = "YouMightAlsoLikeTableView"
    }
    
    override func setupUI() {
        super.setupUI()
        self.setAccessibilityID()
        lblTitle.accessibilityIdentifier = "title"
        tableView.accessibilityIdentifier = "tableview"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "HomeCommonTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeCommonTableViewCell")
        
        self.lblTitle.textColor = Colors.headerTitle
        self.lblTitle.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        self.lblTitle.backgroundColor = UIColor.clear
    }
    
    override func setText(dic: [String : Any]) {
        super.setText(dic: dic)
        if let title = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app_home_you_might_also_like.elements.title.value") as? String {
            self.titleInStr = title
        }
        if let title = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app_home_you_might_also_like.elements.value.value") as? String {
            self.titleNearStr = title
        }
        if let  locationN = self.locationCity?.name {
            self.lblTitle.attributedText = self.getCMSTitle().withReplacedCharacters("[City]", by: locationN).toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.headerTitle, lineSpacing: 0)
        }
        self.tableView.reloadData()
    }
    
    private func getCMSTitle() -> String{
        if LocationManager.shared.locationIsCity(asCity: self.locationCity) {
            return self.titleInStr
        }else {
            return self.titleNearStr
        }
    }
    
    func getData(){
       
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
//        self.tblHeightContraint.constant = 130.0*CGFloat(itemCount) + 30.0
//        return itemCount
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCommonTableViewCell", for: indexPath) as! HomeCommonTableViewCell
//        cell.kenticoDic = self.kenticoDic
//        cell.locationName = self.locationCity?.name ?? ""
//        cell.topic = self.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        Crashlytics.crashlytics().log("didSelectRowAt \(indexPath.row)")
//        let data = self.dataArray[safe: indexPath.row]
//        if data != nil{
//            if let homeVC = self.parrentVC as? HomeViewController {
//                if data?.attributes?.contentType.first?.lowercased() == diningCategory.lowercased() {
//                    homeVC.openTopicDetail(topicID: "ASPIRE_\(data?.topicID ?? "")", isDining: true)
//                }else {
//                    homeVC.openTopicDetail(topicID: data?.topicID ?? "", contentTopic: data)
//                }
//            }
//        }else{
//            Crashlytics.crashlytics().log("didSelectRowAt index out of range")
//        }
    }
}



