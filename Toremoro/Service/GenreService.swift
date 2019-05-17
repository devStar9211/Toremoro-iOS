//
//  GenreService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import RxSwift

struct GenreService {

    // MARK: - Property

    private let networking = Networking<GenreTarget>()

    // MARK: - Public

    func genres(limit: Int = 20, page: Int = 1) -> Single<[Genre]> {
        return networking.rx.request(.showAll, limit: limit, page: page)
    }

    func pickupGenres(limit: Int = 20, page: Int = 1) -> Single<[Genre]> {
        return networking.rx.request(.showPickups, limit: limit, page: page)
    }

    func videos(in genre: Genre, limit: Int = 20, page: Int = 1) -> Single<[Video]> {
        return networking.rx.request(.showVideos(id: genre.id), limit: limit, page: page)
    }
}
