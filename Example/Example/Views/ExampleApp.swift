//
//  ExampleApp.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import SwiftUI
import WebKit
import JedlixSDK

@main
struct ExampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var user = User.current
    
    var body: some Scene {
        WindowGroup {
            VStack {
                switch user.state {
                case .notAuthenticated: AuthenticationView()
                case .authenticated(let userIdentifier): ConnectView(userIdentifier: userIdentifier)
                default: EmptyView()
                }
            }
        }
    }
}
