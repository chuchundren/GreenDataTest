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
    
    private var usersApi: [RandomUser] = []
    private var usersCache: [CDRandomUser] = []
    private(set) var usersViewModels: [UserViewModel] = []
    
    private var page = 1
    private var requests = 0
    private var fetchedFromCache = false
    
    init(api: RandomUserAPI = .shared, store: CoreDataStore = .shared) {
        self.api = api
        self.store = store
    }
    
    func requestUsersForTheNextPage() {
        guard requests == 0 else {
            return
        }
        
        requests += 1
        api.getUsers(page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.appendUsers(users)
            case .failure(let error):
                print(error)
                if !self.fetchedFromCache {
                    self.appendUsers(self.store.fetchUsers())
                    self.fetchedFromCache = true
                    print("fetch")
                }
            }
            
            self.requests -= 1
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
    
    func didAskToOpenProfile(of user: UserViewModel) {
        coordinator?.openProfile(user)
    }
    
    private func appendUsers(_ users: [RandomUser]) {
        usersApi += users
        usersViewModels = map(usersApi)
        
        page += 1
        usersChanged()
        store.cacheUsers(users)
    }
    
    private func appendUsers(_ users: [CDRandomUser]) {
        usersCache += users
        usersViewModels = map(usersCache)
        usersChanged()
    }
    
    private func map(_ users: [RandomUser]) -> [UserViewModel] {
        users.map { user in
            return UserViewModel(
                name: user.name.first + " " + user.name.last,
                imageURL: user.picture.large,
                gender: user.gender,
                dateOfBirth: user.dateOfBirth.date,
                age: user.dateOfBirth.age,
                localTimeOffset: user.location.timezone.offset,
                email: user.email
            )
        }
    }
    
    private func map(_ users: [CDRandomUser]) -> [UserViewModel] {
        users.compactMap { user in
            let name = "\(user.name?.first ?? "") \(user.name?.last ?? "")"
            if let url = user.picture?.large,
               let gender = RandomUser.Gender(rawValue: user.gender ?? ""),
               let dateOfBirth = user.dateOfBirth?.date,
               let age = user.dateOfBirth?.age,
               let offset = user.location?.timezone?.offset,
               let email = user.email {
                
                return UserViewModel(
                    name: name,
                    imageURL: url,
                    gender: gender,
                    dateOfBirth: dateOfBirth,
                    age: Int(age),
                    localTimeOffset: offset,
                    email: email
                )
            } else {
                return nil
            }
        }
    }
    
}
