//
//  WatchHistoryService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/11.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import RxSwift

struct WatchHistoryService {

    // MARK: - Property

    private let networking = Networking<WatchHistoryTarget>()

    // MARK: - Public

    func watchHistories(limit: Int = 20, page: Int = 1) -> Single<[Video]> {
        return networking.rx.request(.showAll, limit: limit, page: page)
    }

    func watch(_ video: Video) -> Single<Void> {
        let response: Single<Video> = networking.rx.request(.create(id: video.id))
        return response.map { _ in }
    }
}
