//
//  RemoteConfigApplicationService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/28.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import PluggableAppDelegate
import Firebase

final class RemoteConfigApplicationService: NSObject, ApplicationService {

    // MARK: - Lifecycle

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        if AppEnvironment.current == .debug {
            let settings = RemoteConfigSettings(developerModeEnabled: true)
            RemoteConfig.remoteConfig().configSettings = settings
        }
        RemoteConfig.remoteConfig().setDefaults(fromPlist: "RemoteConfigDefaults")

        return true
    }
}
