//
//  ContactViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//

import UIKit

class ContactViewController: BaseViewController {
    @IBOutlet private var btnChat: UIButton!
    @IBOutlet private var btnTalk: UIButton!
    @IBOutlet private var btnClose: UIButton!
    
    //CMS..
    var cmsTalk = "Talk"
    var cmsMessge = "Message"
    var isBookingViaConcierge = false
    
    override func viewDidLoad() {
        self.kenticoCodeName = "app_contact_us_pop_up"
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        [self.btnChat, self.btnTalk].forEach { button in
            button?.titleLabel?.font = UIFont(name: Fonts.mediumFont, size: Sizes.tabbarTitleText)
            button?.setTitleColor(Colors.navigationBarTitle, for: .normal)
        }
        
        self.view.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.bounds
        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.alpha = 1.0
        self.view.insertSubview(visualEffectView, at: 0)
        visualEffectView.setupConstraints(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, withPadding: .zero, size: .zero)
    }
    
    override func setText() {
        super.setText()
        if let dic = kenticoDic{
            if let talk = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app_contact_us_talk.elements.label.value") as? String{
                cmsTalk = talk
            }
            if let message = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___contact_us_message.elements.label.value") as? String{
                cmsMessge = message
            }
        }
        self.btnTalk.setTitle(cmsTalk, for: .normal)
        self.btnChat.setTitle(cmsMessge, for: .normal)
        self.btnChat.centerVertically()
        self.btnTalk.centerVertically()
    }
    
    @IBAction func talk(sender: UIButton) {
        self.dismiss(animated: true) {
            if let supportPhone = CurrentSession.share.programDetail?.phoneNumber {
                UtilServices.shared.callToPhoneNumber(phoneNumber: supportPhone)
                if self.isBookingViaConcierge {
//                    FirebaseTracking.share.logEvent(event: FirebaseEvent.concierge_service, viewController: UIApplication.shared.topMostViewController(), parameter: ["concierge_option": "Call"])
                }
            }
        }
    }
    
    @IBAction func chat(sender: UIButton) {
        self.dismiss(animated: true) {
            if self.isBookingViaConcierge {
//                FirebaseTracking.share.logEvent(event: FirebaseEvent.concierge_service, viewController: UIApplication.shared.topMostViewController(), parameter: ["concierge_option": "chat"])
            }
            MainTabbarController.shared.showChatConversation()
        }
    }
    
    @IBAction func close(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
