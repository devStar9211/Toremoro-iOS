//
//  Tracker.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/12/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Foundation

final class Tracker {

    // MARK: - Property

    static let shared = Tracker()
    private let adapters: [TrackingAdapter]

    // MARK: - Initializer

    private init() {
        self.adapters = [
            ConsoleTrackingAdapter(),
            FirebaseTrackingAdapter()
        ]
        adapters.forEach { $0.prepare() }
    }

    // MARK: - Public

    func track(_ screen: TrackingScreen) {
        adapters.forEach { $0.track(.screen_view(screen)) }
    }

    func track(_ action: TrackingAction) {
        adapters.forEach { $0.track(.tap_action(action)) }
    }

    func track(_ event: TrackingEvent) {
        adapters.forEach { $0.track(event) }
    }
}
