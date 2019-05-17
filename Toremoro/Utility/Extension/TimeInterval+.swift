//
//  TimeInterval+.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/31.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import Foundation

extension TimeInterval {
    private var hours: Int {
        return Int(self) / 3600
    }

    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }

    private var seconds: Int {
        return Int(self) % 60
    }

    var formatted: String {
        if hours > 0 {
            return String(format: "%d:%02d:%02d%", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d%", minutes, seconds)
        }
    }
}
