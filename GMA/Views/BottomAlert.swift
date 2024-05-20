//
//  BottomAlert.swift
//  GMA
//
//  Created by Hoan Nguyen on 26/05/2022.
//

import Foundation
import UIKit


class BottomAlert : UIView {
    var iconImageView : UIImageView!
    var lblMessage: UILabel!

    private var closeGesture : UITapGestureRecognizer?
    
    private var message: String!
    private var icon: UIImage?
    
    init(message: String, icon: UIImage?) {
        super.init(frame: .zero)
        self.message = message
        self.icon = icon
        setupUIComponents()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIComponents()
    }
    required init?(coder: NSCoder) {
        fatalError("Fatal Error")
    }
    
    private func setupUIComponents(){
        self.backgroundColor = Colors.creamBackground
        lblMessage = {
            let label = UILabel()
            label.text = ""
            label.numberOfLines = 0
            label.backgroundColor = Colors.clear
            label.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
            label.textColor = Colors.headerTitle
            label.attributedText = self.message.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.blueBackground, lineSpacing: 0)
            label.textAlignment = .left
            return label
        }()
        self.addSubview(lblMessage)
        var bottomPadding = 40.0
//        if MainTabbarController.shared.tabBar.isHidden {
//            bottomPadding = 20.0
//        }
        if let iconIm = self.icon {
            iconImageView = {
                let img = UIImageView()
                img.contentMode = .scaleAspectFill
                img.clipsToBounds = true
                img.backgroundColor = Colors.clear
                img.image = iconIm
                return img
            }()
            self.addSubview(iconImageView)
            iconImageView.setupConstraints(top: nil, leading: self.leadingAnchor, bottom: nil, trailing: nil, withPadding: .init(top: 20, left: 15, bottom: 0, right: 15), size: .init(width: 20, height: 20))
            lblMessage.setupConstraints(top: self.topAnchor, leading: self.iconImageView.trailingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, withPadding: .init(top: 20, left: 15, bottom: bottomPadding, right: 20))
            iconImageView.centerYAnchor.constraint(equalTo: self.lblMessage.centerYAnchor).isActive = true
        }else {
            lblMessage.setupConstraints(top: self.topAnchor, leading: self.self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, withPadding: .init(top: 20, left: 20, bottom: bottomPadding, right: 20))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let view = self.superview {
            self.closeGesture = UITapGestureRecognizer(target: self, action: #selector(closeMessage))
            view.addGestureRecognizer(self.closeGesture!)
        }
    }
    
    @objc func closeMessage() {
        if let tapdk = self.closeGesture {
            self.superview?.removeGestureRecognizer(tapdk)
        }
        self.removeFromSuperview()
    }
    
    static func show(message: String = "", icon: UIImage?, inView: UIView, bottomAnchor: NSLayoutYAxisAnchor) {
        let msgView = BottomAlert(message: message, icon: icon)
        inView.addSubview(msgView)
        
        msgView.setupConstraints(top: nil, leading: inView.leadingAnchor, bottom: bottomAnchor, trailing: inView.trailingAnchor)
    }
}
