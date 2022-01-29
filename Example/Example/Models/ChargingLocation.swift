//
//  ChargingLocation.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import Foundation

struct ChargingLocation: Codable, Identifiable {
    struct Address: Codable {
        let street: String
        let houseNumber: String
        let city: String
        
        var description: String {
            "\(street) \(houseNumber), \(city)"
        }
    }
    
    let id: String
    let address: Address
}
