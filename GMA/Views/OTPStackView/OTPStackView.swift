//
//  OTPStackVie.swift
//  GMA
//
//  Created by Saven Developer on 1/27/22.
//

import Foundation
import UIKit


protocol OTPDelegate: AnyObject {
    func didChangeValidity(isValid: Bool, otpText: String?)
}


class OTPStackView: UIStackView {
    
    //Customise the OTPField here
    let numberOfFields = 6
    var textFieldsCollection: [OTPTextField] = []
    weak var delegate: OTPDelegate?
    var remainingStrStack: [String] = []
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        addOTPFields()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //Customisation and setting stackView
    private final func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 10
    }
    
    //Adding each OTPfield to stack view
    private final func addOTPFields() {
        for index in 0..<numberOfFields{
            let field = OTPTextField()
            field.accessibilityIdentifier = "otpField"
            setupTextField(field)
            textFieldsCollection.append(field)
            //Adding a marker to previous field
            index != 0 ? (field.previousTextField = textFieldsCollection[index-1]) : (field.previousTextField = nil)
            //Adding a marker to next field for the field at index-1
            index != 0 ? (textFieldsCollection[index-1].nextTextField = field) : ()
        }
        textFieldsCollection[0].becomeFirstResponder()
    }
    
    //Customisation and setting OTPTextFields
    private final func setupTextField(_ textField: OTPTextField){
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 50).isActive = true
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = false
        textField.font = UIFont(name: Fonts.regularFont, size: 34)
        textField.textColor = Colors.placeholderTextColor
        textField.backgroundColor = UIColor.clear
        textField.addBorderWithDarkAtBottom(color: Colors.navigationBarTitle)
        textField.keyboardType = .numberPad
        textField.autocorrectionType = .yes
        textField.tintColor = .white
        textField.textContentType = .oneTimeCode
    }
    
    //checks if all the OTPfields are filled
    private final func checkForValidity(){
        var OTP = ""
        for textField in textFieldsCollection{
            if (textField.text == ""){
                delegate?.didChangeValidity(isValid: false, otpText: nil)
                return
            }
            OTP += textField.text ?? ""
        }
        delegate?.didChangeValidity(isValid: true, otpText: OTP)
    }
    
    // it gives the OTP text
    final func getOTP() -> String {
        var OTP = ""
        for textField in textFieldsCollection{
            OTP += textField.text ?? ""
        }
        return OTP
    }

    
    //autofill textfield starting from first
    private final func autoFillTextField(with string: String) {
        remainingStrStack = string.reversed().compactMap{String($0)}
        for textField in textFieldsCollection {
            if let charToAdd = remainingStrStack.popLast() {
                textField.text = String(charToAdd)
            } else {
                break
            }
        }
        checkForValidity()
        remainingStrStack = []
    }
    
}

//MARK: - TextField Handling
extension OTPStackView: UITextFieldDelegate {
        
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForValidity()
    }
    
    //switches between OTPTextfields
       func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange,
                      replacementString string: String) -> Bool {
           guard let textField = textField as? OTPTextField else { return true }
           if string.count > 1 {
               textField.resignFirstResponder()
               autoFillTextField(with: string)
               return false
           } else {
               if (range.length == 0 && string == ""){
                   return false
               }else if (range.length == 0){
                   if textField.nextTextField == nil {
                       textField.text? = string
                       textField.resignFirstResponder()
                   }else{
                       textField.text? = string
                       textField.nextTextField?.becomeFirstResponder()
                   }
                   return false
               }
               return true
           }
       }
    
}
