//
//  ProfileCoordinator.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 07.10.2022.
//

import Foundation
import UIKit

class ProfileCoordinator: NavigationCoordinator {
    private var user: RandomUser
    
    init(user: RandomUser) {
        self.user = user
    }
    
    override func makeEntryPoint() -> UIViewController {
        let vm = ProfileViewModel(user: user)
        vm.coordinator = self
        
        let view = ProfileViewController(viewModel: vm)
        view.title = "Profile"
        
        return view
    }
}
