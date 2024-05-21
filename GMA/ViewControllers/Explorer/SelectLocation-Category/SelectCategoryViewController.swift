//
//  SelectCategoryViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//


import UIKit
import ACProgressHUD_Swift

protocol SelectCategoryDelegate {
    func categoryDidSelected(category: CategoryItem)
}

class SelectCategoryViewController: BaseViewController {
    
    @IBOutlet private var headerView: UIView!
    @IBOutlet private var lblTitle: UILabel!
    
    @IBOutlet private var tableView: UITableView!
    
    convenience  init(isUpdate: Bool = false) {
        self.init()
        isUpdateFlow = isUpdate
    }
    
    var delegate: SelectCategoryDelegate?
    var selectedCategory : CategoryItem?{
        didSet {
            if let sCate = selectedCategory {
                self.delegate?.categoryDidSelected(category: sCate)
            }
        }
    }
    var isUpdateFlow = false
    
    var categoryArray: [CategoryItem] = []
    override func viewDidLoad() {
        if !isUpdateFlow {
            ACProgressHUD.shared.showHUD()
            self.kenticoCodeName = "app___categories_locations"
            self.kenticoDepth = 3
        }
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        loadCMSTextFinish()
    }
    
    override func setupUI() {
        super.setupUI()
        self.lblTitle.textColor = Colors.blueBackground
        self.lblTitle.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
        self.headerView.isHidden = self.isUpdateFlow
        self.tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "CityTableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func loadCMSTextFinish() {
        super.loadCMSTextFinish()
        ACProgressHUD.shared.hideHUD()
        guard let kenDic = self.kenticoDic else {return}
        if let title = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.app___categories_list.elements.title.value") as? String {
            self.title = title
        }
        if let items = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.app___categories_list.elements.items.value") as? [String] {
            categoryArray = []
            items.forEach { itemStr in
                var category =  CategoryItem()
                if let title = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.\(itemStr).elements.item_category.value") as? String {
                    category.categoryName = title
                }
                if let title = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.\(itemStr).elements.item_title.value") as? String, !title.isEmpty {
                    category.categoryKey = title
                }else {
                    category.categoryKey = category.categoryName
                }
                if let title = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.\(itemStr).elements.item_description.value") as? String {
                    category.categoryDescription = title
                }
                if let images = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.\(itemStr).elements.image.value") as? [[String:Any]], let imageURL = images.first?["url"] as? String{
                    category.categoryImage = imageURL
                }
                categoryArray.append(category)
            }
            
            #warning("add Limo For Working")
            let cate = CategoryItem(categoryName: limoCategory, categoryDescription: "", categoryImage: "", categoryKey: limoCategory)
            categoryArray.insert(cate, at: 0)
            if self.tableView != nil {
                self.tableView.reloadData()
            }
        }
    }
    
    override func setText() {
        super.setText()
        if let dic = kenticoDic{
            if let title = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___categories_list.elements.description.value") as? String {
                self.lblTitle.text = title
            }
        }
    }
    
    @IBAction func closed() {
        self.backViewController()
    }
    
    func nextStep() {
        if !self.isUpdateFlow {
            CurrentSession.share.categorySelected = self.selectedCategory?.categoryKey
            MainTabbarController.shared.switchToExploreScreen()
        }
    }
}


extension SelectCategoryViewController: UITableViewDataSource, UITableViewDelegate {

   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
//        cell.categoryItem = self.categoryArray[indexPath.row]
//        
//        if self.selectedCategory != nil{
//            cell.selectedView.isHidden = cell.categoryItem?.categoryKey != self.selectedCategory?.categoryKey
//        }else{
//            cell.selectedView.isHidden = cell.categoryItem?.categoryKey != CurrentSession.share.categorySelected
//        }
//   
//        if cell.categoryItem?.categoryName == offerCategoryName && self.selectedCategory == offerCategoryType {
//            cell.selectedView.isHidden = false
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.categoryArray[indexPath.row]
        self.selectedCategory = category
        self.tableView.reloadData()
        nextStep()
    }

}

