//
//  LoaderReusableView.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 08.10.2022.
//

import UIKit

class LoaderReusableView: UICollectionReusableView {
    private let loader = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loader.startAnimating()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        loader.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loader)
        
        NSLayoutConstraint.activate([
            loader.centerYAnchor.constraint(equalTo: centerYAnchor),
            loader.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
