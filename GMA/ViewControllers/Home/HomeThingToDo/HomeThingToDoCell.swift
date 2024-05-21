//
//  HomeThingToDoCell.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//

import UIKit

class HomeThingToDoCell: UICollectionViewCell {
    
    @IBOutlet private var borderView : UIView!
    @IBOutlet private var shadowView : UIView!
    @IBOutlet private var imgView : UIImageView!
    @IBOutlet private var messageView : UIView!
    @IBOutlet private var lblTitle : UILabel!
    @IBOutlet private var lblDescrition : UILabel!
    
    var data : CategoryItem? {
        didSet {
            self.setData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        self.setAccessibilityID()
    }
    private func setAccessibilityID() {
        self.imgView.accessibilityIdentifier = "ThingToDoCellimgView"
        self.messageView.accessibilityIdentifier = "ThingToDoCellmessageView"
        self.lblTitle.accessibilityIdentifier = "ThingToDoCelllblTitle"
        self.lblDescrition.accessibilityIdentifier = "ThingToDoCelllblDescrition"
    }

    private func setupUI() {
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
        
        self.messageView.layer.cornerRadius = 12
        self.messageView.backgroundColor = Colors.navigationBarTitle
        
        self.lblTitle.font = UIFont(name: Fonts.mediumFont, size: Sizes.headerText)
        self.lblTitle.textColor = Colors.blueBackground
        
        self.lblDescrition.font = UIFont(name: Fonts.regularFont, size: Sizes.subHeaderText)
        self.lblDescrition.textColor = Colors.grayDescription
    }
    
    func setData(){
//        guard let category = self.data else {return}
//        self.lblTitle.text = category.categoryName
//        self.lblDescrition.attributedText = category.categoryDescription.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.subHeaderText, color: Colors.grayDescription, lineSpacing: 0)
//        self.imgView.setImageURL(urlString: category.categoryImage, placeholderURL: ExploreHepler.share.getDefaultImage(data: nil, contentType: category.categoryName))
//        self.lblTitle.textAlignment = .center
//        self.lblDescrition.textAlignment = .center
    }
}
