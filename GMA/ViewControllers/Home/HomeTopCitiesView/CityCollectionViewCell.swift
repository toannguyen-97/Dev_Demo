//
//  CityCollectionViewCell.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//


import UIKit

class CityCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var borderView: UIView!
    @IBOutlet private var shadowView: UIView!
    @IBOutlet private var imgView: UIImageView!
    @IBOutlet private var messageView: UIView!
    @IBOutlet private var lblTitle: UILabel!
    @IBOutlet private var lblDescrition : UILabel!
    
    var trendyCity : TrendCity? {
        didSet {
//            self.setData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
//        self.setAccessibilityID()
    }
//    private func setAccessibilityID() {
//        self.imgView.accessibilityIdentifier = "CityCollectionViewCellimgView"
//        self.messageView.accessibilityIdentifier = "CityCollectionViewCellmessageView"
//        self.lblTitle.accessibilityIdentifier = "CityCollectionViewCelllblTitle"
//        self.lblDescrition.accessibilityIdentifier = "CityCollectionViewCelllblDescrition"
//    }
//    
    
    func setupUI() {
        self.borderView.backgroundColor = Colors.creamBackground
        self.borderView.layer.cornerRadius = 12.0
        self.imgView.layer.cornerRadius = 12.0
        self.borderView.clipsToBounds = true
        self.imgView.clipsToBounds = true
        // shadow
        self.shadowView.backgroundColor = Colors.navigationBarTitle
        self.shadowView.layer.shadowColor = Colors.black.cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.shadowView.layer.shadowOpacity = 0.6
        self.shadowView.layer.shadowRadius = 5.0
        
        self.messageView.layer.cornerRadius = 12.0
        self.messageView.clipsToBounds = true
        self.messageView.backgroundColor = UIColor.clear
        self.messageView.addBlur(blurStyle: .regular)
        

        self.lblTitle.font = UIFont(name: Fonts.mediumFont, size: Sizes.profileTitle)
        self.lblTitle.textColor = Colors.navigationBarTitle
        
        self.lblDescrition.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        self.lblDescrition.textColor = Colors.navigationBarTitle
    }
    
//    func setData(){
//        guard let city = self.trendyCity else {return}
//        self.lblTitle.attributedText = city.city.toAttributeStringWith(fontName: Fonts.mediumFont, fontSize: Sizes.profileTitle, color: Colors.navigationBarTitle, lineSpacing: 0)
//        if let country = city.country{
//            self.lblDescrition.attributedText = country.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.navigationBarTitle, lineSpacing: 0)
//        }else {
//            self.lblDescrition.text = ""
//        }
//        self.imgView.setImageURL(urlString: city.imageMarketImage2)
//        self.lblTitle.textAlignment = .center
//        self.lblDescrition.textAlignment = .center
//    }
}
