//
//  UserViewModel.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 11.10.2022.
//

import Foundation

struct UserViewModel {
    let name: String
    let imageURL: URL
    let gender: RandomUser.Gender
    let dateOfBirth: String
    let age: Int
    let localTimeOffset: String
    let email: String
}
