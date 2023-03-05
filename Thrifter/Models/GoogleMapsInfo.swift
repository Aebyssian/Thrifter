//
//  CityNameGetter.swift
//  Thrifter
//
//  Created by Jacob Wilson on 3/2/23.
//

import Foundation

struct GoogleMapsInfo: Codable {
    let results: [Results]
}

struct Results: Codable {
    let address_components: [Address_Components]
}

struct Address_Components: Codable {
    let long_name: String
}

