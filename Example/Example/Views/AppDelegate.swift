//
//  AppDelegate.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import UIKit
import JedlixSDK

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        JedlixSDK.configure(with: URL(string: "<YOUR BASE URL>")!)
        
//        Authentication.enableAuth0(
//            clientId: "<AUTH0 CLIENT ID>",
//            domain: "<AUTH0 DOMAIN>",
//            audience: "<AUTH0 AUDIENCE>",
//            userIdentifierKey: "<USER IDENTIFIER KEY>"
//        )
        return true
    }
}
