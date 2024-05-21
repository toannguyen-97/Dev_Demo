//
//  HomeSpecialOfferView.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//


import UIKit

protocol HomeSpecialOfferDelegate {
    func homeSpecialOfferShowMore()
    func homeSpecialOfferItemClicked(item: ContentTopic)
}

class HomeSpecialOfferView: BaseCustomView , UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    // CMS String
    var titleInStr = "Enjoy Offers in [City]"
    var titleNearStr = "Enjoy Offers near [City]"
    var cmsDiningPerkContentTypeString = ""
    
    var locationCity: ASCity? {
        didSet {
       
        }
    }
    var delegate: HomeSpecialOfferDelegate?
    var offersArray: [ContentTopic] = []
    @IBOutlet private var lblTitle : UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var btnNext: UIButton!
    @IBOutlet private var btnBack: UIButton!
    @IBOutlet private var lblIndex: UILabel!
    @IBOutlet private var btnExplorer: UIButton!
    
    private func setAccessibilityID() {
        lblTitle.accessibilityIdentifier = "SpecialOfferlblTitle"
        self.collectionView.accessibilityIdentifier = "SpecialOffercollectionView"
        self.btnBack.accessibilityIdentifier = "SpecialOfferbtnBack"
        self.btnNext.accessibilityIdentifier = "SpecialOfferbtnNext"
        self.btnExplorer.accessibilityIdentifier = "SpecialOfferbtnExplorer"
        self.lblIndex.accessibilityIdentifier = "SpecialOfferlblIndex"
    }
    
    override func setupUI() {
        super.setupUI()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "SpecialOfferCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SpecialOfferCollectionCell")
        
        self.lblTitle.textColor = Colors.headerTitle
        self.lblTitle.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        self.lblTitle.backgroundColor = UIColor.clear
        
        self.lblIndex.textColor = Colors.blueBackground
        self.lblIndex.font = UIFont(name: Fonts.regularFont, size: Sizes.titleGreeting)
        self.lblIndex.backgroundColor = UIColor.clear
        
        self.btnExplorer.backgroundColor = UIColor.clear
        self.btnExplorer.setTitleColor(Colors.secondBlueBackground, for: .normal)
        self.lblTitle.text = "Enjoy Offers Near Philadelphia"
        self.setAccessibilityID()
//        self.showLoader()
    }
    
    override func setText(dic: [String : Any]){}
    
    
//    private func getCMSTitle() -> String{
//        if LocationManager.shared.locationIsCity(asCity: self.locationCity) {
//            return self.titleInStr
//        }else {
//            return self.titleNearStr
//        }
//    }
    
//    override func loadData() {
//        let explorerTitle = "Explore more offers"
//        let attr = NSAttributedString(string: explorerTitle, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
//        self.btnExplorer.setAttributedTitle(attr, for: .normal)
//    }
    
    
    
    
    private func collectionviewReloadData(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if self.offersArray.count > 1 {
                self.collectionView.setContentOffset(CGPoint(x: self.collectionView.frame.size.width * CGFloat(self.offersArray.count*500), y: 0), animated: false)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width - 20, height: self.collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        self.isHidden = self.offersArray.count <= 0
//        if self.offersArray.count != 0 {
//            self.lblIndex.text = "1"
//            return self.offersArray.count * 1000
//        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialOfferCollectionCell", for: indexPath) as! SpecialOfferCollectionCell
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.delegate?.homeSpecialOfferItemClicked(item: self.offersArray[indexPath.row % self.offersArray.count])
    }
    
    
    var currentIndex = 0
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(self.collectionView.contentOffset.x / self.collectionView.frame.size.width)
        if self.offersArray.count != 0 {
            self.lblIndex.text = "\((currentIndex % self.offersArray.count) + 1)"
        }
    }

    @IBAction func showOfferList(sender: UIButton) {
        self.delegate?.homeSpecialOfferShowMore()
    }
    
    
    @IBAction func moveAction(sender:UIButton) {
        if sender == btnNext {
            if currentIndex >= self.collectionView.numberOfItems(inSection: 0) - 1{
                return
            }else {
                self.collectionView.scrollToItem(at: IndexPath(item: currentIndex + 1, section: 0), at: .bottom, animated: true)
            }
        }else {
            if currentIndex == 0{
                return
            }else {
                self.collectionView.scrollToItem(at: IndexPath(item: currentIndex - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
}

