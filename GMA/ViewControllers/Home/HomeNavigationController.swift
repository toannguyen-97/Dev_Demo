//
//  HomeNavigationController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//

import UIKit

class HomeNavigationController: UINavigationController {

    override func loadView() {
        super.loadView()
        self.setCommomNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.blueBackground]
        let homeScreen = HomeViewController(nibName: "HomeViewController", bundle: nil)
        self.setViewControllers([homeScreen], animated: false)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
