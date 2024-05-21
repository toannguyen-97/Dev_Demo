//
//  SelectionListViewController.swift
//  GMA
//
//  Created by Hoan Nguyen on 07/06/2022.
//

import UIKit

protocol SelectionListDelegate {
    func selectionListDidSelected(selectionListView: SelectionListViewController, selectedItems:[String], selectionString: String)
}

class SelectionListViewController: BaseViewController {
    // CMS String
    var cmsSearchString = ""
    var cmsNoResultsFound = ""
    var cmsCustomInvalidValueString = ""
    var cmsCustomEmptyString = ""
    var cmsCustomUnit = ""
    var cmsApply = ""
    
    var customText = ""
    var customValue = ""
    
    var items: [String] = [] {
        didSet {
            itemsDisplay = items
        }
    }
    var itemsDisplay:[String] = []
    var selectedItems:[String] = []
    var isMultipleChoice = false
    var isShowSearchView = false
    var defaultTitle: String = ""
    var defaultSubTitle: String = ""
    private var searchView: UIView!
    var searchBar: UISearchBar!
    
    @IBOutlet private var lblTitle: UILabel!
    @IBOutlet private var lblSubTitle: UILabel!
    @IBOutlet private var tableview: UITableView!
    @IBOutlet private var btnClear: UIButton!
    @IBOutlet private var bottomView: BottomButtonWithGradient!
    var delegate: SelectionListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.accessibilityIdentifier = "CategoryFilterNameLabel"
        self.lblTitle.accessibilityIdentifier = "CategoryFilterValueLabel"
        self.btnClear.accessibilityIdentifier = "CategoryFilterClearButton"
        self.tableview.register(UINib(nibName: "SelectionListCell", bundle: nil), forCellReuseIdentifier: "SelectionListCell")
        self.lblTitle.textColor = Colors.blueBackground
        self.lblTitle.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
        self.lblTitle.text = self.defaultTitle
        self.lblSubTitle.textColor = Colors.headerTitle
        self.lblSubTitle.font = UIFont(name: Fonts.regularFont, size: Sizes.headerText)
        self.searchBar.placeholder = cmsSearchString
    }

    
    override func setupUI() {
        super.setupUI()
        self.btnClear.isHidden = !self.isMultipleChoice
        if isMultipleChoice {
            self.bottomView.isHidden = false
            self.bottomView.button.setTitle("Save", for: .normal)
            self.bottomView.delegate = self
        }else {
            self.bottomView.isHidden = true
        }
        btnClear.setTitleColor(Colors.secondBlueBackground, for: .normal)
        btnClear.titleLabel?.font = UIFont(name: Fonts.regularFont, size: Sizes.titleText)
        updateSelectedItemString()
        searchView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
            view.backgroundColor = Colors.navigationBarTitle
            view.addBottomLine()
            return view
        }()
        
        searchBar = {
            let searchBar = UISearchBar()
            searchBar.showsCancelButton = false
            searchBar.searchBarStyle = .default
            searchBar.placeholder = cmsSearchString
            searchBar.sizeToFit()
            searchBar.delegate = self
            definesPresentationContext = true
            searchBar.layer.cornerRadius = 0
            searchBar.searchTextField.backgroundColor = .white
            searchBar.addBorderWithDarkAtBottom(color: Colors.blueBackground)
            return searchBar
        }()
        
        searchView.addSubview(searchBar)
        searchBar.fillWithSuperView(withPadding: .init(top: 10, left: 20, bottom: 10, right: 20))
        if isShowSearchView {
            self.tableview.tableHeaderView = searchView
        }else {
            self.tableview.tableHeaderView = nil
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        self.selectedItems.removeAll()
        self.tableview.reloadData()
        updateSelectedItemString()
    }
    
    @IBAction func close(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func updateSelectedItemString() {
        if self.selectedItems.count > 0 {
            self.lblSubTitle.text = self.selectedItems.toStringWithPlusItems(numberOfItemToShow: 3)
        }else {
            self.lblSubTitle.text = defaultSubTitle
        }
        if isMultipleChoice {
            btnClear.isHidden = self.selectedItems.count <= 0
        }
    }
}

extension SelectionListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchBar.text!.isEmpty && self.itemsDisplay.count == 0{
            tableView.setEmptyMessage(cmsNoResultsFound, withTopIcon: false)
        }else {
            tableView.restoreEmptyView()
        }
        return self.itemsDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "SelectionListCell", for: indexPath) as! SelectionListCell
        cell.cmsCustomEmptyString = self.cmsCustomEmptyString
        cell.cmsCustomUnit = self.cmsCustomUnit
        cell.cmsaApplyString = self.cmsApply
        cell.cmsCustomInvalidValueString = self.cmsCustomInvalidValueString
        let data = self.itemsDisplay[indexPath.row]
        cell.titleString = data
        cell.customValueEnable = false
        if self.selectedItems.contains(data) {
            if data == customText {
                cell.customValueEnable = true
                if !customValue.isEmpty{
                    cell.tfCustomDistance.text = customValue
                }
            }
            cell.cellSelected = true
        }else {
            cell.cellSelected = false
        }
        cell.applyCustomValueClosure = { (customString) in
            self.delegate?.selectionListDidSelected(selectionListView: self,selectedItems: [customString], selectionString: self.lblSubTitle.text!)
            self.dismiss(animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = itemsDisplay[indexPath.row]
        var reloadCells:[IndexPath] = [indexPath]
        if isMultipleChoice {
            if let index = selectedItems.firstIndex(of: cellData) {
                selectedItems.remove(at: index)
            }else {
                selectedItems.append(cellData)
            }
        }else {
            if selectedItems.contains(cellData) {
                return
            }else {
                if let oldSelectedItem = selectedItems.first, let index = itemsDisplay.firstIndex(of: oldSelectedItem) {
                    reloadCells.append(IndexPath(row: index, section: 0))
                }
                selectedItems.removeAll()
                selectedItems.append(cellData)
            }
        }
        tableView.reloadRows(at: reloadCells, with: .none)
        self.updateSelectedItemString()
        if self.bottomView.isHidden && cellData != self.customText{
            self.delegate?.selectionListDidSelected(selectionListView: self,selectedItems: selectedItems, selectionString: self.lblSubTitle.text!)
        }
    }
}

extension SelectionListViewController: BottomButtonDelegate {
    func buttonDidTapped(button: UIButton) {
        self.delegate?.selectionListDidSelected(selectionListView: self,selectedItems: selectedItems, selectionString: self.lblSubTitle.text!)
        self.dismiss(animated: true, completion: nil)
    }
}


extension SelectionListViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.itemsDisplay = self.items
        }else{
            self.itemsDisplay = self.items.filter({$0.localizedCaseInsensitiveContains(searchText)})
        }
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
}
