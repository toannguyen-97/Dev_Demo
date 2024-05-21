//
//  UILabel+Extensions.swift
//  GMA
//
//  Created by Hoan Nguyen on 17/05/2022.
//

import Foundation
import UIKit


public extension UILabel {
    
    @objc func setFontSwizzled(font: UIFont) {
        if self.shouldOverride() {
            self.setFontSwizzled(font: UIFont(name: Fonts.mediumFont, size: Sizes.titleText) ?? UIFont.systemFont(ofSize: Sizes.titleText))
        } else {
            self.setFontSwizzled(font: font)
        }
    }
    
    private func shouldOverride() -> Bool {
        let classes = ["UIDatePicker", "UIDatePickerWeekMonthDayView", "UIDatePickerContentView"]
        var view = self.superview
        while view != nil {
            let className = NSStringFromClass(type(of: view!))
            if classes.contains(className) {
                return true
            }
            view = view!.superview
        }
        return false
    }
    
    private static let swizzledSetFontImplementation: Void = {
        let instance: UILabel = UILabel()
        let aClass: AnyClass! = object_getClass(instance)
        let originalMethod = class_getInstanceMethod(aClass, #selector(setter: font))
        let swizzledMethod = class_getInstanceMethod(aClass, #selector(setFontSwizzled))
        
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            // switch implementation..
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }()
    
    static func swizzleSetFont() {
        _ = self.swizzledSetFontImplementation
    }
    
    func addTitleWithImage(title: String){
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "ic_pin")?.withRenderingMode(.alwaysTemplate)
        attachment.bounds =  CGRect(x: 0, y: -3, width: attachment.image!.size.width - 1, height: attachment.image!.size.height - 1)
        let attachmentString = NSAttributedString(attachment: attachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let textAfterIcon = NSAttributedString(string: "  \(title)")
        completeText.append(textAfterIcon)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = Sizes.paragraphLineSpacing
        paragraphStyle.lineBreakMode = .byTruncatingTail
        let range = NSMakeRange(0, completeText.mutableString.length)
        completeText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: range)
        
        self.attributedText = completeText
        self.textColor = Colors.headerTitle
        self.font = UIFont(name: Fonts.regularFont, size: Sizes.headerText)
    }
    
    func countLines() -> Int {
      guard let myText = self.text as NSString? else {
        return 0
      }
      self.layoutIfNeeded()
      let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
      let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
      return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
}
