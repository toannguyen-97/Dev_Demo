//
//  HomeThingToDoView.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//

import Foundation
import UIKit

class HomeThingToDoView: BaseCustomView , UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   //cms
    
    var titleInStr = "Things to Do in [City]"
    var titleNearStr = "Things to Do near [City]"
    var titleNoLocation =  "Get Inspiration for Your Trips"
    
    var locationCity:ASCity? {
        didSet {
            if let locationN = locationCity?.name {
                self.lblTitle.attributedText = titleNoLocation.withReplacedCharacters("[City]", by: locationN).toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.headerTitle, lineSpacing: 0)
            }else {
                self.lblTitle.text = titleNoLocation
            }
            if let kendic = self.kenticoDic {
                self.setText(dic: kendic)
            }
        }
    }
    var dataArray: [CategoryItem] = []
    @IBOutlet private var lblTitle : UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    
    private func setAccessibilityID() {
        self.lblTitle.accessibilityIdentifier = "ThingToDolblTitle"
        self.collectionView.accessibilityIdentifier = "ThingToDocollectionView"
    }
    
    override func setupUI() {
        super.setupUI()
        self.setAccessibilityID()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "HomeThingToDoCell", bundle: nil), forCellWithReuseIdentifier: "HomeThingToDoCell")
        
        self.lblTitle.textColor = Colors.headerTitle
        self.lblTitle.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        self.lblTitle.backgroundColor = UIColor.clear
    }
    
    override func setText(dic: [String : Any]){}
    
  

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.height * 170/303, height: self.collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        self.isHidden = self.dataArray.count <= 0
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeThingToDoCell", for: indexPath) as! HomeThingToDoCell
//        cell.data = self.dataArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedItem = dataArray[indexPath.row]
//        if let homeVC = self.parrentVC as? HomeViewController {
//            homeVC.selectCategoryAction(categoryItem: selectedItem)
//        }
    }
}
