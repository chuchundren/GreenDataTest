//
//  RandomUser.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 07.10.2022.
//

import Foundation


struct RandomUserResult: Codable {
    let results: [RandomUser]
}

struct RandomUser: Codable {
    let gender: Gender
    let name: Name
    let login: Login
    let email: String
    let dateOfBirth: DateOfBirth
    let location: Location
    let picture: Picture
    
    enum CodingKeys: String, CodingKey {
        case dateOfBirth = "dob"
        case gender, name, login, email, location, picture
    }
    
    enum Gender: String, Codable {
        case male, female
    }
    
    struct Login: Codable {
        let uuid: String
    }
    
    struct Name: Codable {
        let first: String
        let last: String
    }
    
    struct Picture: Codable {
        let large: URL
        let medium: URL
        let thumbnail: URL
    }
    
    struct DateOfBirth: Codable {
        let date: String
        let age: Int
    }
    
    struct Location: Codable {
        let timezone: Timezone
    }
    
    struct Timezone: Codable {
        let offset: String
        let description: String
    }
    
}
