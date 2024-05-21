//
//  UICollectionViewCell+Extensions.swift
//  GMA
//
//  Created by dat.tran on 1/10/24.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    
    static var className: String {
        String(describing: self)
    }
    
    static var nib : UINib {
        UINib(nibName: String(describing: self),bundle: .main)
    }
    static var identifierString:String {
        String(describing: self)
    }
    
    static func getBaseCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> Self {
        collectionView.register(UINib(nibName: String(describing: self), bundle: nil),
                                forCellWithReuseIdentifier: String(describing: self))
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: self), for: indexPath) as? Self
        return cell ?? .init()
    }
}
