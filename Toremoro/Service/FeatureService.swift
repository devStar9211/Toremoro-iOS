//
//  FeatureService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import RxSwift

struct FeatureService {

    // MARK: - Property

    private let networking = Networking<FeatureTarget>()

    // MARK: - Public

    func features(limit: Int = 20, page: Int = 1) -> Single<[Feature]> {
        return networking.rx.request(.showAll, limit: limit, page: page)
    }

    func artists(in feature: Feature, limit: Int = 20, page: Int = 1) -> Single<[Artist]> {
        return networking.rx.request(.showArtists(id: feature.id), limit: limit, page: page)
    }

    func videos(in feature: Feature, limit: Int = 20, page: Int = 1) -> Single<[Video]> {
        return networking.rx.request(.showVideos(id: feature.id), limit: limit, page: page)
    }
}
