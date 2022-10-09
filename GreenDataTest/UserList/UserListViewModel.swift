//
//  UserListViewModel.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 07.10.2022.
//

import Foundation
import UIKit

final class UserListViewModel {
    var coordinator: UserListCoordinator?
    private var api: RandomUserAPI
    private var store: CoreDataStore
    private var users: [RandomUser] = []
    private var page = 0
    private var semaphore = DispatchSemaphore(value: 1)
    
    init(api: RandomUserAPI = RandomUserAPI(), store: CoreDataStore = .shared) {
        self.api = api
        self.store = store
    }
    
    func requestUsersForTheNextPage(completion: @escaping ([RandomUser]) -> Void) {
        semaphore.wait()
        page += 1
        api.getUsers(page: page) { [weak self] result in
            switch result {
            case .success(let users):
                self?.users += users
                self?.store.cacheUsers(users)
                completion(users)
            case .failure(let error):
                print(error)
                completion([])
            }
            self?.semaphore.signal()
        }
    }
    
    func loadImage(url: URL, completion: @escaping (UIImage?) -> Void) -> RandomUserAPI.Cancellable? {
        return api.loadImage(url: url) { result in
            switch result {
            case .success(let image):
                completion(image)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func formatName(of model: RandomUser) -> String {
        model.name.first + " " + model.name.last
    }
    
    func didAskToOpenProfile(of user: RandomUser) {
        coordinator?.openProfile(user)
    }
    
}
