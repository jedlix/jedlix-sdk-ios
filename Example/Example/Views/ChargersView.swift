//
//  ChargersView.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import SwiftUI
import JedlixSDK

struct ChargersView: View {
    let userIdentifier: String
    let chargingLocations: [ChargingLocation]
    let chargers: [Charger]
    let connectSessions: [ChargerConnectSession]
    let onRemoveCharger: (Charger) -> Void
    let onReloadData: () -> Void
    
    @State private var isConnectViewPresented = false
    
    var body: some View {
        VStack {
            Text("Chargers").font(.headline)
            if chargingLocations.count > 0 {
                ForEach(chargingLocations) { chargingLocation in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(chargingLocation.address.description).bold()
                        let chargers = chargers(at: chargingLocation)
                        if chargers.count > 0 {
                            ForEach(chargers) { charger in
                                chargerView(chargingLocation: chargingLocation, charger: charger)
                            }
                        } else {
                            noChargerView(chargingLocation: chargingLocation)
                        }
                    }
                    .sectionBackground()
                }
            } else {
                Text("No charging locations found")
                    .sectionBackground()
            }
        }
        .onChange(of: isConnectViewPresented) { newValue in
            if !newValue {
                onReloadData()
            }
        }
    }
    
    func chargerView(chargingLocation: ChargingLocation, charger: Charger) -> some View {
        HStack {
            Text(charger.detail.description)
            Spacer()
            VStack {
                if let connectSession = connectSessions.first(where: {
                    $0.chargingLocationId == chargingLocation.id &&
                    $0.chargerId == charger.id
                }) {
                    NavigationLink("Resume", isActive: $isConnectViewPresented) {
                        ConnectSessionView(
                            userIdentifier: userIdentifier,
                            sessionIdentifier: connectSession.id
                        )
                    }
                }
                Button("Remove") { onRemoveCharger(charger) }
                    .foregroundColor(.red)
            }
        }
    }
    
    func noChargerView(chargingLocation: ChargingLocation) -> some View {
        HStack {
            if let connectSession = connectSessions.first(where: {
                $0.chargingLocationId == chargingLocation.id &&
                $0.chargerId == nil
            }) {
                Text("Unfinished connect session")
                Spacer()
                NavigationLink("Resume", isActive: $isConnectViewPresented) {
                    ConnectSessionView(
                        userIdentifier: userIdentifier,
                        sessionIdentifier: connectSession.id
                    )
                }
            } else {
                Text("No chargers found")
                Spacer()
                NavigationLink("Connect", isActive: $isConnectViewPresented) {
                    ConnectSessionView(
                        userIdentifier: userIdentifier,
                        sessionType: .charger(chargingLocationId: chargingLocation.id)
                    )
                }
            }
        }
    }
    
    private func chargers(at location: ChargingLocation) -> [Charger] {
        chargers.filter { $0.chargingLocationId == location.id }
    }
}
