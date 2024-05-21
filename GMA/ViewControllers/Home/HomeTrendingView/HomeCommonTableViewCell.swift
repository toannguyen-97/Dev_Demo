//
//  HomeCommonTableViewCell.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//

import UIKit

class HomeCommonTableViewCell: UITableViewCell {
    @IBOutlet private var imgView: UIImageView!
    @IBOutlet private var lblTitle: UILabel!
    @IBOutlet private var lblDescrition: UILabel!
    @IBOutlet private var ratingContainerView: UIView!
    @IBOutlet private var ratingView: UIView!
    @IBOutlet private var imgStar: UIImageView!
    @IBOutlet private var lblRating: UILabel!
    @IBOutlet private var separatorLine: UIView!
    @IBOutlet private var bottomSeparatorLine: UIView!
    
    private func setAccessibilityID() {
        var view = self.superview
        while (view != nil && (view as? UITableView) == nil) {
          view = view?.superview
        }
        var tblID = "HomeCommonTable"
        if let idParrent = view?.accessibilityIdentifier {
            tblID = idParrent
        }
        imgView.accessibilityIdentifier = tblID + "imgIcon"
        lblTitle.accessibilityIdentifier = tblID +  "lblTitle"
        lblDescrition.accessibilityIdentifier = tblID +  "description"
        ratingContainerView.accessibilityIdentifier = tblID +  "ratingContainerView"
        ratingView.accessibilityIdentifier = tblID +  "ratingView"
        imgStar.accessibilityIdentifier = tblID +  "ImgStar"
        lblRating.accessibilityIdentifier = tblID + "lblRating"
    }
    var kenticoDic: [String: Any]?
    var locationName = ""
    
    var trend: Trend? {
        didSet {
            self.setData()
        }
    }
    
    var topic : ContentTopic? {
        didSet {
            self.setData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgView.layer.cornerRadius = 12
        self.imgView.clipsToBounds = true
        self.separatorLine.backgroundColor = Colors.navigationBarButtonItemTitle
        self.bottomSeparatorLine.backgroundColor = Colors.navigationBarButtonItemTitle

        self.lblTitle.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
        self.lblTitle.textColor = Colors.blueBackground
        
        self.lblDescrition.font = UIFont(name: Fonts.regularFont, size: Sizes.headerText)
        self.lblDescrition.textColor = Colors.headerTitle
        
        self.lblRating.font = UIFont(name: Fonts.regularFont, size: Sizes.tabbarTitleText)
        self.lblRating.textColor = Colors.navigationBarTitle
        
        self.ratingView.layer.cornerRadius = 4.0
        self.ratingView.clipsToBounds = true
        self.ratingView.backgroundColor = Colors.redBackground
    }
    
    func setData() {

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
