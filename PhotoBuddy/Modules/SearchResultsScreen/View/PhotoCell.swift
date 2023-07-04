//
//  PhotoCell.swift
//  SimpleUnsplashPhoto
//
//  Created by Artem Kvashnin on 15.11.2022.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell {
    private var cellViewModel: CellViewModelProtocol? {
        didSet {
            guard let cellViewModel else { return }
            cellViewModel.bindPhoto { [weak self] image in
                self?.photoView.image = image
            }
        }
    }
    
    private var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        setupCell()
    }
    
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
    
    override func prepareForReuse() {
        photoView.image = nil
        cellViewModel?.removeBindings()
        cellViewModel = nil
        
    }
    
    func setCellViewModel(_ cellViewModel: CellViewModelProtocol?) {
        self.cellViewModel = cellViewModel
    }
}
