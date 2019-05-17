//
//  DynamicLinkApplicationService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/28.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import PluggableAppDelegate
import URLNavigator
import Firebase

final class DynamicLinkApplicationService: NSObject, ApplicationService {

    // MARK: - Property

    private let navigator = Navigator()

    // MARK: - Lifecycle

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        NavigationMap.initialize(navigator: navigator)

        navigator.register("https://open.toremoro.app/videos/<int:id>") { _, values, _ in
            guard let id = values["id"] as? Int else { return nil }
            return PreviewViewController(with: .video(id))
        }

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        guard let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) else {
            return false
        }
        return handle(dynamicLink)
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard let url = userActivity.webpageURL else {
            return false
        }

        guard let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromUniversalLink: url) else {
            return false
        }

        return handle(dynamicLink)
    }

    // MARK: - Private

    private func handle(_ dynamicLink: DynamicLink) -> Bool {
        guard let deepLinkUrl = dynamicLink.url else {
            return false
        }

        if let minimumVersion = dynamicLink.minimumAppVersion, AppInfo.version.compare(minimumVersion) == .orderedAscending {
            return false
        }

        if navigator.open(deepLinkUrl) {
            return true
        }

        if navigator.present(deepLinkUrl) != nil {
            return true
        }

        return false
    }
}
