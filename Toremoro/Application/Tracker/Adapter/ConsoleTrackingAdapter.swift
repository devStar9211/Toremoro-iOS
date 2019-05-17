//
//  ConsoleTrackingAdapter.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/12/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Foundation

struct ConsoleTrackingAdapter: TrackingAdapter {

    // MARK: - Public

    func track(_ event: TrackingEvent) {
        if AppEnvironment.current == .debug {
            Logger.info("💥 \(event)")
        }
    }
}
