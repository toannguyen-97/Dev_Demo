//
//  UITableViewHeaderFooterView+Extensions.swift
//  GMA
//
//  Created by dat.tran on 1/10/24.
//

import Foundation
import UIKit

extension UITableViewHeaderFooterView {

    static var nib : UINib {
        UINib(nibName: String(describing: self),bundle: .main)
    }
    static var identifier:String {
        String(describing: self)
    }
}
