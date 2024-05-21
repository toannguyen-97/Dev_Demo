//
//  ColectionSelectionView.swift
//  GMA
//
//  Created by Hoan Nguyen on 07/06/2022.
//

import Foundation
import UIKit

protocol CollectionSelectionDelegate {
    func collectionSelectionDidSelected(collectionSelectionView: CollectionSelectionView, selectedItems: [String])
}

class CollectionSelectionView: BaseCustomView {
    let cellHeight = 50.0
    let padding = 10.0
    
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var collectionView: UICollectionView!

    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var titleString: String = ""
    var items: [String] = []
    var selectedItems: [String] = []
    var delegate: CollectionSelectionDelegate?
    
    func setData(titleString: String = "", defaultItemString: String = "All", _items: [String], _selectedItems: [String]){
        self.titleString = titleString
        self.items = _items.sorted()
        self.items.insert(defaultItemString, at: 0)
        self.selectedItems = _selectedItems
        self.collectionViewHeightConstraint.constant = Double(Double(self.items.count) / 2.0).rounded(.up) * (cellHeight + padding)
        self.updateSelectedString()
        self.collectionView.reloadData()
        self.lblTitle.accessibilityIdentifier =  titleString
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(FilterCollectionCell.self, forCellWithReuseIdentifier: "FilterCollectionCell")
        self.lblTitle.textColor = Colors.blueBackground
        self.lblTitle.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
    }
}

extension CollectionSelectionView : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.size.width - padding) / 2.0, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionCell", for: indexPath) as! FilterCollectionCell
        cell.itemName = self.items[indexPath.row]
        if (selectedItems.count == 0 && indexPath.item == 0) || (selectedItems.count > 0 && selectedItems.contains(items[indexPath.row])){
            cell.cellSelected = true
        } else {
            cell.cellSelected = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            self.selectedItems.removeAll()
            collectionView.reloadData()
        }else {
            var reloadCells:[IndexPath] = [indexPath]
            let name = items[indexPath.row]
            if self.selectedItems.contains(name) {
                self.selectedItems = self.selectedItems.filter { $0 != name }
                if self.selectedItems.count == 0 {
                    reloadCells.append(IndexPath(item: 0, section: 0))
                }
            }else {
                if self.selectedItems.count == 0 {
                    reloadCells.append(IndexPath(item: 0, section: 0))
                }
                self.selectedItems.append(name)
            }
            collectionView.reloadItems(at: reloadCells)
        }
        self.updateSelectedString()
        self.delegate?.collectionSelectionDidSelected(collectionSelectionView: self, selectedItems: selectedItems)
    }
    
    private func updateSelectedString() {
        var plusNumber = 3
        var numberOfLine = 2
        if self.selectedItems.count > 0 {
            while numberOfLine > 1 && plusNumber > 0 {
                self.lblTitle.text = "\(self.titleString) (\(selectedItems.toStringWithPlusItems(numberOfItemToShow: plusNumber)))"
                numberOfLine = self.lblTitle.countLines()
                plusNumber = plusNumber - 1
            }
        }else {
            self.lblTitle.text = self.titleString
        }
    }
}
