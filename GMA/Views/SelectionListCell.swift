//
//  SelectionListCell.swift
//  GMA
//
//  Created by Hoan Nguyen on 07/06/2022.
//

import UIKit

class SelectionListCell: UITableViewCell {
    var cmsCustomInvalidValueString = ""
    var cmsCustomEmptyString = ""
    var cmsCustomUnit = "" {
        didSet {
            self.lblDistanceUnit.text = "\(cmsCustomUnit)  "
        }
    }
    var cmsaApplyString = ""  {
        didSet {
            btnCustomDistace.setTitle(cmsaApplyString, for: .normal)
        }
    }
    
    var applyCustomValueClosure:((_ customeValue:String)-> Void)?
    @IBOutlet private var lblTitle: UILabel!
    @IBOutlet private var checkImg: UIImageView!
    
    @IBOutlet private var customDistanceView: UIView!
    @IBOutlet private var btnCustomDistace: UIButton!
    @IBOutlet var tfCustomDistance: UITextField!
    var lblDistanceUnit: UILabel!
    var customValueEnable = false
    var titleString: String = "" {
        didSet {
            self.lblTitle.text = titleString
        }
    }
    
    var cellSelected: Bool = false {
        didSet {
            self.checkImg.isHidden = !cellSelected
            if cellSelected && customValueEnable {
                self.customDistanceView.isHidden = false
            }else {
                self.customDistanceView.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.checkImg.accessibilityIdentifier = "checkIcon"
        selectionStyle = .none
        self.checkImg.isHidden = true
        self.lblTitle.textColor = Colors.blueBackground
        self.lblTitle.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
        self.lblTitle.accessibilityIdentifier = "SortFilterListCellLabel"
        
        self.tfCustomDistance.addBorderWithDarkAtBottom(color: Colors.blueBackground)
        self.tfCustomDistance.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        self.tfCustomDistance.keyboardType = .numberPad
        self.tfCustomDistance.textColor = Colors.blackBackground
        self.tfCustomDistance.addTarget(self, action: #selector(textfieldDidChange(sender:)) , for: .editingChanged)
        
        lblDistanceUnit = UILabel()
        lblDistanceUnit.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        lblDistanceUnit.textColor = Colors.headerTitle
        lblDistanceUnit.text = "km  "
        self.tfCustomDistance.rightViewMode = .always
        self.tfCustomDistance.rightView = lblDistanceUnit
        
        self.btnCustomDistace.layer.cornerRadius = 12.0
        self.btnCustomDistace.backgroundColor = Colors.greenBackground
        self.btnCustomDistace.titleLabel?.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
        self.btnCustomDistace.setTitleColor(Colors.blueBackground, for: .normal)
    }
    
    @objc func textfieldDidChange(sender: UITextField) {
        sender.hideError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.checkImg.isHidden = true
    }
    
    @IBAction func applyTapped(sender: UIButton) {
        if self.tfCustomDistance.text!.isEmpty {
            self.tfCustomDistance.showErrorMessage(message: cmsCustomEmptyString)
        }else if self.tfCustomDistance.text == "0" {
            self.tfCustomDistance.showErrorMessage(message: cmsCustomInvalidValueString)
        }else {
            self.applyCustomValueClosure?(self.tfCustomDistance.text!)
        }
    }
    
}
