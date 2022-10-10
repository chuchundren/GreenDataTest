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
    
    var usersChanged: () -> Void = {}
    
    private(set) var users: [RandomUser] = []
    
    private var page = 1
    private var semaphore = DispatchSemaphore(value: 1)
    private var requests = 0
    
    init(api: RandomUserAPI = RandomUserAPI(), store: CoreDataStore = .shared) {
        self.api = api
        self.store = store
    }
    
    func requestUsersForTheNextPage() {
        semaphore.wait()
        api.getUsers(page: page) { [weak self] result in
            switch result {
            case .success(let users):
                self?.appendUsers(users)
            case .failure(let error):
                print(error)
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
    
    private func appendUsers(_ users: [RandomUser]) {
        self.users += users
        page += 1
        usersChanged()
        store.cacheUsers(users)
    }
    
}
