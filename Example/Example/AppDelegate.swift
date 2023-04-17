//
//  AppDelegate.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import UIKit
import JedlixSDK

var apiKey: String?
var baseURL: URL!
var authentication: Authentication!

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        baseURL = URL(string: "<YOUR BASE URL>")!
        apiKey = "<YOUR API KEY>"
        authentication = DefaultAuthentication()
//        authentication = Auth0Authentication(
//            clientId: "<AUTH0 CLIENT ID>",
//            domain: "<AUTH0 DOMAIN>",
//            audience: "<AUTH0 AUDIENCE>",
//            userIdentifierKey: "<USER IDENTIFIER KEY>"
//        )
        JedlixSDK.configure(
            baseURL: baseURL,
            apiKey: apiKey,
            authentication: authentication
        )
        return true
    }
}
