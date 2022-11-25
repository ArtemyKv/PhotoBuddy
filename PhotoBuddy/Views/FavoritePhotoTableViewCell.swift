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
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .right
        return label
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 8
        return stack
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 8
        return stack
    }()
    
    private func setupView() {
        vStack.addArrangedSubview(authorNameLabel)
        vStack.addArrangedSubview(dateLabel)
        hStack.addArrangedSubview(photoView)
        hStack.addArrangedSubview(vStack)
        self.contentView.addSubview(hStack)
        
        photoView.translatesAutoresizingMaskIntoConstraints = false
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoView.widthAnchor.constraint(equalTo: hStack.widthAnchor, multiplier: 0.5),
            photoView.heightAnchor.constraint(equalTo: photoView.widthAnchor, multiplier: 1),
            hStack.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            hStack.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
