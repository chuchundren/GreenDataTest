//
//  RandomUserAPI.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 07.10.2022.
//

import Foundation
import UIKit

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
    
    func loadImage(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            }
            
            guard let error = error else {
                return
            }
            
            completion(.failure(error))
        }
        
        task.resume()
    }
}
