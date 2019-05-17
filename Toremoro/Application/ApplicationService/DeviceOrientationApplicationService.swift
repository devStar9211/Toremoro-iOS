//
//  DeviceOrientationApplicationService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/28.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import PluggableAppDelegate
import AVFoundation

final class DeviceOrientationApplicationService: NSObject, ApplicationService {

    // MARK: - Lifecycle

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .defaultToSpeaker)
        try? AVAudioSession.sharedInstance().setActive(true)
        return true
    }
}
