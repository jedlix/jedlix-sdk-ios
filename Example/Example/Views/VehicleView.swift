//
//  VehicleView.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import SwiftUI
import JedlixSDK

struct VehicleView: View {
    @EnvironmentObject private var authentication: Authentication
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var vehicle: Vehicle?
    @State private var isConnectViewPresented = false
    @State private var sessionIdentifier: String?
    
    private let httpClient: HTTPClient
    
    init(user: User) {
        httpClient = HTTPClient(user: user)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                if isLoading {
                    Text("Loading…")
                } else {
                    if let vehicle = vehicle {
                        Text(vehicle.vehicleDetails.description)
                        Button("Remove", action: removeVehicle)
                            .buttonStyle(ExampleButtonStyle(.red))
                    } else {
                        Text("No vehicles found")
                        Button("Connect", action: connect)
                            .buttonStyle(ExampleButtonStyle())
                    }
                }
                if let errorMessage = errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Deauthenticate", action: deauthenticate))
            .padding()
        }
        .onAppear {
            loadVehicles()
        }
        .fullScreenCover(isPresented: $isConnectViewPresented, onDismiss: loadVehicles) {
            if let user = authentication.user {
                if let sessionIdentifier = sessionIdentifier, !isConnectViewPresented {
                    JedlixConnectView(
                        accessToken: user.accessToken,
                        userIdentifier: user.identifier,
                        sessionIdentifier: sessionIdentifier
                    )
                } else {
                    JedlixConnectView(
                        accessToken: user.accessToken,
                        userIdentifier: user.identifier
                    ) { sessionIdentifier in
                        self.sessionIdentifier = sessionIdentifier
                    }
                }
            }
        }
    }
    
    private func deauthenticate() {
        authentication.deauthenticate()
    }
    
    private func connect() {
        isConnectViewPresented = true
    }
    
    private func loadVehicles() {
        isLoading = true
        Task {
            do {
                let vehicle = try await httpClient.getVehicles().first
                isLoading = false
                self.vehicle = vehicle
                errorMessage = nil
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func removeVehicle() {
        isLoading = true
        Task {
            do {
                guard let vehicle = vehicle else { fatalError("Vehicle cannot be nil") }
                try await httpClient.removeVehicle(vehicle)
                isLoading = false
                self.vehicle = nil
                errorMessage = nil
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
}
