//
//  SceneRouterApplicationService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/28.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import PluggableAppDelegate

final class SceneRouterApplicationService: NSObject, ApplicationService {

    // MARK: - Lifecycle

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        SceneRouter.shared.rootViewController = window?.rootViewController as? RootViewController
        SceneRouter.shared.route(to: .splash, animated: true)
        return true
    }
}
