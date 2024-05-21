//
//  UINavigationController+ Extensions.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/19/22.
//

import Foundation
import UIKit

extension UINavigationController {
    
    func setTranparent() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.isTranslucent = true
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.titleTextAttributes = [
            .foregroundColor: Colors.navigationBarTitle,
            .font: UIFont(name: Fonts.mediumFont, size: Sizes.titleText) ?? UIFont.systemFont(ofSize: Sizes.titleText)]
        self.navigationBar.barStyle = .black
        self.navigationBar.backgroundColor = Colors.clear
        self.navigationBar.tintColor = Colors.clear
    }
    
    func setCommomNavigationBar() {
        self.interactivePopGestureRecognizer?.delegate = nil
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowImage = UIImage()
        appearance.shadowColor = Colors.clear
        appearance.titleTextAttributes = [
            .foregroundColor: Colors.blueBackground,
            .font: UIFont(name: Fonts.mediumFont, size: Sizes.titleText) ?? UIFont.systemFont(ofSize: Sizes.titleText)]
        appearance.backgroundColor = Colors.navigationBarTitle
        let proxy =  self.navigationBar
        proxy.tintColor = Colors.navigationBarTitle
        proxy.standardAppearance = appearance
        proxy.scrollEdgeAppearance = appearance
        
    }
    
    func commonNavigationToTransparent() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowImage = UIImage()
        appearance.shadowColor = Colors.clear
        appearance.titleTextAttributes = [
            .foregroundColor: Colors.blueBackground,
            .font: UIFont(name: Fonts.mediumFont, size: Sizes.titleText) ?? UIFont.systemFont(ofSize: Sizes.titleText)]
        appearance.backgroundColor = Colors.clear
        let proxy =  self.navigationBar
        proxy.tintColor = Colors.clear
        proxy.standardAppearance = appearance
        proxy.scrollEdgeAppearance = appearance
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
}
