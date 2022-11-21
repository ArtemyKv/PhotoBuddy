//
//  Location.swift
//  SimpleUnsplashPhoto
//
//  Created by Artem Kvashnin on 14.11.2022.
//

import Foundation

struct Location: Codable {
    var city: String?
    var country: String?
}

extension Location: CustomStringConvertible {
    var description: String {
        if let city = city, let country = country {
            return "\(city), \(country)"
        } else if let city = city, country == nil {
            return "\(city)"
        } else if let country = country, city == nil {
            return "\(country)"
        } else {
            return " - "
        }
    }
    
    
}
