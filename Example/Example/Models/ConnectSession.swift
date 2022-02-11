//
//  ConnectSession.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import Foundation

protocol ConnectSession: Codable {
    var id: String { get }
}

class VehicleConnectSession: ConnectSession {
    let id: String
    let vehicleId: String?
    
    init(id: String, vehicleId: String?) {
        self.id = id
        self.vehicleId = vehicleId
    }
}

class ChargerConnectSession: ConnectSession {
    let id: String
    let chargerId: String?
    let chargingLocationId: String
    
    init(id: String, chargerId: String?, chargingLocationId: String) {
        self.id = id
        self.chargerId = chargerId
        self.chargingLocationId = chargingLocationId
    }
}
