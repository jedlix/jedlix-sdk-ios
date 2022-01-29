//
//  ChargersView.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import SwiftUI

struct ChargersView: View {
    var chargingLocations: [ChargingLocation]
    var chargers: [Charger]
    let onRemoveCharger: (Charger) -> Void
    let onConnectCharger: (ChargingLocation) -> Void
    
    var body: some View {
        VStack {
            Text("Chargers").font(.headline)
            if chargingLocations.count > 0 {
                ForEach(chargingLocations) { chargingLocation in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(chargingLocation.address.description).bold()
                        if let chargers = chargers(at: chargingLocation), chargers.count > 0 {
                            ForEach(chargers) { charger in
                                HStack {
                                    Text(charger.homeChargerDetail.description)
                                    Spacer()
                                    Button("Remove") {
                                        onRemoveCharger(charger)
                                    }
                                    .foregroundColor(.red)
                                }
                            }
                        } else {
                            HStack {
                                Text("No chargers found")
                                Spacer()
                                Button("Connect") { onConnectCharger(chargingLocation) }
                            }
                        }
                    }
                    .sectionBackground()
                }
            } else {
                Text("No charging locations found")
                    .sectionBackground()
            }
        }
    }
    
    private func chargers(at location: ChargingLocation) -> [Charger] {
        chargers.filter { $0.chargingLocationId == location.id }
    }
}
