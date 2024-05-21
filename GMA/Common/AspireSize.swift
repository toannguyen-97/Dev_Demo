//
//  AspireSize.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/13/22.
//

import Foundation
import UIKit

var SCREEN_SCALE = (UIScreen.main.bounds.size.width/414.0 > 1) ? UIScreen.main.bounds.size.width/414.0 : 1
var SCREEN_HEIGHT_SCALE = UIScreen.main.bounds.size.height/896.0

enum  Sizes {
    
    static let titleGreeting = 48.0 * SCREEN_SCALE
    static let titleText =  17.0 * SCREEN_SCALE
    static let descriptionText = 16.0 * SCREEN_SCALE
    static let headerText = 14.0 * SCREEN_SCALE
    static let subHeaderText = 13.0 * SCREEN_SCALE
    static let tabbarTitleText = 10.0 * SCREEN_SCALE
    static let prefTitle = 24.0 * SCREEN_SCALE
    static let profileTitle = 34.0 * SCREEN_SCALE
    static let miniHeaderText = 12.0 * SCREEN_SCALE
    
    static let paragraphLineSpacing:CGFloat = 5.0
    
}



