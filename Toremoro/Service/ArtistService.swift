//
//  ArtistService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import RxSwift

struct ArtistService {

    // MARK: - Property

    private let networking = Networking<ArtistTarget>()

    // MARK: - Public

    func artists(limit: Int = 20, page: Int = 1) -> Single<[Artist]> {
        return networking.rx.request(.showAll, limit: limit, page: page)
    }

    func artist(by video: Video) -> Single<Artist> {
        return networking.rx.request(.show(id: video.artistId))
    }

    func pickupArtists(limit: Int = 20, page: Int = 1) -> Single<[Artist]> {
        return networking.rx.request(.showPickups, limit: limit, page: page)
    }

    func popularArtists(limit: Int = 20, page: Int = 1) -> Single<[Artist]> {
        return networking.rx.request(.showPopulars, limit: limit, page: page)
    }

    func videos(by artist: Artist, limit: Int = 20, page: Int = 1) -> Single<[Video]> {
        return networking.rx.request(.showVideos(id: artist.id), limit: limit, page: page)
    }

    func popularVideos(by artist: Artist, limit: Int = 20, page: Int = 1) -> Single<[Video]> {
        return networking.rx.request(.showPopularVideos(id: artist.id), limit: limit, page: page)
    }
}
