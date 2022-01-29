//
//  User.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import Foundation

class User: ObservableObject {
    enum AuthenticationState {
        case notAuthenticated
        case authenticated(userIdentifier: String)
    }
    
    static let current = User()
    @Published var state: AuthenticationState?
}
