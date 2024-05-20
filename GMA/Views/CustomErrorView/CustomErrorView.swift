//
//  CustomErrorView.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/23/22.
//

import Foundation
import UIKit


class CustomErrorView: BaseCustomView {
    
    var textField : UITextField?
    var textView : UITextView?
    var attributeStringAction: (() -> ())?
    var rightButtonAction:(()->())?
    
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var leftView : UIView!
    @IBOutlet private var icon : UIImageView!
    @IBOutlet private var centerView: UIView!
    @IBOutlet private var lblMessage : UILabel!
    @IBOutlet private var rightView : UIView!
    @IBOutlet private var btnAction : UIButton!

    var message:String? {
        didSet{
            if let msg = message {
                self.lblMessage.attributedText = msg.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.headerText, color: Colors.navigationBarTitle, lineSpacing: 0)
            }
        }
    }
    
    var attributeMessage: NSAttributedString? {
        didSet{
            if let attStr = attributeMessage {
                self.lblMessage.attributedText = attStr
            }
        }
    }
    
    var rightButtonTitle:String? {
        didSet{
            if let title = rightButtonTitle {
                self.rightView.isHidden = false
                self.btnAction.setTitle(title, for: .normal)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    
    override func setupUI() {
        super.setupUI()
        self.rightView.isHidden = true
        self.lblMessage.font = UIFont(name: Fonts.regularFont, size: Sizes.headerText)
        self.lblMessage.textColor = Colors.navigationBarTitle
        let tapClose = UITapGestureRecognizer(target: self, action: #selector(close))
        self.addGestureRecognizer(tapClose)
        
        let tapdk = UITapGestureRecognizer(target: self, action: #selector(tapToText))
        self.lblMessage.isUserInteractionEnabled = true
        self.lblMessage.addGestureRecognizer(tapdk)
        self.lblMessage.accessibilityIdentifier = "error message label"
        btnAction.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        btnAction.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func rightButtonAction(sender:UIButton) {
        self.rightButtonAction?()
    }
    
    @objc func tapToText() {
        if self.attributeStringAction == nil {
            self.close()
        }else {
            self.attributeStringAction?()
        }
    }
    @objc func close() {
        DispatchQueue.main.async {
            self.textField?.inputAccessoryView = nil
            self.textField?.reloadInputViews()
            self.textView?.inputAccessoryView = nil
            self.textView?.reloadInputViews()
            if self.tag == 1010101 {
                self.removeFromSuperview()
            }
        }
    }
}

extension UIView {
    private func createErrorView()-> CustomErrorView{
        var barHeight = 80.0
        if UIScreen.main.bounds.size.width <= AppContants.AppSmallScreenWidth {
            barHeight = 60.0
        }
        let errorView = CustomErrorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: barHeight))
        errorView.tag = 1010101
        self.addSubview(errorView)
        return errorView
    }
    
    func showBottomErrorMessage(message:String) {
        DispatchQueue.main.async {
            let errorView = self.createErrorView()
            var barHeight = 80.0
            if UIScreen.main.bounds.size.width <= AppContants.AppSmallScreenWidth {
                barHeight = 60.0
            }
            errorView.setupConstraints(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, withPadding: .zero, size: CGSize(width: 0, height: barHeight))
            errorView.accessibilityIdentifier = "ErrorView"
            errorView.message = message
        }
    }
    
    
    func hideBottomError() {
        DispatchQueue.main.async {
            if let eView = self.viewWithTag(1010101) {
                eView.removeFromSuperview()
            }
        }
    }
}


extension UITextField {
    
    func showErrorMessage(message:String, rightButtonTitle: String? = nil, rightButtonAction:(()->())? = nil) {
        DispatchQueue.main.async {
            let errorView = self.createErrorView()
            errorView.accessibilityIdentifier = "ErrorView"
            errorView.message = message
            if let rTitle = rightButtonTitle {
                errorView.rightButtonTitle = rTitle
                errorView.rightButtonAction = rightButtonAction
            }
        }
    }
    
    func showErrorMessageWithAttributeString(attString:NSAttributedString, attributeStringAction:(@escaping()->())) {
        DispatchQueue.main.async {
            let errorV = self.createErrorView()
            errorV.accessibilityIdentifier = "ErrorView"
            errorV.attributeMessage = attString
            errorV.attributeStringAction = attributeStringAction
        }
    }
    
    
    
    func hideError() {
        DispatchQueue.main.async {
            if self.inputAccessoryView != nil {
                self.inputAccessoryView = nil
                self.reloadInputViews()
            }
        }
    }
    
    private func createErrorView()-> CustomErrorView{
        var barHeight = 80.0
        if UIScreen.main.bounds.size.width <= AppContants.AppSmallScreenWidth {
            barHeight = 60.0
        }
        let errorToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: barHeight))
        let errorView = CustomErrorView(frame: errorToolBar.bounds)
        errorView.textField = self
        errorToolBar.addSubview(errorView)
        self.becomeFirstResponder()
        self.inputAccessoryView = errorToolBar
        self.reloadInputViews()
        return errorView
    }

}

extension UITextView {
    
    func showErrorMessage(message:String, rightButtonTitle: String? = nil, rightButtonAction:(()->())? = nil) {
        DispatchQueue.main.async {
            let errorView = self.createErrorView()
            errorView.accessibilityIdentifier = "ErrorView"
            errorView.message = message
            if let rTitle = rightButtonTitle {
                errorView.rightButtonTitle = rTitle
                errorView.rightButtonAction = rightButtonAction
            }
        }
    }
    
    func showErrorMessageWithAttributeString(attString:NSAttributedString, attributeStringAction:(@escaping()->())) {
        DispatchQueue.main.async {
            let errorV = self.createErrorView()
            errorV.accessibilityIdentifier = "ErrorView"
            errorV.attributeMessage = attString
            errorV.attributeStringAction = attributeStringAction
        }
    }
    
    
    
    func hideError() {
        DispatchQueue.main.async {
            if self.inputAccessoryView != nil {
                self.inputAccessoryView = nil
                self.reloadInputViews()
            }
        }
    }
    
    private func createErrorView()-> CustomErrorView{
        let errorToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80))
        let errorView = CustomErrorView(frame: errorToolBar.bounds)
        errorView.textView = self
        errorToolBar.addSubview(errorView)
        self.becomeFirstResponder()
        self.inputAccessoryView = errorToolBar
        self.reloadInputViews()
        return errorView
    }

}
