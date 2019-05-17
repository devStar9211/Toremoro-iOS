//
//  AppInfo.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/02/24.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import Foundation

struct AppInfo {

    // MARK: - Property

    static var version: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String // swiftlint:disable:this force_cast
    }
}
