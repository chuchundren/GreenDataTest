//
//  RandomUserAPI.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 07.10.2022.
//

import Foundation
import UIKit

struct RandomUserAPI {
    typealias Cancellable = () -> Void
    private var imageCache = NSCache<NSString, NSData>()
    
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
    
    func loadImage(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> Cancellable? {
        if let data = imageCache.object(forKey: url.absoluteString as NSString) as? Data,
           let image = UIImage(data: data) {
            completion(.success(image))
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                imageCache.setObject(data as NSData, forKey: url.absoluteString as NSString)
                completion(.success(image))
            }
            
            guard let error = error else {
                return
            }
            
            completion(.failure(error))
        }
        
        task.resume()
        
        return task.cancel
    }
}
