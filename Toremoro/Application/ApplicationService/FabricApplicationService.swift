//
//  FabricApplicationService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/28.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import PluggableAppDelegate
import Fabric
import Crashlytics

final class FabricApplicationService: NSObject, ApplicationService {

    // MARK: - Lifecycle

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        if AppEnvironment.current == .release {
            Fabric.with([Crashlytics.self])
        }

        return true
    }
}
