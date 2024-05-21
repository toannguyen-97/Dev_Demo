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

class HomeUpcomingView: BaseCustomView {

    var delegate: HomeUpcomingDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        }
}
