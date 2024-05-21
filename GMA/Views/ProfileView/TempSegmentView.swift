//
//  CustomSegmentView.swift
//  GMA
//
//  Created by Saven Developer on 2/23/22.
//

import Foundation
import UIKit

protocol TemperatureDelegate: AnyObject{
    func didTapOnTemperatureButton(temperatureType: TemperatureType)
}

class TempSegmentView : UIView{
    
    private var baseView: UIView!
    private var button1: UIButton!
    private var divider: UIView!
    private var button2: UIButton!
    weak var delegate: TemperatureDelegate!
    
    var aspireProfile: AspireProfile? {
        didSet{
            DispatchQueue.main.async { [weak self] in
                if let self = self{
                    if AspireProfile.getTemperatureUnit() == TemperatureUnit.C.stringValue{
                        self.button2.isEnabled = false
                        self.button1.isEnabled = true
                    }else{
                        self.button2.isEnabled = true
                        self.button1.isEnabled = false
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIComponents()
    }
    required init?(coder: NSCoder) {
        fatalError("Fatal Error")
    }
    
    func setupUIComponents(){
        baseView = {
            let view = UIView()
            view.backgroundColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        button1 = {
            let button = UIButton()
            button.setTitle("F °", for: .normal)
            button.titleLabel?.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
            button.setTitleColor(Colors.secondPlacholderText, for: .normal)
            button.setTitleColor(Colors.blueBackground, for: .disabled)
            button.addTarget(self, action: #selector(action_button1), for: .touchUpInside)
            return button
        }()
        divider = {
            let view = UIView()
            view.backgroundColor = Colors.bottomLine
            return view
        }()
        button2 = {
            let button = UIButton()
            button.setTitle("C °", for: .normal)
            button.setTitleColor(Colors.secondPlacholderText, for: .normal)
            button.setTitleColor(Colors.blueBackground, for: .disabled)
            button.titleLabel?.font = UIFont(name: Fonts.mediumFont, size: Sizes.titleText)
            button.addTarget(self, action: #selector(action_button2), for: .touchUpInside)
            return button
        }()
        self.addSubview(baseView)
        baseView.fillWithSuperView()
        [button1, divider, button2].forEach({baseView.addSubview($0)})
        
        button1.setupConstraints(top: baseView.topAnchor, leading: baseView.leadingAnchor, bottom: baseView.bottomAnchor, trailing: nil, withPadding: .zero, size: .init(width: 60, height: 50))
        divider.setupConstraints(top: baseView.topAnchor, leading: button1.trailingAnchor, bottom: baseView.bottomAnchor, trailing: nil, withPadding: .init(top: 10, left: 0, bottom: 10, right: 0), size: .init(width: 1, height: 0))
        button2.setupConstraints(top: baseView.topAnchor, leading: divider.trailingAnchor, bottom: baseView.bottomAnchor, trailing: baseView.trailingAnchor, withPadding: .zero, size: .init(width: 60, height: 50))
    }
    
    
    @objc func action_button1(){
        if let delegate = delegate{
            delegate.didTapOnTemperatureButton(temperatureType: .fahrenheit)
        }
    }
    @objc func action_button2(){
        if let delegate = delegate{
            delegate.didTapOnTemperatureButton(temperatureType: .Celsius)
        }
    }
    
}
