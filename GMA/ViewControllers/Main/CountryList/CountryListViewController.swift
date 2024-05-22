//
//  CountryListViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/22/24.
//



import Foundation
import UIKit
import ACProgressHUD_Swift
import MachO

protocol countryDetailDelegate: AnyObject{
    func updateCountryDetails(CountryDetail: CountryDetail)
}

class CountryListViewController: BaseViewController {
    
    private var searchView: UIView!
    private var cancelButton: UIButton!
    private var searchBar: UISearchBar!
    private var countryTableView: UITableView!
    private var ary_countryDetails = Array<CountryDetail>()
    private var ary_groupedCountries : Array<CountryGroupModel>!
    private var ary_searchGroupedCountries:Array<CountryGroupModel>!
    private var isSearching: Bool = false
    weak var delegate: countryDetailDelegate!
    private var noDataLabel: UILabel!
   
   
    let sections = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override func viewDidLoad() {
        self.kenticoCodeName = "app___more_edit_user_profile"
        super.viewDidLoad()
        setupGroupCountries()
    }
    
    convenience init(countries: Array<CountryDetail>){
        self.init()
        self.ary_countryDetails = countries
    }
    
    override func setText() {
        super.setText()
        if let dic = kenticoDic{
            if let cancel = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___phone_code.elements.additional_information.value") as? String{
                cancelButton.setTitle(cancel, for: .normal)
                cancelButton.sizeToFit()
            }
            if let search = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___phone_code.elements.watermark_message.value") as? String{
                searchBar.placeholder = search
            }
            if let noResultsFound = KenticoServices.getKenticoValue(dict: dic, path: "modular_content.app___phone_code.elements.error_message.value") as? String{
                noDataLabel.text = noResultsFound
            }
        }
    }
    
    override func setupUI() {
        super.setupUI()
        view.backgroundColor = UIColor(named: "CountryListBgColor")
        cancelButton = {
            let button = UIButton()
            button.contentHorizontalAlignment = .right
            button.setTitleColor(Colors.headerTitle, for: .normal)
            button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
            return button
        }()
        searchView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        searchBar = {
            let searchBar = UISearchBar()
            searchBar.showsCancelButton = false
            searchBar.searchBarStyle = .default
            searchBar.sizeToFit()
            searchBar.layer.cornerRadius = 0
            searchBar.searchTextField.backgroundColor = .white
            searchBar.addBorderWithDarkAtBottom(color: Colors.blueBackground)
            searchBar.delegate = self
            return searchBar
        }()
        
        
        
        countryTableView = {
            let tableView = UITableView()
            tableView.register(CountryListTableViewCell.self, forCellReuseIdentifier: "countryListCell")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = UIColor(named: "CountryListBgColor")
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            return tableView
        }()
        
        noDataLabel = {
            let label = UILabel()
            label.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
            label.textColor = UIColor(named: "textColor")
            label.textAlignment = .center
            return label
        }()
        [searchView, countryTableView].forEach({view.addSubview($0)})
        searchView.setupConstraints(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, withPadding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 84))
        countryTableView.setupConstraints(top: searchView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        [cancelButton,searchBar].forEach({searchView.addSubview($0)})
        cancelButton.setupConstraints(top: nil, leading: nil, bottom: nil, trailing: searchView.trailingAnchor, withPadding: .init(top: 0, left: 0, bottom: 0, right: 10), size: .init(width: 0, height: 40))
        cancelButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchBar.setupConstraints(top: nil, leading: searchView.leadingAnchor, bottom: nil, trailing: cancelButton.leadingAnchor, withPadding: .init(top: 0, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: 50))
        searchBar.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField{
            searchTextField.textColor = Colors.black
            searchTextField.leftView?.tintColor = Colors.black
        }
        
    }
    
    private func setupGroupCountries(){
        ary_groupedCountries = Array()
        ary_searchGroupedCountries = Array()
        for arr in sections{
            let filteredCountries = ary_countryDetails.filter({($0.countryName?.prefix(1).contains(arr))!})
            ary_groupedCountries.append(CountryGroupModel(groupName: arr, groupDetail: filteredCountries))
        }
        
        for arr in ary_countryDetails{
            if arr.alpha3Code == "USA"{
                let pinnedCountry = CountryGroupModel(groupName: " ", groupDetail: [arr])
                ary_groupedCountries.insert(pinnedCountry, at: 0)
            }
        }
    }
    
    @objc func dismissVC(){
        DispatchQueue.main.async { [weak self] in
                self?.dismiss(animated: true, completion: nil)
        }
    }
}

//Tableview Delegate Methods
extension CountryListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if ary_searchGroupedCountries.count <= 0{
            countryTableView.backgroundView = noDataLabel
        }else{
            countryTableView.backgroundView = nil
        }
        if isSearching{
            return ary_searchGroupedCountries != nil ? ary_searchGroupedCountries.count : 0
        }else{
            return ary_groupedCountries != nil ? ary_groupedCountries.count : 0
        }
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return ary_searchGroupedCountries != nil ? ary_searchGroupedCountries[section].groupDetail.count : 0
        }else{
            return ary_groupedCountries != nil ?  ary_groupedCountries[section].groupDetail.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.numberOfRows(inSection: section) > 0 {
            return 40
        }else {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "CountryListBgColor")
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 40))
        titleLabel.font = UIFont(name: Fonts.mediumFont, size: 22)
        titleLabel.textColor = UIColor(named: "textColor")
        headerView.addSubview(titleLabel)
        if isSearching{
            titleLabel.text = ary_searchGroupedCountries[section].groupName
        }else{
            titleLabel.text = ary_groupedCountries[section].groupName
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryListCell", for: indexPath) as! CountryListTableViewCell
        if isSearching{
            cell.countryDetail = ary_searchGroupedCountries[indexPath.section].groupDetail[indexPath.row]
        }else{
            cell.countryDetail = ary_groupedCountries[indexPath.section].groupDetail[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountryDetail: CountryDetail!
        if isSearching{
            selectedCountryDetail = ary_searchGroupedCountries[indexPath.section].groupDetail[indexPath.row]
        }else{
            selectedCountryDetail = ary_groupedCountries[indexPath.section].groupDetail[indexPath.row]
        }
        delegate.updateCountryDetails(CountryDetail: selectedCountryDetail)
        dismissVC()
    }
    
}

//Searchbar delegate methods
extension CountryListViewController: UISearchBarDelegate, UITextFieldDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            isSearching = false
            reloadTableViewData()
        }else{
            isSearching = true
            performSearchOperation(with: searchText)
        }
    }
    
    func performSearchOperation(with searchText: String){
        
        ary_searchGroupedCountries.removeAll()
        for countryGroup in ary_groupedCountries {
            if countryGroup.groupDetail.count > 0 {
                let groupSearch = countryGroup.groupDetail.filter({$0.countryName!.localizedStandardContains(searchText) || $0.phoneCode!.contains(searchText)})
                if groupSearch.count > 0 {
                    ary_searchGroupedCountries.append(CountryGroupModel(groupName: countryGroup.groupName, groupDetail: groupSearch))
                }
            }
        }
        ary_searchGroupedCountries.removeAll(where: {$0.groupName == " "})
        if ary_searchGroupedCountries.count <= 0 {
           
        }
        reloadTableViewData()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        isSearching = false
        reloadTableViewData()
        return true
      }
    
    func reloadTableViewData(){
        DispatchQueue.main.async { [weak self] in
            if let self = self{
                self.countryTableView.reloadData()
            }
        }
    }
    
}

