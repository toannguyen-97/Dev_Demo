//
//  CustomNavigationView.swift
//  GMA
//
//  Created by Saven Developer on 4/1/22.
//

import Foundation
import UIKit

protocol CustomNavigationDelegate: AnyObject{
    func didTapOnXmark()
    func didTapOnClearButton()
}

class CustomNavigationView: UIView{
    
    private var baseView: UIView!
    private var xmarkButton: UIButton!
    private var titleLabel: UILabel!
    var clearButton: UIButton!
    
    var title: String?{
        didSet{
            if let tit = title{
                DispatchQueue.main.async { [weak self] in
                    if let self = self{
                        self.titleLabel.attributedText = tit.toAttributeStringWith(fontName: Fonts.mediumFont, fontSize: Sizes.titleText, color: Colors.blueBackground, lineSpacing: 0)
                    }
                }
            }
        }
    }
    
    var isShowClearButton: Bool?{
        didSet{
            if let isShow = isShowClearButton{
                if isShow{
                    DispatchQueue.main.async { [weak self] in
                        if let self = self{
                            self.clearButton.isHidden = false
                        }
                    }
                }else{
                    DispatchQueue.main.async { [weak self] in
                        if let self = self{
                            self.clearButton.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    weak var delegate: CustomNavigationDelegate!
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        setupUIComponents()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("fatal error")
    }
    
    private func setupUIComponents(){
        baseView = {
            let view = UIView()
            return view
        }()
        self.addSubview(baseView)
        baseView.fillWithSuperView()
        xmarkButton = {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 36))
            button.setImage(UIImage(named: "ic_cross_blue"), for: .normal)
            button.addTarget(self, action: #selector(action_xmark), for: .touchUpInside)
            return button
        }()
        
        titleLabel = {
            let label = UILabel()
            label.attributedText = "".toAttributeStringWith(fontName: Fonts.mediumFont, fontSize: Sizes.titleText, color: Colors.blueBackground, lineSpacing: 0)
            label.textAlignment = .center
            return label
        }()
        
        clearButton = {
            let button = UIButton()
            button.clipsToBounds = true
            button.titleLabel?.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
            button.setTitleColor(Colors.secondBlueBackground, for: .normal)
            button.addTarget(self, action: #selector(action_clear), for: .touchUpInside)
            return button
        }()
        
        [xmarkButton, titleLabel, clearButton].forEach({baseView.addSubview($0)})
        
        xmarkButton.setupConstraints(top: baseView.topAnchor, leading: baseView.leadingAnchor, bottom: nil, trailing: nil, withPadding: .init(top: 15, left: 15, bottom: 10, right: 10), size: .init(width: 45, height: 36))
        clearButton.setupConstraints(top: baseView.topAnchor, leading: nil, bottom: nil, trailing: baseView.trailingAnchor, withPadding: .init(top: 20, left: 10, bottom: 10, right: 10), size: .init(width: 60, height: 25))
        titleLabel.setupConstraints(top: baseView.topAnchor, leading: nil, bottom: nil, trailing: nil, withPadding: .init(top: 20, left: 0, bottom: 10, right: 0), size: .init(width: 0, height: 25))
        titleLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
    }
    
    @objc func action_xmark(){
        if let delegate = delegate{
            delegate.didTapOnXmark()
        }
    }

    @objc func action_clear(){
        if let delegate = delegate{
            delegate.didTapOnClearButton()
        }
    }
    
}
