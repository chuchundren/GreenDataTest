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
    private let user: RandomUser
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
    
    init(user: RandomUser, api: RandomUserAPI = .shared) {
        self.user = user
        self.api = api
    }
    
    func viewModel() -> ProfileViewController.ViewModel {
        let gender = user.gender == .female ? "👩".image(ofSize: 32) : "👨".image(ofSize: 32)
        let date = iso8601Formatter.date(from: user.dateOfBirth.date)
        var formattedDate = ""
        let yearsOfAge = user.dateOfBirth.age % 10 == 1 ? "year" : "years"
        
        if let date = date {
            formattedDate = toStringFormatter.string(from: date)
        }
        
        var localTime = ""
        if let secondsFromGMT = user.location.timezone.offset.secondsFromGMT(),
           let timeZone = TimeZone(secondsFromGMT: secondsFromGMT) {
            localTimeFormatter.timeZone = timeZone
            localTime = localTimeFormatter.string(from: Date())
        }
        
        return ProfileViewController.ViewModel(
            imageURL: user.picture.large,
            name: user.name.first + " " + user.name.last,
            genderIcon: gender,
            dateOfBirth: "Date of birth: \(formattedDate) (\(user.dateOfBirth.age) \(yearsOfAge))",
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
