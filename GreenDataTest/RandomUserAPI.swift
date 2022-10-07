//
//  RandomUserAPI.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 07.10.2022.
//

import Foundation

struct RandomUserAPI {
    
    func getUsers(page: Int, completion: @escaping (Result<[RandomUser], Error>) -> Void) {
        guard let url = URL(string: "https://randomuser.me/api/?page=\(page)&results=20&seed=abc") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(RandomUserResult.self, from: data)
                    completion(.success(result.results))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
