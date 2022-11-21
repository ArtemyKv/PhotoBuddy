//
//  DetailInfoView.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 16.11.2022.
//

import Foundation
import UIKit

protocol PhotoDetailsViewDelegate: AnyObject {
    
    func toggleFavoritesButtonPressed()
    
    func infoButtonPressed()
}

class PhotoDetailsView: UIView {
    
    weak var delegate: PhotoDetailsViewDelegate?
    
    let imageScrollView: ImageScrollView = {
        let scrollView = ImageScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    let infoButton: RoundButton = {
        let button = RoundButton()
        button.setTitle("i", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .systemGray6
        return button
    }()
    
    let toggleFavoritesButton: RoundButton = {
        let button = RoundButton()
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30), forImageIn: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .label
        button.backgroundColor = .systemGray6
        return button
    }()
    
    func setupView() {
        self.addSubview(imageScrollView)
        self.addSubview(infoButton)
        self.addSubview(toggleFavoritesButton)
        
        setupConstraints()
        setupButtonActions()
    }
    
    func setupConstraints() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        toggleFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 30),
            infoButton.heightAnchor.constraint(equalToConstant: 30),
            infoButton.centerXAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            infoButton.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            toggleFavoritesButton.widthAnchor.constraint(equalToConstant: 50),
            toggleFavoritesButton.heightAnchor.constraint(equalToConstant: 50),
            toggleFavoritesButton.centerXAnchor.constraint(equalTo: infoButton.centerXAnchor),
            toggleFavoritesButton.centerYAnchor.constraint(equalTo: infoButton.centerYAnchor, constant: -50)
            
            
        ])
    }
    
    func setupButtonActions() {
        toggleFavoritesButton.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
    }
    
    @objc func buttonPressed(sender: UIButton) {
        if sender == infoButton {
            delegate?.infoButtonPressed()
        } else if sender == toggleFavoritesButton {
            delegate?.toggleFavoritesButtonPressed()
        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        setupView()
    }
    
    
}
