//
//  ExampleApp.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import SwiftUI
import WebKit

@main
struct ExampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var authentication = Authentication()
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if let user = authentication.user {
                    VehicleView(user: user)
                } else {
                    AuthenticationView()
                }
            }
            .environmentObject(authentication)
        }
    }
}
