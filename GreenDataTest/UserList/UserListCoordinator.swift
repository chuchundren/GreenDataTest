//
//  UserListCoordinator.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 07.10.2022.
//

import UIKit

final class UserListCoordinator: NavigationCoordinator {
    
    override func makeEntryPoint() -> UIViewController {
        let vm = UserListViewModel()
        vm.coordinator = self
        
        let view = UserListViewController(viewModel: vm)
        view.title = "Random users"
        
        return view
    }
    
}
