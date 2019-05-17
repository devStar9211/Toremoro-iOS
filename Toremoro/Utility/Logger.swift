//
//  Logger.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/07.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import SwiftyBeaver

typealias Logger = SwiftyBeaver

extension Logger {
    static func setup() {
        #if DEBUG
        let destination = ConsoleDestination()
        SwiftyBeaver.addDestination(destination)
        #endif
    }
}
