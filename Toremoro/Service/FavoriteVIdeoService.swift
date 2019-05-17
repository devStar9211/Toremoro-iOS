//
//  FavoriteVIdeoService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/11.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import RxSwift

struct FavoriteVideoService {

    // MARK: - Property

    private let networking = Networking<FavoriteVideoTarget>()

    // MARK: - Public

    func favoriteVideos(limit: Int = 20, page: Int = 1) -> Single<[Video]> {
        return networking.rx.request(.showAll, limit: limit, page: page)
    }

    func isFavorite(_ video: Video) -> Single<Bool> {
        let response: Single<Video> = networking.rx.request(.show(id: video.id))
        return response.map { _ in true }.catchError { _ in .just(false) }
    }

    func favorite(_ video: Video) -> Single<Void> {
        let response: Single<Video> = networking.rx.request(.create(id: video.id))
        return response.map { _ in }
    }

    func unfavorite(_ video: Video) -> Single<Void> {
        let response: Single<Video> = networking.rx.request(.delete(id: video.id))
        return response.map { _ in }
    }
}
