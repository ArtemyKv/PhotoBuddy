//
//  FooterView.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 30.11.2022.
//

import UIKit

class BottomRefreshControl: UICollectionReusableView {
    
    static let reuseIdentifier = "bottomRefreshControl"
    static let elementKind = "Footer"
    
    let indicator = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    
    func setupView() {
        self.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
