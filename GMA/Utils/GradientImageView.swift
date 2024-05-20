//
//  GradientImageView.swift
//  GMA
//
//  Created by Saven Developer on 5/13/22.
//

import UIKit

class GradientImageView: UIImageView {
    
    let myGradientLayer: CAGradientLayer
    
    override init(frame: CGRect){
        myGradientLayer = CAGradientLayer()
        super.init(frame: frame)
        self.setup()
        addGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        myGradientLayer = CAGradientLayer()
        super.init(coder: coder)
        self.setup()
        addGradientLayer()
    }
    
    func addGradientLayer(){
        if myGradientLayer.superlayer == nil{
            self.layer.addSublayer(myGradientLayer)
        }
    }
    
    func getColors() -> [CGColor] {
        return [UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.clear.cgColor]
    }
    
    func setup() {
        myGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        myGradientLayer.endPoint = CGPoint(x: 0.5, y: 0.8)
        
        let colors = getColors()
        myGradientLayer.colors = colors
        myGradientLayer.isOpaque = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        myGradientLayer.frame = self.layer.bounds
    }
}

class BlueGradientImageView: UIImageView {
    
    let myGradientLayer: CAGradientLayer
    
    override init(frame: CGRect){
        myGradientLayer = CAGradientLayer()
        super.init(frame: frame)
        self.setup()
        addGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        myGradientLayer = CAGradientLayer()
        super.init(coder: coder)
        self.setup()
        addGradientLayer()
    }
    
    func addGradientLayer(){
        if myGradientLayer.superlayer == nil{
            self.layer.addSublayer(myGradientLayer)
        }
    }
    
    func getColors() -> [CGColor] {
        return [UIColor.clear.cgColor, Colors.blueBackground.withAlphaComponent(0.95).cgColor]
    }
    
    func setup() {
        myGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        myGradientLayer.endPoint = CGPoint(x: 0.5, y: 0.7)
        
        let colors = getColors()
        myGradientLayer.colors = colors
        myGradientLayer.isOpaque = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        myGradientLayer.frame = self.layer.bounds
    }
}


class GradientView: UIView {
    
    
    let myGradientLayer: CAGradientLayer
    
    override init(frame: CGRect){
        myGradientLayer = CAGradientLayer()
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        myGradientLayer = CAGradientLayer()
        super.init(coder: coder)
        self.setup()
    }
    
    func getColors() -> [CGColor] {
        return [UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.clear.cgColor]
    }
    
    func setup() {
        myGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        myGradientLayer.endPoint = CGPoint(x: 0.5, y: 0.8)
        
        let colors = getColors()
        myGradientLayer.colors = colors
        myGradientLayer.isOpaque = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if myGradientLayer.superlayer == nil{
            self.layer.addSublayer(myGradientLayer)
        }
        myGradientLayer.frame = self.layer.bounds
    }
}
