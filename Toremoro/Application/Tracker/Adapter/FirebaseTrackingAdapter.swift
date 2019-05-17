//
//  FirebaseTrackingAdapter.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/12/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Firebase

struct FirebaseTrackingAdapter: TrackingAdapter {

    // MARK: - Public

    func prepare() {
        (Auth.auth().currentUser?.uid).map { Analytics.setUserID($0) }
    }

    func track(_ event: TrackingEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }
}
