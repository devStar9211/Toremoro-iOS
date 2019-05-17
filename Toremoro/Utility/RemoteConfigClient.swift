//
//  RemoteConfigClient.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/10.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxSwift
import FirebaseRemoteConfig
import RxFirebase

struct RemoteConfigClient {

    private struct Constant {
        static let expirationDuration: TimeInterval = 3600
    }

    enum Key: String {
        case minimumRequiredVersion = "ios_minimum_required_version"
        case appStoreUrl = "app_store_url"
        case apiStagingUrl = "api_staging_url"
        case apiProductionUrl = "api_production_url"
    }

    // MARK: - Property

    private let remoteConfig = RemoteConfig.remoteConfig()

    // MARK: - Public

    func fetch() -> Single<Void> {
        return remoteConfig.rx
            .fetch(withExpirationDuration: Constant.expirationDuration, activateFetched: true)
            .map { _ in () }
            .asSingle()
    }

    func get(by key: Key) -> Single<String?> {
        let value = remoteConfig.configValue(forKey: key.rawValue).stringValue
        return .just(value)
    }

    func get(by key: Key) -> String? {
        return remoteConfig.configValue(forKey: key.rawValue).stringValue
    }
}
