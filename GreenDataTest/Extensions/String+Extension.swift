//
//  String+Extension.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 10.10.2022.
//

import UIKit

extension String {
    func image(ofSize fontSize: CGFloat) -> UIImage? {
        let size = CGSize(width: fontSize, height: fontSize)
        let rect = CGRect(origin: CGPoint(), size: size)
        return UIGraphicsImageRenderer(size: size).image { (context) in
            (self as NSString).draw(in: rect, withAttributes: [.font : UIFont.systemFont(ofSize: fontSize - 8)])
        }
    }
    
    func secondsFromGMT() -> Int? {
        let sign = self.first
        let comps = sign != "0" ? self.dropFirst().components(separatedBy: ":") : self.components(separatedBy: ":")
        
        guard let hours = Int(comps.first ?? ""), let minutes = Int(comps.last ?? "") else {
            return nil
        }
        
        let seconds = hours * 60 * 60 + minutes * 60
        
        if seconds == 0 {
            return 0
        }
        
        if sign == "+" {
            return seconds
        } else if sign == "-" {
            return -seconds
        }
        
        return nil
    }
    
}
