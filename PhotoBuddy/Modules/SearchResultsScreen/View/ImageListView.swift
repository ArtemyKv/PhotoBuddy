//
//  imageCollectionView.swift
//  SimpleUnsplashPhoto
//
//  Created by Artem Kvashnin on 11.11.2022.
//

import Foundation
import UIKit

class ImageListView: UIView {
    
    let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        
        let string = "Photo Buddy"
        let font = UIFont.systemFont(ofSize: 40, weight: .medium)
        let foregroundTextColor = UIColor.systemGray6
        let textShadow = NSShadow()
        textShadow.shadowOffset = CGSize(width: 1, height: 1)
        textShadow.shadowColor = UIColor.systemGray3
        textShadow.shadowBlurRadius = 2.0
        
        let attributedString = NSAttributedString(
            string: string,
            attributes: [
                .font: font,
                .foregroundColor: foregroundTextColor,
                .shadow: textShadow,
        ])
        label.attributedText = attributedString
        return label
    }()
    
    let searchSuggestionLabel: UILabel = {
        let label = UILabel()
        label.text = "Ready for searching photos"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .systemGray3
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = .white
        self.addSubview(appNameLabel)
        self.addSubview(searchSuggestionLabel)
        self.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        searchSuggestionLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            appNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30),
            searchSuggestionLabel.centerXAnchor.constraint(equalTo: appNameLabel.centerXAnchor),
            searchSuggestionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10),
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
    }
    
    func toggleBackgroundLabelsVisibility(shouldHide: Bool) {
        appNameLabel.isHidden = shouldHide
        searchSuggestionLabel.isHidden = shouldHide
    }
}
