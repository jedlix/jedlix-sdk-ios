//
//  ConnectView.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import SwiftUI
import JedlixSDK

struct ConnectView: View {       
    @State private var userIdentifier: String!
    @State private var isLoading = true
    @State private var vehicles = [Vehicle]()
    @State private var chargingLocations = [ChargingLocation]()
    @State private var selectedChargingLocation: ChargingLocation?
    @State private var chargers = [Charger]()
    @State private var isConnectViewPresented = false
    @State private var isAlertPresented = false
    @State private var alertTitle: String!
    @State private var alertMessage: String!
    
    private let httpClient: HTTPClient
    
    init(userIdentifier: String) {
        self.userIdentifier = userIdentifier
        self.httpClient = HTTPClient(userIdentifier: userIdentifier)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    Text("Loading…")
                } else {
                    VStack(spacing: 16) {
                        VehiclesView(
                            vehicles: vehicles,
                            onRemoveVehicle: { removeVehicle($0) },
                            onConnectVehicle: { connectVehicle() }
                        )
                        ChargersView(
                            chargingLocations: chargingLocations,
                            chargers: chargers,
                            onRemoveCharger: { removeCharger($0) },
                            onConnectCharger: { connectCharger(chargingLocation: $0) }
                        )
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Deauthenticate", action: deauthenticate))
            .padding()
        }
        .onAppear {
            reloadData()
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"), action: reloadData)
            )
        }
        .fullScreenCover(isPresented: $isConnectViewPresented, onDismiss: reloadData) {
            if let selectedChargingLocation = selectedChargingLocation {
                JedlixConnectView(
                    userIdentifier: userIdentifier,
                    sessionType: .charger(chargingLocationId: selectedChargingLocation.id)
                )
            } else {
                JedlixConnectView(
                    userIdentifier: userIdentifier,
                    sessionType: .vehicle
                )
            }
        }
    }
    
    private func deauthenticate() {
        authentication.deauthenticate()
    }
    
    private func connectVehicle() {
        selectedChargingLocation = nil
        isConnectViewPresented = true
    }
    
    private func connectCharger(chargingLocation: ChargingLocation) {
        selectedChargingLocation = chargingLocation
        isConnectViewPresented = true
    }
    
    private func reloadData() {
        performLoading {
            let vehicles = try await httpClient.getVehicles()
            let chargingLocations = try await httpClient.getChargingLocations()
            let chargers = try await httpClient.getChargers()
            DispatchQueue.main.async {
                self.vehicles = vehicles
                self.chargingLocations = chargingLocations
                self.chargers = chargers
            }
        }
    }
    
    private func removeVehicle(_ vehicle: Vehicle) {
        performLoading {
            try await httpClient.removeVehicle(vehicle)
            reloadData()
        }
    }
    
    private func removeCharger(_ charger: Charger) {
        performLoading {
            try await httpClient.removeCharger(charger)
            reloadData()
        }
    }
    
    private func performLoading(action: @escaping () async throws -> Void) {
        isLoading = true
        Task {
            do {
                try await action()
                DispatchQueue.main.async {
                    isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    isLoading = false
                    presentError(error)
                }
            }
        }
    }
    
    private func presentError(_ error: Error) {
        alertTitle = "Error"
        alertMessage = error.localizedDescription
        isAlertPresented = true
    }
}
