//
//  CustomTabbar.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//

import UIKit

//@IBDesignable
class CustomTabbar: UITabBar {
    var shapeLayer: CALayer?
    var prominentButtonCallback: (()->Void)?


    
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
        
    private func setupUI() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: Fonts.mediumFont, size: Sizes.tabbarTitleText) ?? UIFont.systemFont(ofSize: Sizes.tabbarTitleText)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: Fonts.mediumFont, size: Sizes.tabbarTitleText) ?? UIFont.systemFont(ofSize: Sizes.tabbarTitleText)], for: .selected)
        self.tintColor = Colors.navigationBarTitle
        self.unselectedItemTintColor = Colors.navigationBarTitle
        let centerItem = self.items![2]
        let bottomH = UtilServices.shared.bottomSafeAreaInset()
        if bottomH == 0 {
            centerItem.imageInsets = UIEdgeInsets(top: -26, left: 4, bottom: 0, right: 4)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.addShape()
    }
    
    func addShape() {
        let sLayer = CAShapeLayer()
        sLayer.path = self.createPath()
        sLayer.strokeColor = Colors.blueBackground.cgColor
        sLayer.fillColor = Colors.blueBackground.cgColor
        sLayer.lineWidth = 1.0
        if let shapeLayer = shapeLayer {
            self.layer.replaceSublayer(shapeLayer, with: sLayer)
        } else {
            self.layer.insertSublayer(sLayer, at: 0)
        }
        shapeLayer = sLayer
    }
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        if let items = self.items, items.count > 0, let event = event, event.type == .touches, !self.isHidden {
//            let item  = items[items.count/2]
//            let middleExtra = item.imageInsets.top
//            let middleWidth = self.bounds.size.width/CGFloat(items.count)
//            let middleRect = CGRect(x: (self.bounds.size.width - middleWidth)/2, y: middleExtra, width: middleWidth, height: abs(middleExtra))
//            if middleRect.contains(point) {
//                self.prominentButtonCallback?()
//                return nil
//            }
//        }
//        return super.hitTest(point, with: event)
//    }
    
    
    private func createPath()-> CGPath {
        let height:CGFloat = 30.0
        let path = UIBezierPath()
        let centerWidth = self.frame.size.width/2
        path.move(to: CGPoint(x: 0, y: 0))
        if UIScreen.main.bounds.size.width <= AppContants.AppSmallScreenWidth {
            path.addLine(to: CGPoint(x: centerWidth - height*2.3, y: 0))
            path.addCurve(to: CGPoint(x: centerWidth, y: -17), controlPoint1: CGPoint(x: centerWidth - 8, y: 0), controlPoint2: CGPoint(x: centerWidth - 26, y: -15))
            path.addCurve(to: CGPoint(x: centerWidth + height*2.3, y: 0), controlPoint1: CGPoint(x: centerWidth + 25, y: -15), controlPoint2: CGPoint(x: centerWidth + 8, y: 0))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        }else {
            path.addLine(to: CGPoint(x: centerWidth - height*2.5, y: 0))
            path.addCurve(to: CGPoint(x: centerWidth, y: -21), controlPoint1: CGPoint(x: centerWidth - 11, y: 0), controlPoint2: CGPoint(x: centerWidth - 30, y: -19))
            path.addCurve(to: CGPoint(x: centerWidth + height*2.5, y: 0), controlPoint1: CGPoint(x: centerWidth + 29, y: -19), controlPoint2: CGPoint(x: centerWidth + 11, y: 0))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        }
        path.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
        path.close()
        return path.cgPath
    }
}
