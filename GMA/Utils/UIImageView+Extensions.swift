//
//  UIImageView+Extensions.swift
//  GMA
//
//  Created by Hoan Nguyen on 17/03/2022.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func setImageURL(urlString: String?, placeholderURL: String? = nil) {
        if let imageUrl = urlString?.removingPercentEncoding?.addingPercentEncoding (withAllowedCharacters: .urlQueryAllowed), !imageUrl.isEmpty, let urlImg = NSURL(string: imageUrl){
            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.sd_setImage(with: urlImg as URL, placeholderImage: nil , options: SDWebImageOptions(rawValue: 0)) { (image, error, cacheType, url) in
                if error != nil{
                    print(error as Any)
                    if let placeholder = placeholderURL {
                        self.setImageURL(urlString: placeholder)
                    }
                    return
                }
            }
        }else if let placeholder = placeholderURL {
            self.setImageURL(urlString: placeholder)
        }
    }
}
