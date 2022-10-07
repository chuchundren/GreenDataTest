//
//  UserListViewModel.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 07.10.2022.
//

import Foundation
import UIKit

final class UserListViewModel {
    weak var coordinator: UserListCoordinator?
    private var api: RandomUserAPI
    private var users: [RandomUser] = []
    private var page = 0
    
    init(api: RandomUserAPI = RandomUserAPI()) {
        self.api = api
    }
    
    func requestUsersForTheNextPage(completion: @escaping ([RandomUser]) -> Void) {
        page += 1
        api.getUsers(page: page) { result in
            switch result {
            case .success(let users):
                self.users += users
                completion(users)
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
    
    func loadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        api.loadImage(url: url) { result in
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
    
}
