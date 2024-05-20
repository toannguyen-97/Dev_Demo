//
//  UITextField+Extensions.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/21/22.
//

import Foundation
import UIKit

extension UITextField {
    
    fileprivate func setPasswordToggleImage(_ button: UIButton) {
        if(isSecureTextEntry){
            button.setImage(UIImage(named: "ic_show"), for: .normal)
        }else{
            button.setImage(UIImage(named: "ic_hide"), for: .normal)

        }
    }

    func enablePasswordToggle(){
//        let button = UIButton(type: .custom)
//        setPasswordToggleImage(button)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
//        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
//        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
//        self.rightView = button
//        self.rightViewMode = .always
    }
    @objc func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        setPasswordToggleImage(sender as! UIButton)
    }
    
    
    func setCommonStyle() {
        self.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        self.textColor = Colors.placeholderTextColor
        self.backgroundColor = UIColor.clear
        if self.isSecureTextEntry {
            self.textColor = Colors.navigationBarTitle
        }
        self.applyWhiteTintToClearButton()
        self.setLeftPadding(15)
        //if you set right padding clear button won't appear so commenting the right padding.
     //   self.setRightPadding(15)
     }
    
    func applyWhiteTintToClearButton() {
        let clearButton = self.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = UIColor.white.withAlphaComponent(0.7)
    }
    
    func applyGrayTintToClearButton() {
        let clearButton = self.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = UIColor.gray.withAlphaComponent(0.7)
    }

    var isEmpty: Bool {
        if let text = self.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
                return false
           }
           return true
       }
    
    func setLeftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setIcon(_ image: UIImage) {
        
        let iconContainerView: UIView = UIView(frame:
                                                CGRect(x: 20, y: 0, width: 40, height: self.frame.size.height))
        let iconView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: self.frame.size.height - 20))
        iconView.contentMode = .scaleAspectFill
        iconView.image = image
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    
}
