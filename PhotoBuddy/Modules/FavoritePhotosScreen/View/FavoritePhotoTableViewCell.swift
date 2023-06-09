//
//  FavoritePhotoTableViewCell.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 24.11.2022.
//

import UIKit

class FavoritePhotoTableViewCell: UITableViewCell {
    
    static let identifier = "FavoritePhotoTableViewCell"

    let photoView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    lazy var labelBackgroundView: GradientBackgroundView = {
        let view = GradientBackgroundView()
        view.alpha = 0.5
        return view
    }()
    
    private var photoViewHeightConstraint = NSLayoutConstraint()
    
    private func setupView() {
        self.contentView.addSubview(photoView)
        self.contentView.addSubview(labelBackgroundView)
        self.contentView.addSubview(authorNameLabel)
        
        photoView.translatesAutoresizingMaskIntoConstraints = false
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        labelBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        photoViewHeightConstraint = photoView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.7)
        
        let photoViewBottomConstraint = photoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4)
        photoViewBottomConstraint.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            photoView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            photoView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            photoViewBottomConstraint,
            photoViewHeightConstraint,
            labelBackgroundView.leadingAnchor.constraint(equalTo: photoView.leadingAnchor),
            labelBackgroundView.trailingAnchor.constraint(equalTo: photoView.trailingAnchor),
            labelBackgroundView.bottomAnchor.constraint(equalTo: photoView.bottomAnchor),
            labelBackgroundView.heightAnchor.constraint(equalTo: photoView.heightAnchor, multiplier: 0.5),
            authorNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -8),
            authorNameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func update(with photo: UIImage?) {
        guard let photo else { return }
        photoView.image = photo
        
        NSLayoutConstraint.deactivate([photoViewHeightConstraint])
        
        photoViewHeightConstraint = photoView.heightAnchor.constraint(
            equalTo: photoView.widthAnchor,
            multiplier: photo.size.height / photo.size.width)
        
        photoViewHeightConstraint.isActive = true
        
        
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
