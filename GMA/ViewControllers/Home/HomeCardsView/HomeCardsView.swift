//
//  HomeCardsView.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//



import UIKit

protocol HomeCardsDelegate {
    func homeCardDidSelected(homeCardView: HomeCardsView)
}


class HomeCardsView: BaseCustomView {

    @IBOutlet var descritionView: UIView!
    @IBOutlet private var lblDescrition: UILabel!
    
    @IBOutlet private var firstCard: UIView!
    @IBOutlet private var firstCardContentView: UIView!
    @IBOutlet private var firstCardTitle: UILabel!
    @IBOutlet private var firstCardImage: UIImageView!
    
    @IBOutlet private var secondCard: UIView!
    @IBOutlet private var secondCardContentView: UIView!
    @IBOutlet private var secondCardTitle: UILabel!
    @IBOutlet private var secondCardImage: UIImageView!
    
    @IBOutlet private var thirdCard: UIView!
    @IBOutlet private var thirdCardContentView: UIView!
    @IBOutlet private var thirdCardTitle: UILabel!
    @IBOutlet private var thirdCardImage: UIImageView!
    
    var categories: [CategoryItem] = []
    var delegate: HomeCardsDelegate?
    override func setupUI() {
        super.setupUI()
        self.firstCardContentView.layer.cornerRadius = 12
        self.secondCardContentView.layer.cornerRadius = 12
        self.thirdCardContentView.layer.cornerRadius = 12
        
        self.lblDescrition.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        self.lblDescrition.textColor = Colors.headerTitle
        
        self.firstCardTitle.font = UIFont(name: Fonts.mediumFont, size: Sizes.prefTitle)
        self.firstCardTitle.textColor = Colors.navigationBarTitle
        self.secondCardTitle.font = UIFont(name: Fonts.mediumFont, size: Sizes.prefTitle)
        self.secondCardTitle.textColor = Colors.navigationBarTitle
        self.thirdCardTitle.font = UIFont(name: Fonts.mediumFont, size: Sizes.prefTitle)
        self.thirdCardTitle.textColor = Colors.navigationBarTitle
        
//        self.firstCard.showLoader()
//        self.secondCard.showLoader()
//        self.thirdCard.showLoader()
//        
//        let tapdk1 = UITapGestureRecognizer(target: self, action: #selector(cardTapped(sender:)))
//        self.thirdCardContentView.addGestureRecognizer(tapdk1)
//        let tapdk2 = UITapGestureRecognizer(target: self, action: #selector(cardTapped(sender:)))
//        self.secondCardContentView.addGestureRecognizer(tapdk2)
//        let tapdk3 = UITapGestureRecognizer(target: self, action: #selector(cardTapped(sender:)))
//        self.firstCardContentView.addGestureRecognizer(tapdk3)
    }
    
//    override func setText(dic: [String : Any]) {
//        super.setText(dic: dic)
//        if let cardStrs = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___three_cards.elements.items.value") as? [String] {
//            if let str =  KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___three_cards.elements.description.value") as? String {
//                self.lblDescrition.attributedText = str.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.headerTitle, lineSpacing: 0)
//            }
//            cardStrs.forEach { str in
//                var category =  CategoryItem()
//                if let title = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.\(str).elements.item_title.value") as? String {
//                    category.categoryName = title
//                }
//                if let title = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.\(str).elements.item_description.value") as? String {
//                    category.categoryDescription = title
//                }
//                if let images = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.\(str).elements.image.value") as? [[String:Any]], let imageURL = images.first?["url"] as? String{
//                    category.categoryImage = imageURL
//                }
//                if let title = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.\(str).elements.item_category.value") as? String, !title.isEmpty {
//                    category.categoryKey = title
//                }else {
//                    category.categoryKey = category.categoryName
//                }
//                self.categories.append(category)
//            }
//        }
//        self.loadData()
//    }
    
//    override func loadData() {
//        super.loadData()
//        if categories.count > 0 {
//            for i in 0...self.categories.count - 1 {
//                if i == 0 {
//                    self.firstCardTitle.text =  self.categories[i].categoryName
//                    self.firstCardImage.setImageURL(urlString: self.categories[i].categoryImage)
//                }else if i == 1 {
//                    self.secondCardTitle.text =  self.categories[i].categoryName
//                    self.secondCardImage.setImageURL(urlString: self.categories[i].categoryImage)
//                }else if i == 2 {
//                    self.thirdCardTitle.text =  self.categories[i].categoryName
//                    self.thirdCardImage.setImageURL(urlString: self.categories[i].categoryImage)
//                }
//            }
//            self.firstCard.hideLoader()
//            self.secondCard.hideLoader()
//            self.thirdCard.hideLoader()
//        }
//    }
    
    
//    @objc func cardTapped(sender: UITapGestureRecognizer) {
//        if let view = sender.view {
//            if view == self.firstCardContentView {
//                CurrentSession.share.categorySelected = self.categories[0].categoryKey
//            }else if view == secondCardContentView {
//                CurrentSession.share.categorySelected = self.categories[1].categoryKey
//            }else {
//                CurrentSession.share.categorySelected = self.categories[2].categoryKey
//            }
//            self.delegate?.homeCardDidSelected(homeCardView: self)
//        }
//    }
}
