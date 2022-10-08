//
//  NavigationCoordinator.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 08.10.2022.
//

import UIKit
class NavigationCoordinator {
    unowned var navigationController: UINavigationController!
    
    func makeEntryPoint() -> UIViewController {
        fatalError("NavigationCoordinator is an abstract class. Implement makeEntryPoint() method in a subclass")
    }
    
    func makeRootFlow() -> UIViewController {
        let entry = makeEntryPoint()
        let navigationController = UINavigationController(rootViewController: entry)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .always
        
        self.navigationController = navigationController
        
        return navigationController
    }
    
    func open(child: NavigationCoordinator,
              navigationController: UINavigationController,
              animated: Bool = true) {
        let viewController = child.makeEntryPoint()
        child.navigationController = navigationController
        
        navigationController.pushViewController(viewController, animated: animated)
    }

    func open(child: NavigationCoordinator, animated: Bool = true) {
        open(
            child: child,
            navigationController: navigationController,
            animated: animated
        )
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
}
