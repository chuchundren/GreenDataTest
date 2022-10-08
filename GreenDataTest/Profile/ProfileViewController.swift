//
//  ProfileViewController.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 07.10.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let loader = UIActivityIndicatorView()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let genderIcon = UIImageView()
    private let dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let localTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let viewModel: ProfileViewModel
    private var cancelLoading: (() -> Void)?
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        portraitConstraints = constraintsForPortraitOrientation()
        landscapeConstraints = constraintsForLandscapeOrientation()
        
        configureConstaints()
        configure(with: viewModel.viewModel())
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        activateConstaints(orientationIsPortrait:  UIDevice.current.orientation.isPortrait || !UIDevice.current.orientation.isLandscape)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelLoading?()
    }
    
    func configure(with userProfile: ViewModel) {
        loader.startAnimating()
        cancelLoading = viewModel.loadImage(url: userProfile.imageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.userImageView.image = image
                self?.loader.stopAnimating()
            }
        }
        
        nameLabel.text = userProfile.name
        genderIcon.image = userProfile.genderIcon
        dateOfBirthLabel.text = userProfile.dateOfBirth
        emailLabel.text = userProfile.email
        localTimeLabel.text = userProfile.localTime
    }

    private func configureConstaints() {
        [userImageView, loader, nameLabel, genderIcon, dateOfBirthLabel, emailLabel, localTimeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        activateConstaints(orientationIsPortrait: UIDevice.current.orientation.isPortrait || !UIDevice.current.orientation.isLandscape)
    }
    
    private func activateConstaints(orientationIsPortrait: Bool) {
        NSLayoutConstraint.deactivate(portraitConstraints)
        NSLayoutConstraint.deactivate(landscapeConstraints)
        
        if orientationIsPortrait {
            NSLayoutConstraint.activate(portraitConstraints)
        } else {
            NSLayoutConstraint.activate(landscapeConstraints)
        }
        
        view.layoutIfNeeded()
    }
    
    private func constraintsForPortraitOrientation() -> [NSLayoutConstraint] {
        [
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor),
            
            loader.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            loader.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            genderIcon.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            genderIcon.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            dateOfBirthLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 12),
            dateOfBirthLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            localTimeLabel.topAnchor.constraint(equalTo: dateOfBirthLabel.bottomAnchor, constant: 4),
            localTimeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ]
    }
    
    private func constraintsForLandscapeOrientation() -> [NSLayoutConstraint] {
        [
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            userImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor),
            
            loader.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            loader.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            
            genderIcon.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            genderIcon.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            dateOfBirthLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 12),
            dateOfBirthLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            localTimeLabel.topAnchor.constraint(equalTo: dateOfBirthLabel.bottomAnchor, constant: 4),
            localTimeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ]
    }
    
    struct ViewModel {
        let imageURL: URL
        let name: String
        let genderIcon: UIImage?
        let dateOfBirth: String
        let email: String
        let localTime: String
    }
}
