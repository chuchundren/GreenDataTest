//
//  ProfileViewController.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 07.10.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let userImageView = UIImageView()
    private let nameLabel = UILabel()
    private let genderIcon = UIImageView()
    private let dateOfBirthLabel = UILabel()
    private let emailLabel = UILabel()
    private let localTimeLabel = UILabel()
    
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .white
        
        configureConstaints()
        configure(with: viewModel.viewModel())
    }
    
    func configure(with userProfile: ViewModel) {
        userImageView.image = UIImage(systemName: "person.fill")
        nameLabel.text = userProfile.name
        genderIcon.image = userProfile.genderIcon
        dateOfBirthLabel.text = userProfile.dateOfBirth
        emailLabel.text = userProfile.email
        localTimeLabel.text = userProfile.localTime
    }

    private func configureConstaints() {
        [userImageView, nameLabel, genderIcon, dateOfBirthLabel, emailLabel, localTimeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            genderIcon.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            genderIcon.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            
            dateOfBirthLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            dateOfBirthLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dateOfBirthLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: dateOfBirthLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            localTimeLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            localTimeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
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
