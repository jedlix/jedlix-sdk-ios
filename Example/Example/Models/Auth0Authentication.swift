//
//  Auth0Authentication.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import Foundation
import Auth0
import JWTDecode
import JedlixSDK

class Auth0Authentication {
    let realm = "Username-Password-Authentication"
    let scope = "openid offline_access create:connectsession read:connectsession modify:connectsession read:vehicle delete:vehicle read:charginglocations read:charger delete:charger"
    let audience: String
    let userIdentifierKey: String
    
    private let authentication: Auth0.Authentication
    private let credentialsManager: CredentialsManager
    
    init(
        clientId: String,
        domain: String,
        audience: String,
        userIdentifierKey: String
    ) {
        self.audience = audience
        self.userIdentifierKey = userIdentifierKey
        authentication = Auth0.authentication(clientId: clientId, domain: domain)
        credentialsManager = CredentialsManager(authentication: authentication)
        Task {
            switch await getUserIdentifier() {
            case .success(let userIdentifier):
                DispatchQueue.main.async {
                    User.current.state = .authenticated(userIdentifier: userIdentifier)
                }
            default:
                DispatchQueue.main.async {
                    User.current.state = .notAuthenticated
                }
            }
        }
    }
    
    func authenticate(email: String, password: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            authentication
                .login(
                    usernameOrEmail: email,
                    password: password,
                    realm: realm,
                    audience: audience,
                    scope: scope
                )
                .start { result in
                    switch result {
                    case .success(let credentials):
                        _ = self.credentialsManager.store(credentials: credentials)
                        Task {
                            switch await self.getUserIdentifier() {
                            case .success(let userIdentifier):
                                DispatchQueue.main.async {
                                    User.current.state = .authenticated(userIdentifier: userIdentifier)
                                    continuation.resume()
                                }
                            case .failure(let error):
                                continuation.resume(throwing: error)
                            }
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}

extension Auth0Authentication: Authentication {
    var isAuthenticated: Bool {
        credentialsManager.hasValid()
    }
    
    func getUserIdentifier() async -> AuthenticationResponse {
        guard let accessToken = await getAccessToken() else {
            return .failure(error: HTTPError.notAuthenticated)
        }
        do {
            let jwt = try decode(jwt: accessToken)
            guard let userIdentifier = jwt.body[self.userIdentifierKey] as? String else {
                fatalError("User identifier is nil")
            }
            return .success(userIdentifier: userIdentifier)
        } catch {
            fatalError("Could not decode JWT")
        }
    }
        
    func getAccessToken() async -> String? {
        return await withCheckedContinuation { continuation in
            credentialsManager.credentials { error, credentials in
                if let credentials = credentials, error == nil {
                    continuation.resume(returning: credentials.accessToken)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    func deauthenticate() {
        User.current.state = .notAuthenticated
        _ = credentialsManager.clear()
    }
}
