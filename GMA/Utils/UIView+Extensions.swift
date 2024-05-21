//
//  Extensions.swift
//  GMA
//
//  Created by Saven Developer on 1/17/22.
//

import Foundation
import UIKit

enum Gradient_Direction {
    case Top2Bottom
    case Bottom2Top
    case Left2Right
    case Right2Left
}

extension UIView{
    
    func addBadgeOnTopRight() -> UILabel {
        let lblCount = UILabel()
        lblCount.layer.cornerRadius = 12.0
        lblCount.layer.borderWidth = 3.0
        lblCount.textAlignment = .center
        lblCount.layer.borderColor = Colors.greenBackground.cgColor
        lblCount.font = UIFont(name: Fonts.mediumFont, size: Sizes.headerText)
        lblCount.textColor = Colors.blueBackground
        lblCount.clipsToBounds = true
        lblCount.backgroundColor = Colors.navigationBarTitle
        self.superview?.addSubview(lblCount)
        lblCount.setupConstraints(top: self.topAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, withPadding: UIEdgeInsets(top: -8, left: 0, bottom: 0, right: -8), size: CGSize(width: 24, height: 24))
        return lblCount
    }
    
    func addGradientSeparator(direction: Gradient_Direction) -> CAGradientLayer {
        let fromColor = Colors.placeholderTextColor.cgColor
        let toColor = UIColor.white.cgColor
        let viewFrame = self.frame
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [fromColor, toColor]
        gradientLayer.opacity = 1.0
        if direction == .Bottom2Top {
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        }else if direction == .Top2Bottom {
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        }else if direction == .Right2Left {
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        }else {
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        }
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: viewFrame.height)
        self.layer.addSublayer(gradientLayer)
        return gradientLayer
    }
    
    func setupCenterConstraints(centerX: NSLayoutXAxisAnchor?, centerY: NSLayoutYAxisAnchor?, withPadding: UIEdgeInsets = .zero, size: CGSize = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX = centerX
        {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerY
        {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        if size.width != 0
        {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0
        {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func setupConstraints(top: NSLayoutYAxisAnchor?,leading: NSLayoutXAxisAnchor?,bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, withPadding: UIEdgeInsets = .zero, size: CGSize = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top
        {
            topAnchor.constraint(equalTo: top, constant: withPadding.top).isActive = true
        }
        if let left = leading
        {
            leadingAnchor.constraint(equalTo: left, constant: withPadding.left).isActive = true
        }
        if let bottom = bottom
        {
            bottomAnchor.constraint(equalTo: bottom, constant: -withPadding.bottom).isActive = true
        }
        if let right = trailing
        {
            trailingAnchor.constraint(equalTo: right, constant: -withPadding.right).isActive = true
        }
        if size.width != 0
        {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0
        {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func fillWithSuperView(withPadding:UIEdgeInsets = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor{
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: withPadding.top).isActive = true
        }
        if let superviewLeftAnchor = superview?.leftAnchor{
            leftAnchor.constraint(equalTo: superviewLeftAnchor, constant: withPadding.left).isActive = true
        }
        if let superviewBottomAnchor = superview?.bottomAnchor{
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -withPadding.bottom).isActive = true
        }
        if let superviewRightAnchor = superview?.rightAnchor{
            rightAnchor.constraint(equalTo: superviewRightAnchor, constant: -withPadding.right).isActive = true
        }
    }
    
    func addBlur(blurStyle:UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: blurStyle)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.bounds
        visualEffectView.isUserInteractionEnabled = false
        self.insertSubview(visualEffectView, at: 0)
        visualEffectView.setupConstraints(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, withPadding: .zero, size: .zero)
    }
    
    func addBorderWithDarkAtBottom(color:UIColor) {
        self.backgroundColor = UIColor.clear
        self.layer.borderColor = color.withAlphaComponent(0.5).cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
        guard let bottomLine = self.viewWithTag(1234) else {
            let bLine = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 2, width: self.frame.size.width, height: 1))
            bLine.tag = 1234
            bLine.backgroundColor = color
            self.addSubview(bLine)
            bLine.setupConstraints(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, withPadding: UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0), size: CGSize(width: 0, height: 1))
            return
        }
        bottomLine.backgroundColor = color
    }
    
    func addBottomLine(){
        let view = UIView()
        view.backgroundColor = Colors.bottomLine
        self.addSubview(view)
        view.setupConstraints(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, withPadding: .init(top: 0, left: 20, bottom: 0, right: 0),size: .init(width: 0, height: 1))
    }
    
    func addBottomBorderLine(){
        let view = UIView()
        view.backgroundColor = Colors.bottomLine
        self.addSubview(view)
        view.setupConstraints(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, withPadding: .init(top: 0, left: 0, bottom: -25, right: 0),size: .init(width: 0, height: 1))
    }
    
    
    public func removeAllConstraints() {
        var _superview = self.superview
        while let superview = _superview {
            for constraint in superview.constraints {
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }
                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
            _superview = superview.superview
        }
        
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
    
    
    var heightConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    var widthConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }

}
