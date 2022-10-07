//
//  UserListCell.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 06.10.2022.
//

import UIKit

class UserListCell: UICollectionViewCell {
    
    private let userImageView = UIImageView()
    private let userNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
        
        userImageView.backgroundColor = .systemGray6
        userImageView.layer.cornerRadius = Constants.imageSize / 2
        userImageView.clipsToBounds = true
        
        layer.cornerRadius = 8
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with name: String) {
        userNameLabel.text = name
    }
    
    func configure(with image: UIImage) {
        userImageView.image = image
    }
    
    private func configureConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(userImageView)
        addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            userImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor),
            
            userNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    private enum Constants {
        static let imageSize: CGFloat = 56
    }
    
}
