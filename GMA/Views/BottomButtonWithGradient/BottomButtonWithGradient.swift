//
//  BottomButtonWithGradient.swift
//  GMA
//
//  Created by Hoan Nguyen on 07/06/2022.
//

import Foundation
import UIKit


protocol BottomButtonDelegate {
    func buttonDidTapped(button: UIButton)
}

class BottomButtonWithGradient : BaseCustomView {
    var delegate: BottomButtonDelegate?
    @IBOutlet var gradienView: UIView!
    @IBOutlet var button: UIButton!
    var gradienLayer : CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.accessibilityIdentifier = "bottomButton"
        self.button.setCommonStyle()
        self.button.backgroundColor = Colors.greenBackground
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
        if gradienLayer == nil {
            gradienLayer =  self.gradienView.addGradientSeparator(direction: .Bottom2Top)
        }
        gradienLayer?.frame = CGRect(x: 0.0, y: 0.0, width: self.gradienView.frame.size.width, height: self.gradienView.frame.size.height)
    }
    
    
    @IBAction func buttonTapped(sender: UIButton) {
        self.delegate?.buttonDidTapped(button: sender)
    }
    
}
