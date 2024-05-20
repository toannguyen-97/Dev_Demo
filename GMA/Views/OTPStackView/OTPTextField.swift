//
//  OTPTextField.swift
//  GMA
//
//  Created by Saven Developer on 1/27/22.
//

import Foundation
import UIKit

class OTPTextField: UITextField {
    
    weak var previousTextField: OTPTextField?
    weak var nextTextField: OTPTextField?
    
    override public func deleteBackward(){
        text = ""
        previousTextField?.becomeFirstResponder()
        
    }
}
