//
//  VehiclesView.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import SwiftUI

struct VehiclesView: View {
    let vehicles: [Vehicle]
    let onRemoveVehicle: (Vehicle) -> Void
    let onConnectVehicle: () -> Void
    
    var body: some View {
        VStack {
            Text("Vehicles").font(.headline)
            HStack {
                if vehicles.count > 0 {
                    ForEach(vehicles) { vehicle in
                        HStack {
                            Text(vehicle.vehicleDetails.description)
                            Spacer()
                            Button("Remove") { onRemoveVehicle(vehicle) }
                                .foregroundColor(.red)
                        }
                    }
                } else {
                    Text("No vehicles found")
                    Spacer()
                    Button("Connect") { onConnectVehicle() }
                }
            }
            .sectionBackground()
        }
    }
}
