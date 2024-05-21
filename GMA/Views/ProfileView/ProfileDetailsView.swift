//
//  ProfileDetailsView.swift
//  GMA
//
//  Created by Saven Developer on 2/23/22.
//

import Foundation
import UIKit

protocol profileDetailsDelegate: AnyObject{
    func didTapOnEditButton()
    func didTapOnVerifyPhoneNumber()
}

class ProfileDetailsView: BaseCustomView{
    
    private var baseView: UIView!
    private var editButton: UIButton!
    private var nameLabel: UILabel!
    private var emailLabel: UILabel!
    private var mobileLabel: UILabel!
    private var verifyNumberLabel: UIButton!
    
    weak var profileDelegate: profileDetailsDelegate!
    
    var aspireProfile: AspireProfile? {
        didSet{
            if let profile = aspireProfile{
                DispatchQueue.main.async { [weak self] in
                    if let self = self{
                        if let fname = profile.firstName, let lname = profile.lastName {
                            self.nameLabel.text = fname + " " + lname
                        }
                        if let email = profile.emails?.first?.emailAddress{
                            self.emailLabel.text = email
                        }
                        if let phone = profile.phones?.first , let code = phone.phoneCountryCode , let number = phone.phoneNumber{
                            self.mobileLabel.text = code + " " + number
                        }
                    }
                }
            }
        }
    }
    
    var isPhoneNumberUpdated: Bool? {
        didSet{
            if let isVerified = isPhoneNumberUpdated{
                if isVerified{
                    DispatchQueue.main.async { [weak self] in
                        if let self = self{
                            self.verifyNumberLabel.isHidden = false
                        }}
                }else{
                    DispatchQueue.main.async { [weak self] in
                        if let self = self{
                            self.verifyNumberLabel.isHidden = true
                        }}
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("Fatal Error")
    }
    
    override func commonInit(for customViewName: String) -> UIView {
        return self
    }
    
    override func setText(dic: [String : Any]) {
        super.setText(dic: dic)
        if let buttonTitle = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___more_account_verification.elements.cta_text1.value") as? String{
            let attributedText = NSMutableAttributedString(attributedString: buttonTitle.toAttributeStringWith(fontName: Fonts.mediumFont, fontSize: Sizes.titleText, color: Colors.secondBlueBackground, lineSpacing: 0))
            let range = attributedText.mutableString.range(of: buttonTitle)
            attributedText.addAttribute(.underlineStyle, value: 1, range: range)
            verifyNumberLabel.titleLabel?.textAlignment = .center
            verifyNumberLabel.setAttributedTitle(attributedText, for: .normal)
        }
    }
    
    override func setupUI() {
        super.setupUI()
        baseView = {
            let view = UIView()
            view.backgroundColor = Colors.creamBackground
            return view
        }()
        self.addSubview(baseView)
        baseView.setupConstraints(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        
        editButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "edit"), for: .normal)
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
            button.tintColor = .white
            button.addTarget(self, action: #selector(action_edit), for: .touchUpInside)
            button.backgroundColor = Colors.creamBackground
            button.accessibilityIdentifier = "editButton"
            return button
        }()
        
        nameLabel = {
            let label = UILabel()
            label.font = UIFont(name: Fonts.mediumFont, size: Sizes.profileTitle)
            label.textColor = Colors.blueBackground
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.textAlignment = .center
            label.accessibilityIdentifier = "nameLabel"
            return label
        }()
        
        emailLabel = {
            let label = UILabel()
            label.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
            label.textColor = Colors.blueBackground
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.textAlignment = .center
            label.accessibilityIdentifier = "emailLabel"
            return label
        }()
        
        mobileLabel = {
            let label = UILabel()
            label.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
            label.textColor = Colors.blueBackground
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.textAlignment = .center
            label.accessibilityIdentifier = "mobileNumberLabel"
            return label
        }()
        
        verifyNumberLabel = {
            let button = UIButton()
            button.addTarget(self, action: #selector(action_verifyMobile), for: .touchUpInside)
            button.accessibilityIdentifier = "verifyNumberButton"
            return button
        }()
        
        [editButton, nameLabel, emailLabel, mobileLabel, verifyNumberLabel].forEach({baseView.addSubview($0)})
        
        editButton.setupConstraints(top: baseView.topAnchor, leading: nil, bottom: nil, trailing: baseView.trailingAnchor, withPadding: .init(top: 0, left: 0, bottom: 0, right: 20), size: .init(width: 40, height: 40))
        nameLabel.setupConstraints(top: editButton.bottomAnchor, leading: baseView.leadingAnchor, bottom: nil, trailing: baseView.trailingAnchor, withPadding: .init(top: 1, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 75))
        emailLabel.setupConstraints(top: nameLabel.bottomAnchor, leading: baseView.leadingAnchor, bottom: nil, trailing: baseView.trailingAnchor, withPadding: .init(top: 20, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 20))
        mobileLabel.setupConstraints(top: emailLabel.bottomAnchor, leading: baseView.leadingAnchor, bottom: nil, trailing: baseView.trailingAnchor, withPadding: .init(top: 10, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 20))
        verifyNumberLabel.setupConstraints(top: mobileLabel.bottomAnchor, leading: baseView.leadingAnchor, bottom: nil, trailing: baseView.trailingAnchor, withPadding: .init(top: 10, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 20))

    }
    
    @objc func action_edit(){
        if let delegate = profileDelegate{
            delegate.didTapOnEditButton()
        }
    }
    
    @objc func action_verifyMobile(){
        if let delegate = profileDelegate{
            delegate.didTapOnVerifyPhoneNumber()
        }
    }
}
