//
//  CountryListTableViewCell.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//


import Foundation
import UIKit
import SDWebImage

class CountryListTableViewCell: UITableViewCell{
    
    private var flagImageView: UIImageView!
    private var countryNameLabel: UILabel!
    private var countryCodeLabel: UILabel!
    
    var countryDetail: CountryDetail?{
        didSet{
            if let countryData = countryDetail{
                DispatchQueue.main.async { [weak self] in
                    if let self = self{
                        if let countryName = countryData.countryName{
                            self.countryNameLabel.text = countryName
                        }
                        if let countryCode = countryData.phoneCode{
                            self.countryCodeLabel.text = countryCode
                        }
                        if let urlString = countryData.flag{
                            let imageURL = URL(string: urlString)
                            self.flagImageView?.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "photo"))
                        }
                    }
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUIComponents(){
        contentView.backgroundColor = UIColor(named: "CountryListBgColor")
        flagImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(systemName: "photo")
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
            return imgView
        }()
        countryNameLabel = {
            let label = UILabel()
            label.font = UIFont(name: Fonts.regularFont, size: 17)
            label.textColor = UIColor(named: "textColor")
            label.text = ""
            return label
        }()
        countryCodeLabel = {
            let label = UILabel()
            label.font = UIFont(name: Fonts.regularFont, size: 17)
            label.text = ""
            label.textColor = UIColor(named: "textColor")
            label.textAlignment = .right
            return label
        }()
        [flagImageView, countryNameLabel, countryCodeLabel].forEach({contentView.addSubview($0)})
        flagImageView.setupConstraints(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: nil, withPadding: .init(top: 5, left: 20, bottom: 5, right: 10), size: .init(width: 25, height: 20))
        countryCodeLabel.setupConstraints(top: contentView.topAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, withPadding: .init(top: 5, left: 10, bottom: 5, right: 20), size: .init(width: 80, height: 40))
        countryNameLabel.setupConstraints(top: contentView.topAnchor, leading: flagImageView.trailingAnchor, bottom: contentView.bottomAnchor, trailing: countryCodeLabel.leadingAnchor, withPadding: .init(top: 5, left: 10, bottom: 5, right: 10), size: .init(width: 0, height: 40))
    }
}

