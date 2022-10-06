//
//  UICollectionReusableView+Extension.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 07.10.2022.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
