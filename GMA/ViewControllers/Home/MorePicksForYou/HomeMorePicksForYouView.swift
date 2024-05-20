//
//  HomeMorePicksForYouView.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//

import Foundation
import UIKit
import FirebaseCrashlytics

class HomeMorePicksForYouView: BaseCustomView , UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var titleInStr = "More Picks for You in [City]"
    var titleNearStr = "More Picks for You near [City]"
    var locationCity:ASCity? {
        didSet {
            if let locationN = locationCity?.name {
                self.isHidden = false
                self.lblTitle.attributedText = self.getCMSTitle().withReplacedCharacters("[City]", by: locationN).toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.headerTitle, lineSpacing: 0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.getData()
                }
            }else {
                self.isHidden = true
            }
        }
    }
    var dataArray: [RecommendationItem] = []
    @IBOutlet private var lblTitle : UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    
    private func setAccessibilityID() {
        self.lblTitle.accessibilityIdentifier = "MorePicksForYoulblTitle"
        self.collectionView.accessibilityIdentifier = "MorePicksForYouCollectionView"
    }
    
    override func setupUI() {
        super.setupUI()
        self.setAccessibilityID()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "HomeMorePicksCell", bundle: nil), forCellWithReuseIdentifier: "HomeMorePicksCell")
        
        self.lblTitle.textColor = Colors.headerTitle
        self.lblTitle.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        self.lblTitle.backgroundColor = UIColor.clear
    }
    
    override func setText(dic: [String : Any]) {
        super.setText(dic: dic)
        if let title = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app_home_more_picks.elements.title.value") as? String {
            self.titleInStr = title
        }
        if let title = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app_home_more_picks.elements.value.value") as? String {
            self.titleNearStr = title
        }
        if let  locationN = self.locationCity?.name {
            self.lblTitle.attributedText = self.getCMSTitle().withReplacedCharacters("[City]", by: locationN).toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.headerTitle, lineSpacing: 0)
        }
    }
    private func getCMSTitle() -> String{
        if LocationManager.shared.locationIsCity(asCity: self.locationCity) {
            return self.titleInStr
        }else {
            return self.titleNearStr
        }
    }

    private func getData() {
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.height * 3/4, height: self.collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        self.isHidden = self.dataArray.count <= 0
//        if self.dataArray.count >= 8 {
//            return 8
//        }else {
//            return self.dataArray.count
//        }
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMorePicksCell", for: indexPath) as! HomeMorePicksCell
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let data = self.dataArray[safe: indexPath.row]
//        if let homeVC = self.parrentVC as? HomeViewController, let data = data {
//            if data.category?.lowercased() == diningCategory.lowercased() {
//                homeVC.openTopicDetail(topicID: "\(data.contentSource ?? "")_\(data.contentID ?? "")", isDining: true)
//            }else {
//                homeVC.openTopicDetail(topicID: "\(data.contentID ?? "")", isDining: false)
//            }
//        }else{
//            Crashlytics.crashlytics().log("didSelectItemAt: out of index")
//        }
    }
}
