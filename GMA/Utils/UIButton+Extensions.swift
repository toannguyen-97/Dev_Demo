//
//  UIButton+Extensions.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/21/22.
//

import Foundation
import UIKit

extension UIButton{
    
    func setCommonStyle() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 12.0
        self.titleLabel?.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
        self.backgroundColor = Colors.navigationBarTitle
        self.setTitleColor(Colors.blueBackground, for: .normal)
        self.setTitleColor(UIColor.gray, for: .disabled)
        self.setBackgroundColorForTouchingStatus()
    }
    
    func addTimeSlotAttributes(color: UIColor){
        self.titleLabel?.font = UIFont(name: Fonts.mediumFont, size: Sizes.headerText)
        self.setTitleColor(color, for: .normal)
        self.layer.cornerRadius = 10
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
    }
    
    func setTranparentStyle() {
        self.clipsToBounds =  true
        self.layer.cornerRadius = 12.0
        self.titleLabel?.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
        self.backgroundColor = UIColor.clear
        self.setTitleColor(Colors.navigationBarTitle, for: .normal)
        self.setTitleColor(UIColor.lightText, for: .disabled)
        self.setBackgroundColorForTouchingStatus()
    }
    
    func setBackgroundColorForTouchingStatus() {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(Colors.secondPlacholderText.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: 1.0, height: 1.0))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: .highlighted)
    }
    
    func setCommonButtonStyle() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 12.0
        self.titleLabel?.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
        self.backgroundColor = Colors.navigationBarTitle
        self.setTitleColor(Colors.blueBackground, for: .normal)
        self.setTitleColor(UIColor.gray, for: .disabled)
        self.setButtonBackgroundColorForTouchingState()
    }
    
    func setButtonBackgroundColorForTouchingState() {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.lightGray.withAlphaComponent(0.2).cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: 1.0, height: 1.0))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: .highlighted)
    }
    
    func centerVertically(padding: CGFloat = 6.0) {
        guard
            let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size else {
            return
        }
        
        let totalHeight = imageViewSize.height + titleLabelSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageViewSize.height),
            left: 0.0,
            bottom: 0.0,
            right: -titleLabelSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height + padding),
            right: 0.0
        )
        
        self.contentEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: titleLabelSize.height,
            right: 0.0
        )
    }
}


