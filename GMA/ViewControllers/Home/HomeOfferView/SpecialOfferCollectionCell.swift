//
//  SpecialOfferCollectionCell.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//



import UIKit

class SpecialOfferCollectionCell: UICollectionViewCell {
    @IBOutlet private var shadowView: UIView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var imageView: BlueGradientImageView!
    @IBOutlet private var btnOffer: UIButton!
    @IBOutlet private var lblTitle: UILabel!
    @IBOutlet private var lblLocation : UILabel!
    @IBOutlet private var lblDescription: UILabel!
    @IBOutlet private var descriptionView: UIView!
    
    var kenticoDic : [String: Any]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        setText()
        self.setAccessibilityID()
    }
    
    private func setAccessibilityID() {
        self.imageView.accessibilityIdentifier = "SpecialOfferCollectionCellimageView"
        self.btnOffer.accessibilityIdentifier = "SpecialOfferCollectionCellbtnOffer"
        self.lblTitle.accessibilityIdentifier = "SpecialOfferCollectionCelllblTitle"
        self.lblLocation.accessibilityIdentifier = "SpecialOfferCollectionCelllblLocation"
        self.lblDescription.accessibilityIdentifier = "SpecialOfferCollectionCelllblDescription"
        self.descriptionView.accessibilityIdentifier = "SpecialOfferCollectionCelldescriptionView"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.setImageURL(urlString: nil)
    }
    
//    var topic:ContentTopic? {
//        didSet {
//            if let topicData = topic {
//                if let name = topicData.attributes?.name{
//                    if name.contains("Offer") {
//                        let title = name.replacingOccurrences(of: "Offer", with: "")
//                        self.lblTitle.attributedText = title.toAttributeStringWith(fontName: Fonts.mediumFont, fontSize: Sizes.profileTitle, color: Colors.navigationBarTitle, lineSpacing: 0)
//                    }else {
//                        self.lblTitle.attributedText = name.toAttributeStringWith(fontName: Fonts.mediumFont, fontSize: Sizes.profileTitle, color: Colors.navigationBarTitle, lineSpacing: 0)
//                    }
//                }
//                if let des = topicData.attributes?.shortDescription, !des.isEmpty {
//                    self.lblDescription.attributedText = des.htmlAttributedString(font: Fonts.regularFont, size: Sizes.titleText)
//                } else if let ades = topicData.attributes?.attributesDescription {
//                    self.lblDescription.attributedText = ades.htmlAttributedString(font: Fonts.regularFont, size: Sizes.titleText)
//                }
//                self.imageView.setImageURL(urlString: topicData.attributes?.image1URL, placeholderURL: ExploreHepler.share.getDefaultImage(data: topicData))
//                if let title = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app_home_offers.elements.cta_label.value") as? String {
//                    self.btnOffer.setTitle("\(title)   ", for: .normal)
//                }
//                if let lName = locationName, let perkType = topicData.attributes?.perkContentType?.first {
//                    self.lblLocation.attributedText = ExploreHepler.share.categoryInCityStringFromCMS(kenticoDic: self.kenticoDic, category: perkType, city: lName).toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.placeholderTextColor, lineSpacing: 0)
//                }
//                self.lblDescription.lineBreakMode = .byTruncatingTail
//            }
//        }
//    }
    
//    var locationName : String? {
//        didSet{
//            if let lName = locationName {
//                self.lblLocation.text = "Dining in \(lName)"
//            }
//        }
//    }
    
    private func descriptionViewAddBlur() {
        self.descriptionView.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.bounds
        self.descriptionView.insertSubview(visualEffectView, at: 0)
        visualEffectView.setupConstraints(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, withPadding: .zero, size: .zero)
    }
    
    func setupUI() {
        // shadow
        self.shadowView.backgroundColor = Colors.navigationBarTitle
        self.shadowView.layer.shadowColor = Colors.black.cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.shadowView.layer.shadowOpacity = 0.6
        self.shadowView.layer.shadowRadius = 5.0
    
        self.containerView.layer.cornerRadius = 12
        self.containerView.clipsToBounds = true
        self.descriptionView.layer.cornerRadius = 12
        self.descriptionView.clipsToBounds = true
//        self.descriptionViewAddBlur()
        self.descriptionView.backgroundColor = Colors.grayTransparent.withAlphaComponent(0.4)
        
        self.btnOffer.backgroundColor = Colors.navigationBarTitle
        self.btnOffer.layer.cornerRadius = self.btnOffer.frame.size.height/2
        self.btnOffer.setTitleColor(Colors.blueBackground, for: .normal)
        self.btnOffer.isUserInteractionEnabled = false
        self.btnOffer.titleLabel?.font = UIFont(name: Fonts.mediumFont, size: Sizes.headerText)
        
        self.lblTitle.textColor = Colors.navigationBarTitle
        self.lblTitle.backgroundColor = UIColor.clear
        self.lblTitle.font = UIFont(name: Fonts.mediumFont, size: Sizes.profileTitle)
        
        self.lblLocation.textColor = Colors.placeholderTextColor
        self.lblLocation.backgroundColor = UIColor.clear
        self.lblLocation.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        
        self.lblDescription.textColor = Colors.navigationBarTitle
        self.lblDescription.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        self.lblDescription.backgroundColor = UIColor.clear
    }
    
    func setText() {
        self.btnOffer.setTitle("Special Offer   ", for: .normal)
        self.lblDescription.attributedText = "Complimentary Signature Garlic Bread Appetizer for the Table delivered by the Chef".toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.navigationBarTitle, lineSpacing: 0)
        self.lblTitle.text = "Station"
        self.lblLocation.text = "Dining in New York"
    }

}
