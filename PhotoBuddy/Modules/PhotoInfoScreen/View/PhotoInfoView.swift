//
//  PhotoInfoView.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 20.11.2022.
//

import UIKit

class PhotoInfoView: UIView {
    private let rowsCount = 4
    private let rowTitles = ["Author", "Created at", "Location", "Downloads"]
    private lazy var labels = [authorNameLabel, creationDateLabel, locationLabel, downloadsCountLabel]
    
    lazy var authorNameLabel: UILabel = {
        configureLabel()
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    lazy var creationDateLabel: UILabel = {
        configureLabel()
    }()
    
    lazy var locationLabel: UILabel = {
        configureLabel()
    }()
    
    lazy var downloadsCountLabel: UILabel = {
        configureLabel()
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16
        return stack
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        self.addSubview(vStack)
        setupStack()
        setupConstraints()
    }
    
    private func configureLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }
    
    private func rowTitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }
    
    private func setupStack() {
        let firstRowTitleLabel = rowTitleLabel()
        firstRowTitleLabel.text = "Description:"
        vStack.addArrangedSubview(firstRowTitleLabel)
        vStack.addArrangedSubview(descriptionLabel)
        
        for i in 0..<rowsCount {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.alignment = .fill
            hStack.distribution = .fill
            
            let rowTitleLabel = rowTitleLabel()
            rowTitleLabel.text = rowTitles[i] + ":"
            hStack.addArrangedSubview(rowTitleLabel)
            hStack.addArrangedSubview(labels[i])
            vStack.addArrangedSubview(hStack)
        }
    }
    
    private func setupConstraints() {
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
        ])
    }
}
