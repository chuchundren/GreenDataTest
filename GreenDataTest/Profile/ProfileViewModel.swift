//
//  ProfileViewModel.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 08.10.2022.
//

import Foundation
import UIKit

final class ProfileViewModel {
    
    var coordinator: ProfileCoordinator?
    var user: RandomUser
    
    init(user: RandomUser) {
        self.user = user
    }
    
    func viewModel() -> ProfileViewController.ViewModel {
        let gender = user.gender == .female ? UIImage(systemName: "") : UIImage(systemName: "")
        return ProfileViewController.ViewModel(
            imageURL: user.picture.large,
            name: user.name.first + " " + user.name.last,
            genderIcon: gender,
            dateOfBirth: "\(user.dateOfBirth.date) (\(user.dateOfBirth.age) years)",
            email: user.email,
            localTime: "\(Date()) \(user.location.timezone.offset)"
        )
    }
    
}
