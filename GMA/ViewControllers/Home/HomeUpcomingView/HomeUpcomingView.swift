//
//  HomeUpcomingView.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//


import Foundation
import UIKit


protocol HomeUpcomingDelegate {
    func upcomingSeeAllRequestDidTapped(upcomingView: HomeUpcomingView)
    func upcomingTapOnCard(upcomingView: HomeUpcomingView, requestItem: RequestItem)
}

class HomeUpcomingView : BaseCustomView {
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var lblTitle: UILabel!
    @IBOutlet private var reservationContainer: UIView!
    @IBOutlet private var btnAllRequest: UIButton!
    var titleStr = "Ironside Fish & Oyster"
    var reservationCard: RequestCell?
    var requestItem: RequestItem? {
        didSet {
//            if let item = requestItem {
//                self.isHidden = false
//                reservationCard?.requestItem = item
//            }else {
//                self.isHidden = true
//            }
        }
    }
    
    var delegate: HomeUpcomingDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setAccessibilityID()
        self.lblTitle.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        self.lblTitle.textColor = Colors.headerTitle
        
        self.btnAllRequest.titleLabel?.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
        self.btnAllRequest.setTitleColor(Colors.secondBlueBackground, for: .normal)
        
        if let reservationCell = Bundle.main.loadNibNamed("RequestCell", owner: self, options: nil)?.first as? RequestCell {
            self.reservationContainer.addSubview(reservationCell)
            reservationCell.fillWithSuperView()
            reservationCard = reservationCell
            let tapdk = UITapGestureRecognizer(target: self, action: #selector(gotoRequestDetail))
            reservationCell.addGestureRecognizer(tapdk)
        }
    }
    
    private func setAccessibilityID() {
        self.lblTitle.accessibilityIdentifier = "MUpcominglblTitle"
        self.reservationCard?.accessibilityIdentifier = "HomeUpcomingReservationCard"
    }
    
    
    override func setText(dic: [String : Any]) {
        super.setText(dic: dic)
        if let titleStr = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___upcoming_activities.elements.title.value") as? String {
            self.lblTitle.attributedText = titleStr.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.headerTitle, lineSpacing: 0)
        }
        if let seeAllString = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___upcoming_activities.elements.cta_label.value") as? String {
            let buttonAttributeString = NSMutableAttributedString(string: seeAllString, attributes: [.font: UIFont(name: Fonts.mediumFont, size: Sizes.titleText)!, .foregroundColor: Colors.secondBlueBackground, .underlineStyle: NSUnderlineStyle.single.rawValue])
            self.btnAllRequest.setAttributedTitle(buttonAttributeString, for: .normal)
        }
        self.reservationCard?.kenticoDic = dic
//        self.reservationCard?.requestItem = self.requestItem
        self.lblTitle.textAlignment = .center
    }
    
    @objc func gotoRequestDetail() {
        self.delegate?.upcomingTapOnCard(upcomingView: self, requestItem: self.requestItem!)
    }
    
    @IBAction func seeAppTapped(sender: UIButton) {
        self.delegate?.upcomingSeeAllRequestDidTapped(upcomingView: self)
    }
    
}
