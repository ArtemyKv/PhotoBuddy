//
//  GradientBackgroundView.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 21.12.2022.
//

import UIKit

class GradientBackgroundView: UIView {
    
    override static var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        return (layer as! CAGradientLayer)
    }
    
    func setupView() {
        if let layer = layer as? CAGradientLayer {
            layer.colors = [UIColor.lightGray.cgColor, UIColor.clear.cgColor]
            layer.type = .axial
            layer.locations = [0.0, 1.0]
            layer.startPoint = CGPoint(x: 0.5, y: 1.0)
            layer.endPoint = CGPoint(x: 0.5, y: 0.0)
        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
