//
//  ConditionView.swift
//  GMA
//
//  Created by Saven Developer on 3/9/22.
//

import Foundation
import UIKit

class ConditionView: UIView {
    
     var btnCheck:UIButton!
     private var lblTitle:UILabel!
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        setupUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("fatal error")
    }
    
     func setupUI() {
        
         btnCheck = {
             let button = UIButton()
             button.setImage(UIImage(named: "check_normal")?.withRenderingMode(.alwaysTemplate), for: .normal)
             button.setImage(UIImage(named: "check_active"), for: .selected)
             return button
         }()
         lblTitle = {
             let label = UILabel()
             label.adjustsFontSizeToFitWidth = true
             return label
         }()
    
        addSubview(btnCheck)
        addSubview(lblTitle)
         
         btnCheck.setupConstraints(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil, withPadding: .init(top: 2, left: 2, bottom: 2, right: 2), size: .init(width: 28, height: 28))
         lblTitle.setupConstraints(top: self.topAnchor, leading: btnCheck.trailingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, withPadding: .init(top: 2, left: 2, bottom: 2, right: 2), size: .init(width: 0, height: 28))
    }

    var title:String = "" {
        didSet{
            self.lblTitle.attributedText = title.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.headerText, color: Colors.navigationBarButtonItemTitle, lineSpacing: 0)
        }
    }
    
    var title2:String = "" {
        didSet{
            self.lblTitle.attributedText = title2.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.headerText, color: Colors.headerTitle, lineSpacing: 0)
        }
    }
    
    var isValid:Bool{
        set{
            btnCheck.isSelected = newValue
        }
        get{
            return btnCheck.isSelected
        }
    }
}
