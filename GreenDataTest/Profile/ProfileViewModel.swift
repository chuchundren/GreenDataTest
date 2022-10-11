//
//  ProfileViewModel.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 08.10.2022.
//

import Foundation
import UIKit

final class ProfileViewModel {
    
    var coordinator: ProfileCoordinator?
    private let user: UserViewModel
    private let api: RandomUserAPI
    
    private lazy var iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    private lazy var toStringFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    private lazy var localTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter
    }()
    
    init(user: UserViewModel, api: RandomUserAPI = .shared) {
        self.user = user
        self.api = api
    }
    
    func viewModel() -> ProfileViewController.ViewModel {
        let gender = user.gender == .female ? "👩".image(ofSize: 32) : "👨".image(ofSize: 32)
        let date = iso8601Formatter.date(from: user.dateOfBirth)
        var formattedDate = ""
        let yearsOfAge = user.age % 10 == 1 ? "year" : "years"
        
        if let date = date {
            formattedDate = toStringFormatter.string(from: date)
        }
        
        var localTime = ""
        if let secondsFromGMT = user.localTimeOffset.secondsFromGMT(),
           let timeZone = TimeZone(secondsFromGMT: secondsFromGMT) {
            localTimeFormatter.timeZone = timeZone
            localTime = localTimeFormatter.string(from: Date())
        }
        
        return ProfileViewController.ViewModel(
            imageURL: user.imageURL,
            name: user.name,
            genderIcon: gender,
            dateOfBirth: "Date of birth: \(formattedDate) (\(user.age) \(yearsOfAge))",
            email: user.email,
            localTime: "Local time: \(localTime)"
        )
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
    
}
