//
//  PhotoCell.swift
//  SimpleUnsplashPhoto
//
//  Created by Artem Kvashnin on 15.11.2022.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell {
    var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func setupCell() {
        self.contentView.addSubview(photoView)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
//    TODO: - Set default image for reuse
    override func prepareForReuse() {
        photoView.image = nil
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        setupCell()
    }
}
