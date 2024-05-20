//
//  UITableView.swift
//  GMA
//
//  Created by Hoan Nguyen on 18/03/2022.
//

import Foundation
import UIKit

extension UITableView {

    func setEmptyMessage(_ message: String, withBottomIcon:Bool = false, withTopIcon:Bool = true) {
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        backgroundView.backgroundColor = UIColor.clear
        let icon = UIImageView(image: UIImage(named: "img_no_results"))
        backgroundView.addSubview(icon)
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width - 40, height: self.bounds.size.height - 40))
        backgroundView.addSubview(messageLabel)
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.center = backgroundView.center
        messageLabel.textColor = Colors.headerTitle
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        messageLabel.attributedText = message.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.headerTitle, lineSpacing: 0)
        messageLabel.sizeToFit()
        messageLabel.textAlignment = .center
        self.backgroundView = backgroundView
        self.separatorStyle = .none
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 40).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -40).isActive = true

        icon.setupConstraints(top: nil, leading: nil, bottom: messageLabel.topAnchor, trailing: nil, withPadding: UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0), size: CGSize.zero)
        icon.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        icon.isHidden = !withTopIcon
        if withBottomIcon {
            let bottomIcon = UIImageView(image: UIImage(named: "arrow_down"))
            backgroundView.addSubview(bottomIcon)
            bottomIcon.setupConstraints(top: nil, leading: nil, bottom: backgroundView.bottomAnchor, trailing: nil, withPadding: UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0), size: CGSize.zero)
            bottomIcon.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        }
    }

    func restoreEmptyView() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
