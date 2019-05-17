//
//  FavoriteArtistService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/11.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import RxSwift

struct FavoriteArtistService {

    // MARK: - Property

    private let networking = Networking<FavoriteArtistTarget>()

    // MARK: - Public

    func favoriteArtists(limit: Int = 20, page: Int = 1) -> Single<[Artist]> {
        return networking.rx.request(.showAll, limit: limit, page: page)
    }

    func isFavorite(_ artist: Artist) -> Single<Bool> {
        let response: Single<Artist> = networking.rx.request(.show(id: artist.id))
        return response.map { _ in true }.catchError { _ in .just(false) }
    }

    func favorite(_ artist: Artist) -> Single<Void> {
        let response: Single<Artist> = networking.rx.request(.create(id: artist.id))
        return response.map { _ in }
    }

    func unfavorite(_ artist: Artist) -> Single<Void> {
        let response: Single<Artist> = networking.rx.request(.delete(id: artist.id))
        return response.map { _ in }
    }
}
