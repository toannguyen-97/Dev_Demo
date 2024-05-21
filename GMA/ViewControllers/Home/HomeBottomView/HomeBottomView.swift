//
//  HomeBottomView.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//

import UIKit

class HomeBottomView: BaseCustomView {
    @IBOutlet var lblDescription : UILabel!
    
    override func setupUI() {
        super.setupUI()
        lblDescription.accessibilityIdentifier = "HomeBottomlblDescription"
    }
    
    override func loadData() {
        super.loadData()
        self.lblDescription.attributedText = "Didn't find what you need?\nYour Concierge would be\nhappy to help!".toAttributeStringWith(fontName: Fonts.mediumFont, fontSize: Sizes.titleText, color: Colors.blueBackground, lineSpacing: 0)
        self.lblDescription.textAlignment = .center
    }
    
}
