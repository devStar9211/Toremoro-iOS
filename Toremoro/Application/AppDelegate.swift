//
//  AppDelegate.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/06.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import PluggableAppDelegate

@UIApplicationMain final class AppDelegate: PluggableApplicationDelegate {

    // MARK: - Property

    override var services: [ApplicationService] {
        return [
            LoggerApplicationService(),
            FirebaseApplicationService(),
            FabricApplicationService(),
            RemoteConfigApplicationService(),
            DynamicLinkApplicationService(),
            DeviceOrientationApplicationService(),
            SceneRouterApplicationService()
        ]
    }

    static var isLockAutoRotation = true

    // MARK: - Lifecycle

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.isLockAutoRotation ? .portrait : .all
    }
}
