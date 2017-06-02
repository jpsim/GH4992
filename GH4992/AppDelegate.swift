//
//  AppDelegate.swift
//  GH4992
//
//  Created by JP Simard on 6/2/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import RealmSwift
import UIKit

let ip = "172.20.20.181"

class MyObject: Object {
    dynamic var stringProp = ""
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let creds = SyncCredentials.usernamePassword(username: "user", password: "password", register: true)
        let authURL = URL(string: "http://\(ip):9080")!
        SyncUser.logIn(with: creds, server: authURL) { user, error in
            guard let user = user else {
                fatalError("couldn't register user")
            }
            let realmURL = URL(string: "realm://\(ip):9080/~/default")!
            let syncConfig = SyncConfiguration(user: user, realmURL: realmURL)
            openRealm(config: Realm.Configuration(syncConfiguration: syncConfig)) { didComplete in
                print("didComplete: \(didComplete)")
            }
        }
        return true
    }
}

func openRealm(config: Realm.Configuration, completionHandler: @escaping (Bool) -> Void) {
    print( String(describing: config) )
    print("Opening sync Realm")
    Realm.asyncOpen(configuration: config) { realm, error in

        print("   ... opened.")
        if realm != nil {

            // Realm successfully opened, with all remote data available
            DispatchQueue.main.async {
                // Set this as the configuration used for the default Realm
                Realm.Configuration.defaultConfiguration = config
                print("Configuration: \(Realm.Configuration.defaultConfiguration)")
                print("Schema: \(Realm.Configuration.defaultConfiguration.schemaVersion)")
            }
            completionHandler(true)

        } else if let error = error {
            print("Unable to open Realm")
            print(error)
        } else {
            print("Something bad has happened!")
        }
    }
}
