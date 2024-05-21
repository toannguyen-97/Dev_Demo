//
//  UIViewController+Extensions.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 3/2/22.
//

import Foundation

import UIKit

extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.windows.first?.rootViewController?.topMostViewController()
    }
}
