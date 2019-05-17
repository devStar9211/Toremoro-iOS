//
//  BaseTarget.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/08.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Moya

protocol BaseTarget: TargetType {}

extension BaseTarget {
    var baseURL: URL {
        let remoteConfigClient = RemoteConfigClient()
        let path: String = {
            switch AppEnvironment.current {
            case .debug: return remoteConfigClient.get(by: .apiStagingUrl)!
            case .release: return remoteConfigClient.get(by: .apiProductionUrl)!
            }
        }()
        return URL(string: path)!
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        var header = [String: String]()
        header["Accept"] = "application/json"
        header["X-Toremoro-OS"] = "ios"
        header["X-Toremoro-OS-Version"] = UIDevice.current.systemVersion
        header["X-Toremoro-App-Version"] = AppInfo.version
        return header
    }
}
