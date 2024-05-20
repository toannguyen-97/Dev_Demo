//
//  NewPasswordCreatedViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//

import Foundation
import UIKit

class NewPasswordCreatedViewController: BaseWithBlurViewController{
    var forceChangePassword: Bool = false
    private var backgroundView: UIView!
    private var logoImageView: UIImageView!
    private var verifyAccountLabel: UILabel!
    private var textLabel: UILabel!
    private var verifyButton: UIButton!
    var isChangePassword = false
    //CMS String
    var cmsBackToSigninString = "Go Back to Sign In"
    var cmsBackToProfile = "Go Back to Profile"
    var cmsGoToHomeScreen = "Go to Home Screen"
    var cmsPasswordChangedString = "Your password has been successfully changed"
    var cmsSigninWithNewPasswordString = "Sign in using your new password."
    var cmsNewPasswordCreatedString = "New password \ncreated!"
    
    
    override func viewDidLoad() {
        if isChangePassword {
            self.kenticoCodeName = "app___more"
        }else {
            self.kenticoCodeName = "app___forgot_password"
        }
        
        self.kenticoDepth = 3
        super.viewDidLoad()
        view.backgroundColor = isChangePassword ? Colors.navigationBarTitle : Colors.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func setText() {
        super.setText()
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___reset_password_successful.elements.cta_text1.value") as? String {
            cmsBackToSigninString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___reset_password_successful.elements.description.value") as? String {
            cmsNewPasswordCreatedString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___forgot_password_successful.elements.description.value") as? String {
            cmsSigninWithNewPasswordString = str
        }
        // change password
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___change_password_successfully.elements.description.value") as? String {
            cmsPasswordChangedString = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___reset_password_successful.elements.cta_text2.value") as? String {
            cmsBackToProfile = str
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___reset_password_successful.elements.cta_text3.value") as? String {
            cmsGoToHomeScreen = str
        }
        
//        if self.forceChangePassword {
//            verifyButton.setTitle(cmsGoToHomeScreen, for: .normal)
//        }else {
            verifyButton.setTitle(cmsBackToSigninString, for: .normal)
//        }
//        profileButton.setTitle(cmsBackToProfile, for: .normal)
        textLabel.attributedText = isChangePassword ? cmsPasswordChangedString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.headerTitle, lineSpacing: 5) : cmsSigninWithNewPasswordString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: UIColor(named: "whiteTextColor")!, lineSpacing: 5)
        verifyAccountLabel.attributedText = cmsNewPasswordCreatedString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleGreeting, color: isChangePassword ? Colors.blueBackground : Colors.navigationBarTitle, lineSpacing: 2)
    }
    
    override func setupUI() {
        super.setupUI()
        backgroundView = {
            let view = UIView()
            view.backgroundColor = Colors.navigationBarTitle
            return view
        }()
        view.addSubview(backgroundView)
        backgroundView.fillWithSuperView()
        logoImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "Image_lock")?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = isChangePassword ? Colors.blueBackground : Colors.navigationBarTitle
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            return imageView
        }()
        
        verifyButton = {
            let button = UIButton()
            button.setTitle(cmsBackToSigninString, for: .normal)
            button.addTarget(self, action: #selector(action_goToSignIn), for: .touchUpInside)
            button.setCommonButtonStyle()
            return button
        }()
        
        textLabel = {
            let label = UILabel()
            label.attributedText = isChangePassword ? cmsPasswordChangedString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.headerTitle, lineSpacing: 5) : cmsSigninWithNewPasswordString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: UIColor(named: "whiteTextColor")!, lineSpacing: 5)
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            return label
        }()
        
        verifyAccountLabel = {
            let label = UILabel()
            label.attributedText = cmsNewPasswordCreatedString.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleGreeting, color: isChangePassword ? Colors.blueBackground : Colors.navigationBarTitle, lineSpacing: 2)
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            return label
        }()
        
        [logoImageView, verifyButton, textLabel, verifyAccountLabel].forEach({view.addSubview($0)})
        
        logoImageView.setupConstraints(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, withPadding: .init(top: 140, left: 0, bottom: 0, right: 0), size: .init(width: 200, height: 200))
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        verifyButton.setupConstraints(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, withPadding: .init(top: 0, left: 25, bottom: 45, right: 25), size: .init(width: 0, height: 60*SCREEN_HEIGHT_SCALE))
        textLabel.setupConstraints(top: nil, leading: view.leadingAnchor, bottom: verifyButton.topAnchor, trailing: view.trailingAnchor, withPadding: .init(top: 10, left: 25, bottom: 60, right: 25), size: .init(width: 0, height: 0))
        verifyAccountLabel.setupConstraints(top: nil, leading: view.leadingAnchor, bottom: textLabel.topAnchor, trailing: view.trailingAnchor, withPadding: .init(top: 0, left: 25, bottom: 25, right: 25), size: .init(width: 0, height: 0))
        
        if isChangePassword{
            verifyButton.backgroundColor = Colors.greenBackground
            backgroundView.isHidden = false
        }else{
            backgroundView.isHidden = true
        }
    }
    
    @objc func action_goToSignIn(){
        CurrentSession.share.logout()
        let email = CurrentSession.share.oktaProfile?.profile.email
        let signInVC = SignInViewController()
//        signInVC.emailString = email
        DispatchQueue.main.async(execute: {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let accessCodeVC = VerifyAccessCodeViewController(nibName: "VerifyAccessCodeViewController", bundle: nil)
            let navController = UINavigationController(rootViewController: accessCodeVC)
            navController.setTranparent()
            appDelegate?.window!.rootViewController = navController
            appDelegate?.window?.makeKeyAndVisible()
            navController.pushViewController(signInVC, animated: false)
        })
    }
}
