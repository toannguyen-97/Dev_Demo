//
//  HomeCityView.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//


import Foundation
import UIKit

protocol HomeTopCityDelegate {
    func HomeCityChooseDidSelected()
    func HomeCityDidSelectedItem(city: TrendCity)
}

class HomeCityView: BaseCustomView , UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    var delegate: HomeTopCityDelegate?
    var locationCity:ASCity? {
        didSet {
//            self.createTitleText()
//
//            self.getTrendyCities()
        }
    }
    var citiesArray: [TrendCity] = []
    
    @IBOutlet private var lblTitle : UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var lblDes : UILabel!
    @IBOutlet private var pageControlView: UIPageControl!
    
    private func setAccessibilityID() {
        self.lblTitle.accessibilityIdentifier = "CitylblTitle"
        self.collectionView.accessibilityIdentifier = "CitycollectionView"
        self.lblDes.accessibilityIdentifier = "CitylblDes"
        self.pageControlView.accessibilityIdentifier = "CitypageControlView"
    }
    
    override func setupUI() {
        super.setupUI()
        self.setAccessibilityID()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "CityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CityCollectionViewCell")
        
        self.lblTitle.textColor = Colors.headerTitle
        self.lblTitle.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        self.lblTitle.backgroundColor = UIColor.clear
        self.lblDes.backgroundColor = UIColor.clear
        
        self.pageControlView.pageIndicatorTintColor = Colors.bottomLine
        self.pageControlView.currentPageIndicatorTintColor = Colors.blueBackground
    }
    
    override func loadData() {
        self.lblTitle.attributedText = "Popular Destinations".toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.headerTitle, lineSpacing: 0)
    }
    
    var stringWithLocation = "Not in [City]? \n{Choose a city} to explore"
    var stringWithoutLocation = "More than 10,000 benefits around the globe. {Choose a city} to explore"
//    override func setText(dic: [String : Any]) {
//        super.setText(dic: dic)
//        if let title = KenticoServices.getKenticoValue(dict: dic, path:  "modular_content.app___popular_destinations.elements.title.value") as? String {
//            self.lblTitle.attributedText = title.toAttributeStringWith(fontName: Fonts.regularFont, fontSize: Sizes.titleText, color: Colors.headerTitle, lineSpacing: 0)
//        }
//        
//        if let str = KenticoServices.getKenticoValue(dict: dic, path:  "modular_content.app___popular_destinations.elements.description.value") as? String {
//            stringWithLocation = str
//        }
//        if let str = KenticoServices.getKenticoValue(dict: dic, path:  "modular_content.app___popular_destinations.elements.long_description.value") as? String {
//            stringWithoutLocation = str
//        }
//        self.createTitleText()
//    }
    
    
//    private func createTitleText(){
//        var chooseACity = "\nChoose a city"
//        var message = stringWithoutLocation
//        if let locationN = self.locationCity?.name {
//            message =   self.stringWithLocation.replacingOccurrences(of: "[City]", with: locationN)
//        }
//        if let str = message.slice(from: "{", to: "}") {
//            chooseACity = str
//        }
//        message = message.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")
//        
//        
//        let mutableStr = NSMutableAttributedString(attributedString: message.toAttributeStringWith(fontName: Fonts.mediumFont, fontSize: Sizes.titleText, color: Colors.blueBackground, lineSpacing: 0))
//        let range = mutableStr.mutableString.range(of: chooseACity)
//        mutableStr.addAttribute(.underlineStyle, value: 1, range: range)
//        mutableStr.addAttribute(.foregroundColor, value: Colors.secondBlueBackground, range: range)
//        self.lblDes.attributedText = mutableStr
//        self.lblDes.textAlignment = .center
//        let tapdk = UITapGestureRecognizer(target: self, action: #selector(chooseCityTap))
//        self.lblDes.isUserInteractionEnabled = true
//        self.lblDes.addGestureRecognizer(tapdk)
//    }
    
    
//    private func getTrendyCities() {
//        TrendyServices().getTrendyCities {[weak self] result in
//            DispatchQueue.main.async {
//                guard let self = self else {return }
//                switch result {
//                case .success(let cities):
//                    if cities.count > 0{
//                        self.isHidden = false
//                        if self.collectionView.contentOffset.x > 0 {
//                            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
//                        }
//                        self.citiesArray = cities
//                        self.pageControlView.numberOfPages =  cities.count > 10 ? 10 : cities.count
//                        self.pageControlView.currentPage = 0
//                        self.collectionView.reloadData()
//                    }else {
//                        self.isHidden = true
//                    }
//                case .failure(_):
//                    self.isHidden = true
//                }
//            }
//        }
//    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width - 20, height: self.collectionView.frame.size.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCollectionViewCell", for: indexPath) as! CityCollectionViewCell
        return cell
    }
 
    
    var currentIndex = 0
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(self.collectionView.contentOffset.x / self.collectionView.frame.size.width)
        pageControlView.currentPage = currentIndex
    }

    
    
    @IBAction func changePage(sender:UIPageControl) {
        let page = sender.currentPage
        self.collectionView.scrollToItem(at: IndexPath(item: page, section: 0), at: .centeredHorizontally, animated: true)
    }
    
}
