//
//  BaseWithBlurViewController.swift
//  GMA
//
//  Created by Saven Developer on 1/24/22.
//

import Foundation
import UIKit

class BaseWithBlurViewController: BaseViewController{
    
    private var backgroundImage: UIImageView!
    private var backBarButton: UIButton!
    private var rightBarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarItems()
    }
    
    func setNavBarItems(){
        
    }
    
    override func setupUI(){
        super.setupUI()
        backgroundImage = {
            let imageView = UIImageView(frame: UIScreen.main.bounds)
            imageView.image = UIImage(named: "splash")
            imageView.contentMode = .scaleToFill
            imageView.addBlur(blurStyle: .systemChromeMaterialDark)
            return imageView
        }()
        view.insertSubview(backgroundImage, at: 0)
    }
    
   
}

