//
//  LoggerApplicationService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/28.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import PluggableAppDelegate

final class LoggerApplicationService: NSObject, ApplicationService {

    // MARK: - Lifecycle

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        Logger.setup()
        Logger.info("💫 Application will finish launching")
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Logger.info("💫 Application did enter background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        Logger.info("💫 Application will enter foreground")
    }
}
