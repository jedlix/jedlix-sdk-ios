//
//  MainView.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import SwiftUI
import JedlixSDK

struct ConnectionsView: View {
    @State private var isLoading = true
    @State private var vehicles = [Vehicle]()
    @State private var chargingLocations = [ChargingLocation]()
    @State private var chargers = [Charger]()
    @State private var vehicleSessions = [VehicleConnectSession]()
    @State private var chargerSessions = [ChargerConnectSession]()
    @State private var isAlertPresented = false
    @State private var alertTitle: String!
    @State private var alertMessage: String!
    
    private let userIdentifier: String!
    private let httpClient: HTTPClient

    init(userIdentifier: String) {
        guard JedlixSDK.isConfigured else {
            fatalError("Jedlix SDK not configured")
        }
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
                            userIdentifier: userIdentifier,
                            vehicles: vehicles,
                            connectSessions: vehicleSessions,
                            onRemoveVehicle: { removeVehicle($0) },
                            onReloadData: reloadData
                        )
                        ChargersView(
                            userIdentifier: userIdentifier,
                            chargingLocations: chargingLocations,
                            chargers: chargers,
                            connectSessions: chargerSessions,
                            onRemoveCharger: { removeCharger($0) },
                            onReloadData: reloadData
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
                dismissButton: .default(Text("OK")) { reloadData() }
            )
        }
    }
    
    private func deauthenticate() {
        authentication.deauthenticate()
    }
    
    private func reloadData() {
        performLoading {
            let vehicles = try await httpClient.getVehicles()
            let chargingLocations = try await httpClient.getChargingLocations()
            let chargers = try await httpClient.getChargers()
            let vehicleSessions: [VehicleConnectSession] = try await JedlixSDK.getVehicleConnectSessions(userId: userIdentifier)
            let chargerSessions: [ChargerConnectSession] = try await JedlixSDK.getChargerConnectSessions(userId: userIdentifier)
            DispatchQueue.main.async {
                self.vehicles = vehicles
                self.chargingLocations = chargingLocations
                self.chargers = chargers
                self.vehicleSessions = vehicleSessions
                self.chargerSessions = chargerSessions
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
