//
//  AuthenticationView.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import SwiftUI
import JedlixSDK

struct AuthenticationView: View {
    @State private var userEmail = ""
    @State private var userPassword = ""
    @State private var accessToken = ""
    @State private var userIdentifier = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if (authentication is Auth0Authentication) {
                Text("Authenticate a user with Auth0:").font(.headline)
                TextField("Email", text: $userEmail)
                    .textFieldStyle(ExampleTextFieldStyle())
                SecureField("Password", text: $userPassword)
                    .textFieldStyle(ExampleTextFieldStyle())
                Button(isLoading ? "Loading…" : "Authenticate", action: authenticateWithAuth0)
                    .buttonStyle(ExampleButtonStyle())
                    .disabled(isLoading)
            } else {
                Text("Authenticate a user:").font(.headline)
                TextField("Access token", text: $accessToken)
                    .textFieldStyle(ExampleTextFieldStyle())
                TextField("User identifier", text: $userIdentifier)
                    .textFieldStyle(ExampleTextFieldStyle())
                Button(isLoading ? "Loading…" : "Authenticate", action: authenticate)
                    .buttonStyle(ExampleButtonStyle())
                    .disabled(isLoading)
            }
            if let errorMessage = errorMessage {
                Text(errorMessage).foregroundColor(.red)
            }
            Spacer()
        }
        .padding()
    }
    
    private func authenticate() {
        let authentication = authentication as! DefaultAuthentication
        authentication.authenticate(accessToken: accessToken, userIdentifier: userIdentifier)
    }
    
    private func authenticateWithAuth0() {
        Task {
            isLoading = true
            do {
                let authentication = authentication as! Auth0Authentication
                try await authentication.authenticate(email: userEmail, password: userPassword)
            } catch {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                }
            }
            isLoading = false
        }
    }
}
