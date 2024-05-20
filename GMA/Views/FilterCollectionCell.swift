//
//  RequestFilterCollectionCell.swift
//  GMA
//
//  Created by Saven Developer on 5/24/22.
//

import Foundation
import UIKit

class FilterCollectionCell: UICollectionViewCell{
    
    var label: UILabel!
    
    var itemName: String?{
        didSet{
            if let title = itemName{
                DispatchQueue.main.async { [weak self] in
                    if let self = self{
                        self.label.text = title
                    }
                }
            }
        }
    }
    
    var cellSelected: Bool = false {
        didSet {
            if cellSelected{
                self.label.backgroundColor = Colors.blueBackground
                self.label.textColor = Colors.navigationBarTitle
            } else {
                self.label.backgroundColor = Colors.navigationBarTitle
                self.label.textColor = Colors.blueBackground
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUIComponents(){
        label = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
            label.textColor = Colors.blueBackground
            label.layer.borderWidth = 1.0
            label.clipsToBounds = true
            label.layer.masksToBounds = true
            label.layer.cornerRadius = self.frame.size.height/2
            label.layer.borderColor = Colors.blueBackground.cgColor
            label.accessibilityIdentifier = "FilterCellLabel"
            return label
        }()
        contentView.addSubview(label)
        label.fillWithSuperView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
