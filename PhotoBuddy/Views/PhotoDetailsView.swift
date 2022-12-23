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
    
    func saveButtonPressed()
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
    
    let saveButton: RoundButton = {
        let button = RoundButton()
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 25), forImageIn: .normal)
        button.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        button.tintColor = .systemGray6
        button.backgroundColor = .label
        button.layer.masksToBounds = true
        return button
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.hidesWhenStopped = true
        return activityView
    }()
    
    let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.label, UIColor.clear, UIColor.label].map { $0.cgColor }
        gradient.locations = [0.0, 0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.type = .axial
        gradient.opacity = 0.7
        return gradient
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = CGRect(
            x: 0.0,
            y: 0.0,
            width: saveButton.frame.width,
            height: saveButton.frame.height)
    }
    
    func setupView() {
        self.addSubview(imageScrollView)
        self.addSubview(infoButton)
        self.addSubview(toggleFavoritesButton)
        self.addSubview(activityIndicatorView)
        self.addSubview(saveButton)
        
        setupConstraints()
        setupButtonActions()
    }
    
    func setupConstraints() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        toggleFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 30),
            infoButton.heightAnchor.constraint(equalToConstant: 30),
            infoButton.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            infoButton.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            toggleFavoritesButton.widthAnchor.constraint(equalToConstant: 50),
            toggleFavoritesButton.heightAnchor.constraint(equalToConstant: 50),
            toggleFavoritesButton.centerXAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            toggleFavoritesButton.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor, constant: -70),
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 50),
            saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor),
            saveButton.centerXAnchor.constraint(equalTo: toggleFavoritesButton.centerXAnchor),
            saveButton.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        ])
    }
    
    func setupButtonActions() {
        toggleFavoritesButton.addTarget(self, action: #selector(buttonTouchedDown(sender:)), for: .touchDown)
        infoButton.addTarget(self, action: #selector(buttonTouchedDown(sender:)), for: .touchDown)
        saveButton.addTarget(self, action: #selector(buttonTouchedDown(sender:)), for: .touchDown)
        
        toggleFavoritesButton.addTarget(self, action: #selector(buttonTouchedUpOutside(sender:)), for: .touchUpOutside)
        infoButton.addTarget(self, action: #selector(buttonTouchedUpOutside(sender:)), for: .touchUpOutside)
        saveButton.addTarget(self, action: #selector(buttonTouchedUpOutside(sender:)), for: .touchUpOutside)
        
        toggleFavoritesButton.addTarget(self, action: #selector(buttonTouchedUpInside(sender:)), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(buttonTouchedUpInside(sender:)), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(buttonTouchedUpInside(sender:)), for: .touchUpInside)
        
        
    }
    
    @objc func buttonTouchedUpInside(sender: UIButton) {
        switch sender {
            case infoButton:
                delegate?.infoButtonPressed()
            case toggleFavoritesButton:
                delegate?.toggleFavoritesButtonPressed()
            case saveButton:
                delegate?.saveButtonPressed()
            default:
                return
        }
        animateButtonUp(button: sender)
    }
    
    @objc func buttonTouchedDown(sender: UIButton) {
        animateButtonDown(button: sender)
    }
    
    @objc func buttonTouchedUpOutside(sender: UIButton) {
        animateButtonUp(button: sender)
    }
    
    func configureFavoritesButton(isInFavorites: Bool) {
        if isInFavorites {
            toggleFavoritesButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else if !isInFavorites {
            toggleFavoritesButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
    }
    
    private func animateButtonDown(button: UIButton) {
        UIView.animate(withDuration: 0.2) {
            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            button.alpha = 0.6
        }
    }
    
    private func animateButtonUp(button: UIButton) {
        UIView.animate(withDuration: 0.2) {
            button.transform = .identity
            button.alpha = 1.0
        }
    }
    
    func animateImageSaving() {
        saveButton.layer.addSublayer(gradientLayer)
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.0, 0.2]
        animation.toValue = [0.8, 1.0, 1.0]
        animation.duration = 1.0
        animation.repeatCount = Float.infinity
        gradientLayer.add(animation, forKey: "gradientAnimation")
        
    }
    
    func animateSavingCompletion() {
        gradientLayer.removeAnimation(forKey: "gradientAnimation")
        gradientLayer.removeFromSuperlayer()
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
