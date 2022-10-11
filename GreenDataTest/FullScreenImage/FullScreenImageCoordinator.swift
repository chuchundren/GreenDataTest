//
//  FullScreenImageCoordinator.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 11.10.2022.
//

import UIKit

final class FullScreenImageCoordinator: NavigationCoordinator {
    
    private let url: URL
    
    init(imageURL: URL) {
        self.url = imageURL
    }
    
    override func makeEntryPoint() -> UIViewController {
        let vm = FullScreenImageViewModel(imageURL: url)
        vm.coordinator = self
        
        let view = FullScreenImageViewController(viewModel: vm)
        return view
    }
    
}
