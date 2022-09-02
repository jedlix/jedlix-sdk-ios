//
//  VehiclesView.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import SwiftUI
import JedlixSDK

struct VehiclesView: View {
    let userIdentifier: String
    let vehicles: [Vehicle]
    let connectSessions: [VehicleConnectSession]
    let onRemoveVehicle: (Vehicle) -> Void
    let onReloadData: () -> Void
    
    @State private var isConnectViewPresented = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Vehicles").font(.headline)
            if vehicles.count > 0 {
                ForEach(vehicles) { vehicle in
                    HStack {
                        Text(vehicle.details.description)
                        Spacer()
                        VStack {
                            if let connectSession = connectSessions.first { $0.vehicleId == vehicle.id } {
                                NavigationLink("Resume", isActive: $isConnectViewPresented) {
                                    ConnectSessionView(
                                        userIdentifier: userIdentifier,
                                        sessionIdentifier: connectSession.id
                                    )
                                }
                            }
                            Button("Remove") { onRemoveVehicle(vehicle) }
                                .foregroundColor(.red)
                        }
                    }
                }
            } else {
                HStack {
                    if let connectSession = connectSessions.first { $0.vehicleId == nil } {
                        Text("Unfinished connect session")
                        Spacer()
                        NavigationLink("Resume", isActive: $isConnectViewPresented) {
                            ConnectSessionView(
                                userIdentifier: userIdentifier,
                                sessionIdentifier: connectSession.id
                            )
                        }
                    } else {
                        Text("No vehicles found")
                        Spacer()
                        NavigationLink("Connect", isActive: $isConnectViewPresented) {
                            ConnectSessionView(
                                userIdentifier: userIdentifier,
                                sessionType: .vehicle
                            )
                        }
                    }
                }
            }
        }
        .sectionBackground()
        .onChange(of: isConnectViewPresented) { newValue in
            if newValue == false {
                onReloadData()
            }
        }
    }
}
