//
//  DefaultAuthentication.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import Foundation
import JedlixSDK

class DefaultAuthentication {
    private static let accessTokenKey = "accessTokenKey"
    private static let userIdentifierKey = "userIdentifierKey"
    
    init() {
        Task {
            if await getAccessToken() != nil,
                case let .success(userIdentifier) = await getUserIdentifier() {
                User.current.state = .authenticated(userIdentifier: userIdentifier)
            } else {
                User.current.state = .notAuthenticated
            }
        }
    }
    
    func authenticate(accessToken: String, userIdentifier: String) {
        let defaults = UserDefaults.standard
        defaults.set(accessToken, forKey: DefaultAuthentication.accessTokenKey)
        defaults.set(userIdentifier, forKey: DefaultAuthentication.userIdentifierKey)
        DispatchQueue.main.async {
            User.current.state = .authenticated(userIdentifier: userIdentifier)
        }
    }
}

extension DefaultAuthentication: Authentication {    
    var isAuthenticated: Bool {
        switch User.current.state {
        case .authenticated: return true
        default: return false
        }
    }
    
    func getUserIdentifier() async -> AuthenticationResponse {
        let defaults = UserDefaults.standard
        if let userIdentifier = defaults.string(forKey: DefaultAuthentication.userIdentifierKey) {
            return .success(userIdentifier: userIdentifier)
        } else {
            return .failure(error: HTTPError.notAuthenticated)
        }
    }
    
    func getAccessToken() async -> String? {
        let defaults = UserDefaults.standard
        if let accessToken = defaults.string(forKey: DefaultAuthentication.accessTokenKey) {
            return accessToken
        } else {
            return nil
        }
    }
    
    func deauthenticate() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: DefaultAuthentication.accessTokenKey)
        defaults.removeObject(forKey: DefaultAuthentication.userIdentifierKey)
        User.current.state = .notAuthenticated
    }
}
