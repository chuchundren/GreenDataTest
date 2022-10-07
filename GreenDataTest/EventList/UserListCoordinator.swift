//
//  UserListCoordinator.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 07.10.2022.
//

import UIKit

class UserListCoordinator {
    
    private weak var navigationController: UINavigationController?

    func start() -> UIViewController {
        let vm = UserListViewModel()
        vm.coordinator = self
        
        let view = UserListViewController(viewModel: vm)
        let navController = UINavigationController(rootViewController: view)
        
        navController.navigationBar.prefersLargeTitles = true
        navigationController = navController
        
        return navController
    }
    
}

