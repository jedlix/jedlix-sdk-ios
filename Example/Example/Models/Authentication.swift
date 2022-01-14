//
//  Authentication.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import Foundation

class Authentication: ObservableObject {
    struct Auth0 {
        static let realm = "Username-Password-Authentication"
        static let scope = "openid offline_access create:connectsession read:connectsession modify:connectsession read:vehicle delete:vehicle"
        static var clientId = ""
        static var domain = ""
        static var audience = ""
        static var userIdentifierKey = ""
        static var isEnabled: Bool { clientId != "" && domain != "" && audience != "" && userIdentifierKey != "" }
    }
    
    private static let accessTokenKey = "accessToken"
    private static let userIdentifierKey = "userIdentifier"
    
    static func enableAuth0(
        clientId: String,
        domain: String,
        audience: String,
        userIdentifierKey: String
    ) {
        Auth0.clientId = clientId
        Auth0.domain = domain
        Auth0.audience = audience
        Auth0.userIdentifierKey = userIdentifierKey
    }
    
    @Published var user: User? = loadUser()
    
    static func loadUser() -> User? {
        let defaults = UserDefaults.standard
        if let accessToken = defaults.string(forKey: Authentication.accessTokenKey),
           let userIdentifier = defaults.string(forKey: Authentication.userIdentifierKey) {
            return User(identifier: userIdentifier, accessToken: accessToken)
        }
        return nil
    }
    
    func authenticate(accessToken: String, userIdentifier: String) {
        let user = User(identifier: userIdentifier, accessToken: accessToken)
        let defaults = UserDefaults.standard
        defaults.set(user.accessToken, forKey: Authentication.accessTokenKey)
        defaults.set(user.identifier, forKey: Authentication.userIdentifierKey)
        self.user = user
    }
    
    func deauthenticate() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Authentication.accessTokenKey)
        defaults.removeObject(forKey: Authentication.userIdentifierKey)
        user = nil
    }
}
