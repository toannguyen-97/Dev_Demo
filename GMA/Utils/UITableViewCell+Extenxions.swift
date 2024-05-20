//
//  UITableViewCell+Extenxions.swift
//  GMA
//
//  Created by dat.tran on 1/10/24.
//

import Foundation
import UIKit

extension UITableViewCell{
    static var className: String {
        String(describing: self)
    }
    
    static var nib : UINib {
        UINib(nibName: String(describing: self),bundle: .main)
    }
    static var identifierString:String {
        String(describing: self)
    }
    
    static func getBaseCell(_ tableView: UITableView) -> Self {
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: self)) as? Self
        if cell == nil {
            tableView.register(UINib(nibName: String(describing: self), bundle: nil),
                               forCellReuseIdentifier: String(describing: self))
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: self)) as? Self
        }
        return cell ?? .init()
    }
}
