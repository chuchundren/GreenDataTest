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
    
    private lazy var formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            return formatter
        }()
    
    private lazy var toStringFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    init(user: RandomUser, api: RandomUserAPI = RandomUserAPI()) {
        self.user = user
        self.api = api
    }
    
    func viewModel() -> ProfileViewController.ViewModel {
        let gender = user.gender == .female ? "👩".image(ofSize: 32) : "👨".image(ofSize: 32)
        let date = formatter.date(from: user.dateOfBirth.date)
        var formattedDate = ""
        let yearsOfAge = user.dateOfBirth.age % 10 == 1 ? "year" : "years"
        
        if let date = date {
            formattedDate = toStringFormatter.string(from: date)
        }
        
        return ProfileViewController.ViewModel(
            imageURL: user.picture.large,
            name: user.name.first + " " + user.name.last,
            genderIcon: gender,
            dateOfBirth: "Date of birth: \(formattedDate) (\(user.dateOfBirth.age) \(yearsOfAge))",
            email: user.email,
            localTime: "Local time: \(Date()) \(user.location.timezone.offset)"
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

extension String {
    func image(ofSize fontSize: CGFloat) -> UIImage? {
        let size = CGSize(width: fontSize, height: fontSize)
        let rect = CGRect(origin: CGPoint(), size: size)
        return UIGraphicsImageRenderer(size: size).image { (context) in
            (self as NSString).draw(in: rect, withAttributes: [.font : UIFont.systemFont(ofSize: fontSize - 8)])
        }
    }
}
