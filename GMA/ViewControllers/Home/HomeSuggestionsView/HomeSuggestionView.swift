//
//  HomeSuggestionView.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//


import UIKit

class HomeSuggestionView: BaseCustomView , UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var titleInStr = "Suggestion for You in [City]"
    var titleNearStr = "Suggestion for You near [City]"
    
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
    var dataArray: [RecommendationItem] = []
    @IBOutlet private var lblTitle : UILabel!
    @IBOutlet private var collectionView: UICollectionView!

    
    
    override func setupUI() {
        super.setupUI()
      
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "HomeSuggestionCell", bundle: nil), forCellWithReuseIdentifier: "HomeSuggestionCell")
        
        self.lblTitle.textColor = Colors.headerTitle
        self.lblTitle.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        self.lblTitle.backgroundColor = UIColor.clear
    }
    
    override func setText(dic: [String : Any]) {
        
    }
    
    private func getCMSTitle() -> String{
        if LocationManager.shared.locationIsCity(asCity: self.locationCity) {
            return self.titleInStr
        }else {
            return self.titleNearStr
        }
    }
    
    override func loadData() {
        
    }
    
    private func getData() {

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.height * 2.5, height: self.collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeSuggestionCell", for: indexPath) as! HomeSuggestionCell
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let data = self.dataArray[indexPath.row]
//        if let homeVC = self.parrentVC as? HomeViewController {
//            if data.category?.lowercased() == diningCategory.lowercased() {
//                homeVC.openTopicDetail(topicID: "\(data.contentSource ?? "")_\(data.contentID ?? "")", isDining: true)
//            }else {
//                homeVC.openTopicDetail(topicID: "\(data.contentID ?? "")", isDining: false)
////            }
//        }
    }
}
