//
//  TrackingAdapter.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/12/08.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Foundation

protocol TrackingAdapter {
    func prepare()
    func track(_: TrackingEvent)
}

extension TrackingAdapter {
    func prepare() {}
}
