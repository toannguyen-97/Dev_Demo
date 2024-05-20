//
//  BaseCustomView.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/23/22.
//

import Foundation
import UIKit
import ListPlaceholder

class BaseCustomView: UIView {
    var kenticoDic : [String:Any]?
    var contentView: UIView!
    var parrentVC: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = commonInit(for: String(describing: type(of: self)))
        self.setupUI()
        self.setText(dic: [:])
        self.loadData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView = commonInit(for: String(describing: type(of: self)))
        self.setupUI()
        self.setText(dic: [:])
        self.loadData()
    }
    
    
    func commonInit(for customViewName: String)-> UIView {
        if let view =  Bundle.main.loadNibNamed(customViewName, owner: self, options: nil)?.first as? UIView {
            view.backgroundColor = .clear
            view.frame = bounds
            addSubview(view)
            view.setupConstraints(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
            view.backgroundColor = Colors.navigationBarTitle
            return view
        }
        return UIView()
    }
    
    func setText(dic: [String: Any]) {
        self.kenticoDic = dic
    }
    
    func setupUI() {
        
    }
    
    func loadData() {
        
    }
}


//
//protocol CustomViewProtocol {
//
//    /// The content of the UIView
//    var contentView: UIView { get set }
//
//    /// Attach a custom `Nib` to the view's content
//    /// - Parameter customViewName: the name of the `Nib` to attachs
//    func commonInit(for customViewName: String)
//}
//
//extension CustomViewProtocol where Self: UIView {
//
//    func commonInit(for customViewName: String) {
//        contentView =  Bundle.main.loadNibNamed(customViewName, owner: self, options: nil)?.first as? UIView
//        contentView.backgroundColor = .clear
//        contentView.frame = bounds
//        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(contentView)
//    }
//
//}
