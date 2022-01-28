//
//  Authentication.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import Foundation
import JedlixSDK

protocol Authentication: JedlixSDK.Authentication {
    var isAuthenticated: Bool { get }
    func getUserIdentifier() async -> AuthenticationResponse
    func deauthenticate()
}

enum AuthenticationResponse {
    case success(userIdentifier: String)
    case failure(error: Error)
}
