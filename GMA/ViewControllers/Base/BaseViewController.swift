//
//  BaseViewController.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/19/22.
//

import UIKit
import Firebase
import ACProgressHUD_Swift
import OSLog
import FirebaseCrashlytics


class BaseViewController: UIViewController {
    
    var kenticoCodeName: String?
    var kenticoDepth: Int = 2
    var kenticoDic: [String: Any]?
    
    var btnRightItem: UIButton?
    private let logger = Logger(subsystem: "AspireLog", category: "BaseViewController")

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.logger.info("viewWillAppear screen: \(self.classForCoder)")
        Crashlytics.crashlytics().log("on screen: \(self.classForCoder)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: NSNotification.Name(k_LANGUAGE_CHANGE), object: nil)
        self.setupUI()
        self.setText()
        self.loadTextFromCMS()
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.logger.info("viewDidDisappear screen: \(self.classForCoder)")
    }
    private func loadTextFromCMS() {
        if let codeName = self.kenticoCodeName, !codeName.isEmpty {
            KenticoServices().getContent(codeName: codeName, depth: self.kenticoDepth) { result in
                switch result{
                case .success(let dic):
                    self.kenticoDic = dic
                    DispatchQueue.main.async {
                        self.setText()
                    }
                case .failure(let error):
                    Crashlytics.crashlytics().record(error: error)
                    break
                }
                DispatchQueue.main.async {
                    self.loadCMSTextFinish()
                }
            }
        }
    }
    
    deinit{
        self.logger.info("deinit screen: \(self.classForCoder)")
        NotificationCenter.default.removeObserver(self)
    }

    
    @objc func updateLanguage() {
        self.loadTextFromCMS()
    }
    
    func loadCMSTextFinish() {
        
    }
    
    func setupUI() {
        
    }
    
    func setText()  {
        
    }
    
    func createRightBarButtonWithTitle(title:String) {
        let btnRight = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        btnRight.addTarget(self, action: #selector(righBarItemTouch), for: .touchUpInside)
        btnRight.setTitle(title, for: .normal)
        btnRight.setTitleColor(Colors.navigationBarButtonItemTitle, for: .normal)
        btnRight.setTitleColor(Colors.navigationBarButtonItemTitle, for: .highlighted)
        btnRight.titleLabel?.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        let rightItem  = UIBarButtonItem(customView: btnRight)
        self.navigationItem.rightBarButtonItem = rightItem
        self.btnRightItem = btnRight
    }
    
    func createRightBarButtonWithColor(title:String, color: UIColor) {
        let btnRight = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        btnRight.addTarget(self, action: #selector(righBarItemTouch), for: .touchUpInside)
        btnRight.setTitle(title, for: .normal)
        btnRight.setTitleColor(color, for: .normal)
        btnRight.setTitleColor(color, for: .highlighted)
        btnRight.titleLabel?.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        let rightItem  = UIBarButtonItem(customView: btnRight)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    
    
    
    func createBackBarButton() {
        let btnBack = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btnBack.addTarget(self, action: #selector(backViewController), for: .touchUpInside)
        btnBack.setBackgroundImage(UIImage(named: "ic_back"), for: .normal)
        btnBack.setBackgroundImage(UIImage(named: "ic_back_blue"), for: .highlighted)
        let backItem = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    func createBlueBackBarButton() {
        let btnBack = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btnBack.addTarget(self, action: #selector(backViewController), for: .touchUpInside)
        btnBack.setBackgroundImage(UIImage(named: "ic_back_blue"), for: .normal)
        btnBack.setBackgroundImage(UIImage(named: "ic_back_blue"), for: .highlighted)
        let backItem = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    
    @objc func righBarItemTouch() {
        
    }
    
    @objc func backViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func action_logout() {
        let signInVC = SignInViewController()
        if let email = CurrentSession.share.aspireProfile?.emails?.first?.emailAddress {
            signInVC.emailString = email
        }
        CurrentSession.share.logout()
        DispatchQueue.main.async(execute: {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let accessCodeVC = VerifyAccessCodeViewController(nibName: "VerifyAccessCodeViewController", bundle: nil)
            let navController = UINavigationController(rootViewController: accessCodeVC)
            navController.setTranparent()
            appDelegate?.window!.rootViewController = navController
            appDelegate?.window?.makeKeyAndVisible()
            navController.pushViewController(signInVC, animated: false)
        })
        
//        FirebaseTracking.share.logEvent(event: FirebaseEvent.logout, viewController: self, parameter: ["login_stage": "log_out"])
    }
    
    func goToSiginScreenWith(email:String?, fromRegister: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            if let self = self{
                let signInVC = SignInViewController()
                signInVC.emailString = email
                signInVC.isFromRegister = fromRegister
                self.navigationController?.pushViewController(signInVC, animated: true)
            }
        }
    }
    
    func goToMainScreen() {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            if let main = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() {
                appDelegate?.window?.rootViewController = main
                appDelegate?.window?.makeKeyAndVisible()
            }
        }
    }
    
    func noInternetProcess(){
        self.showAlert(withTitle: AppContants.shared.cmsNoInternetTitleSystemString, andMessage: AppContants.shared.cmsNoInternetMessageSystemString, btn1Title: AppContants.shared.cmsOkSystemString, btn2Title: AppContants.shared.cmsSettingSystemString) {
            
        } btn2Action: {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
    }
}

extension BaseViewController {
    
    /** USING :
     self.showAlert(withTitle: "", andMessage: "", btn2Title: "OK", btn1Action:  {
     print("")
     }, btn2Action:  {
     print("")
     })
     */
    public func showAlert(withTitle:String? , andMessage:String?, btn1Title: String? = AppContants.shared.cmsDoneSystemString, btn2Title: String? = nil , btn1Action:(()->Void)? = nil, btn2Action: (()->Void)? = nil) {
        let alertController = UIAlertController(title: withTitle, message: andMessage, preferredStyle: .alert)
        // custom Font
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        if let title = alertController.title, !title.isEmpty{
            let titleAttr = NSMutableAttributedString(attributedString: title.toAttributeStringWith(fontName:Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.blueBackground, lineSpacing:0))
            titleAttr.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: titleAttr.mutableString.length))
            alertController.setValue(titleAttr , forKey: "attributedTitle")
        }
        if let message = alertController.message, !message.isEmpty {
            let messageAttr = NSMutableAttributedString(attributedString: message.toAttributeStringWith(fontName:Fonts.regularFont, fontSize: Sizes.headerText, color: Colors.black, lineSpacing:0))
            messageAttr.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: messageAttr.mutableString.length))
            alertController.setValue(messageAttr , forKey: "attributedMessage")
        }
        
        if let btn1title = btn1Title {
            let fAction = UIAlertAction(title: btn1title, style: .default, handler: { alertAction in
                btn1Action?()
            })
            fAction.setValue(Colors.blueBackground, forKey: "titleTextColor")
            alertController.addAction(fAction)
            fAction.accessibilityIdentifier = "Alert" + btn1title
        }
        
        if let title = btn2Title {
            let sAction = UIAlertAction(title: title, style: .default, handler: { alertAction in
                btn2Action?()
            })
            sAction.accessibilityIdentifier = "Alert"+title
            sAction.setValue(Colors.blueBackground, forKey: "titleTextColor")
            alertController.addAction(sAction)
        }
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}


extension BaseViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.logger.info("viewDidAppear screen: \(self.classForCoder)")
//        FirebaseTracking.share.logScreen(viewController: self)
    }
}
