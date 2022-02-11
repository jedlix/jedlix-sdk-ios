//
//  Vehicle.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import Foundation

struct Vehicle: Codable, Identifiable {
    struct Details: Codable {
        let brand: String
        let model: String
        
        var description: String {
            "\(brand) \(model)"
        }
    }
    
    let id: String
    let details: Details
}
