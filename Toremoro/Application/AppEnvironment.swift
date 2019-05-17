//
//  AppEnvironment.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/17.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Foundation

enum AppEnvironment {
    case debug, release
}

extension AppEnvironment {
    static var current: AppEnvironment = {
        #if DEBUG
        return .debug
        #else
        return .release
        #endif
    }()
}
