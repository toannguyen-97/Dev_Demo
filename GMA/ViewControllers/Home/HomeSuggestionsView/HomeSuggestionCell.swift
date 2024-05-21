//
//  HomeSuggestionCell.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//
import UIKit

class HomeSuggestionCell: UICollectionViewCell {
    @IBOutlet private var borderView : UIView!
    @IBOutlet private var shadowView : UIView!
    @IBOutlet private var imgView : UIImageView!
    @IBOutlet private var lblTitle : UILabel!
    @IBOutlet private var lblDescrition : UILabel!
    
    var kenticoDic: [String:Any]?
    var locationName = ""
    var data : RecommendationItem? {
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
        self.imgView.accessibilityIdentifier = "SuggestionCellimgView"
        self.lblTitle.accessibilityIdentifier = "SuggestionCelllblTitle"
        self.lblDescrition.accessibilityIdentifier = "SuggestionCelllblDescrition"
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
    
        self.lblTitle.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
        self.lblTitle.textColor = Colors.blueBackground
        
        self.lblDescrition.font = UIFont(name: Fonts.regularFont, size: Sizes.headerText)
        self.lblDescrition.textColor = Colors.headerTitle
    }
    
    func setData(){}
       
}
