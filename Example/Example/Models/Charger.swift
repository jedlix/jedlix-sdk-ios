//
//  Charger.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import Foundation

struct Charger: Codable, Identifiable {
    struct Detail: Codable {
        let brand: String
        let model: String
        
        var description: String {
            "\(brand) \(model)"
        }
    }
    
    let id: String
    let chargingLocationId: String
    let homeChargerDetail: Detail
}
