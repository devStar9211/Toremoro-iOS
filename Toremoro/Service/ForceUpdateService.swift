//
//  ForceUpdateService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import RxSwift

struct ForceUpdateService {

    // MARK: - Property

    private let remoteConfigClient = RemoteConfigClient()

    // MARK: - Public

    func checkUpdate() -> Single<Bool> {
        return remoteConfigClient.fetch()
            .flatMap { self.remoteConfigClient.get(by: .minimumRequiredVersion) }
            .filterNil()
            .map { AppInfo.version.compare($0) == .orderedAscending }
    }
}
