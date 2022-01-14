//
//  AuthenticationView.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import SwiftUI
import Auth0
import JWTDecode

struct AuthenticationView: View {
    @EnvironmentObject private var authentication: Authentication
    @State private var userEmail = ""
    @State private var userPassword = ""
    @State private var accessToken = ""
    @State private var userIdentifier = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var isAuth0Enabled = Authentication.Auth0.isEnabled
    
    var body: some View {
        VStack {
            Spacer()
            if (isAuth0Enabled) {
                Text("Authenticate a user with Auth0:")
                TextField("Email", text: $userEmail)
                    .textFieldStyle(ExampleTextFieldStyle())
                SecureField("Password", text: $userPassword)
                    .textFieldStyle(ExampleTextFieldStyle())
                Button(isLoading ? "Loading…" : "Authenticate", action: authenticateWithAuth0)
                    .buttonStyle(ExampleButtonStyle())
                    .disabled(isLoading)
            } else {
                Text("Authenticate a user:")
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
        authentication.authenticate(accessToken: accessToken, userIdentifier: userIdentifier)
    }
    
    private func authenticateWithAuth0() {
        isLoading = true
        Auth0.authentication(clientId: Authentication.Auth0.clientId, domain: Authentication.Auth0.domain)
            .login(
                usernameOrEmail: userEmail,
                password: userPassword,
                realm: Authentication.Auth0.realm,
                audience: Authentication.Auth0.audience,
                scope: Authentication.Auth0.scope
            )
            .start { result in
                DispatchQueue.main.async {
                    isLoading = false
                    switch result {
                    case .success(let credentials):
                        guard let accessToken = credentials.accessToken else {
                            fatalError("Access token is nil")
                        }
                        do {
                            let jwt = try decode(jwt: accessToken)
                            guard let userIdentifier = jwt.body[Authentication.Auth0.userIdentifierKey] as? String else {
                                fatalError("User identifier is nil")
                            }
                            authentication.authenticate(accessToken: accessToken, userIdentifier: userIdentifier)
                        } catch {
                            fatalError("Could not decode JWT")
                        }
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
    }
}
