//
//  FirebaseApplicationService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/28.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import PluggableAppDelegate
import Firebase

final class FirebaseApplicationService: NSObject, ApplicationService {

    // MARK: - Lifecycle

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        let resource = AppEnvironment.current == .debug ? "GoogleService-Info-Staging" : "GoogleService-Info-Production"
        let path = Bundle.main.path(forResource: resource, ofType: "plist")!
        guard let options = FirebaseOptions(contentsOfFile: path) else {
            fatalError("Can't initialize firebase")
        }
        FirebaseApp.configure(options: options)

        return true
    }
}
