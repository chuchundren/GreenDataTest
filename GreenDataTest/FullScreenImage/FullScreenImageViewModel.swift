//
//  FullScreenImageViewModel.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 11.10.2022.
//

import UIKit


final class FullScreenImageViewModel {
    
    private var imageURL: URL
    private var api: RandomUserAPI
    
    var coordinator: FullScreenImageCoordinator?
    var onRecieveImage: ((UIImage) -> Void)?
    
    init(imageURL: URL, api: RandomUserAPI = .shared) {
        self.imageURL = imageURL
        self.api = api
    }
    
    func loadImage() -> RandomUserAPI.Cancellable? {
        return api.loadImage(url: imageURL) { [weak self] result in
            switch result {
            case .success(let image):
                self?.onRecieveImage?(image)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
