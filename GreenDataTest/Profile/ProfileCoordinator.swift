//
//  ProfileCoordinator.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 07.10.2022.
//

import Foundation
import UIKit

class ProfileCoordinator: NavigationCoordinator {
    private var user: UserViewModel
    
    init(user: UserViewModel) {
        self.user = user
    }
    
    override func makeEntryPoint() -> UIViewController {
        let vm = ProfileViewModel(user: user)
        vm.coordinator = self
        
        let view = ProfileViewController(viewModel: vm)
        view.title = "Profile"
        view.onImageTap = openImageFullScreen(_:)
        
        return view
    }
    
    private func openImageFullScreen(_ url: URL) {
        let fullScreenImageCoordinator = FullScreenImageCoordinator(imageURL: url)
        open(child: fullScreenImageCoordinator)
    }
    
}
