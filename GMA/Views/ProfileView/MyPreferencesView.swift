//
//  MyPreferencesView.swift
//  GMA
//
//  Created by Saven Developer on 2/23/22.
//

import Foundation
import UIKit

protocol PreferenceDelegate: AnyObject{
    func didTapOnPreferences()
}

class MyPreferencesView: UIView{
    
    private var baseView: UIView!
    private var imgView: UIImageView!
    var prefLabel: UILabel!
    private var arrowImgView: UIImageView!
    
    weak var preferenceDelegate: PreferenceDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIComponents()
    }
    required init?(coder: NSCoder) {
        fatalError("Fatal Error")
    }
    
    private func setupUIComponents(){
        baseView = {
            let view = UIView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            view.addGestureRecognizer(tap)
            view.backgroundColor = Colors.blueBackground
            view.layer.cornerRadius = 15
            return view
        }()
        self.addSubview(baseView)
        baseView.setupConstraints(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        imgView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "myPrefrence")
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
            imgView.tintColor = Colors.placeholderTextColor
            return imgView
        }()
        arrowImgView = {
            let imgView = UIImageView()
            imgView.image = UIImage(systemName: "chevron.right")
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
            imgView.tintColor = Colors.placeholderTextColor
            return imgView
        }()
        prefLabel = {
            let label = UILabel()
            label.font = UIFont(name: Fonts.mediumFont, size: Sizes.prefTitle)
            label.textColor = Colors.navigationBarTitle
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.textAlignment = .left
            return label
        }()
        
        [imgView, arrowImgView, prefLabel].forEach({baseView.addSubview($0)})
        imgView.setupConstraints(top: baseView.topAnchor, leading: baseView.leadingAnchor, bottom: nil, trailing: nil, withPadding: .init(top: 10, left: 20, bottom: 10, right: 10), size: .init(width: 60, height: 60))
        imgView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor).isActive = true
        arrowImgView.setupConstraints(top: baseView.topAnchor, leading: nil, bottom: nil, trailing: baseView.trailingAnchor, withPadding: .init(top: 10, left: 20, bottom: 10, right: 20), size: .init(width: 15, height: 15))
        arrowImgView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor).isActive = true
        prefLabel.setupConstraints(top: baseView.topAnchor, leading: imgView.trailingAnchor, bottom: nil, trailing: arrowImgView.leadingAnchor, withPadding: .init(top: 10, left: 15, bottom: 10, right: 20), size: .init(width: 0, height: 40))
        prefLabel.centerYAnchor.constraint(equalTo: baseView.centerYAnchor).isActive = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if let delegate = preferenceDelegate{
            delegate.didTapOnPreferences()
        }
    }
}
