//
//  SearchService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/08.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import RxSwift

struct SearchService {

    // MARK: - Property

    private let networking = Networking<SearchTarget>()
    private let algoliaClient = AlgoliaClient()

    // MARK: - Public

    func searchArtists(with query: SearchQuery, filter: SearchFilter, limit: Int = 20, page: Int = 1) -> Single<[Artist]> {
        let request = ArtistAlgoliaRequest(query: query, order: filter.order, sex: filter.sex)
        return algoliaClient.search(request: request, limit: limit, page: page)
    }

    func searchVideos(with query: SearchQuery, filter: SearchFilter, limit: Int = 20, page: Int = 1) -> Single<[Video]> {
        let request = VideoAlgoliaRequest(query: query, order: filter.order, duration: filter.duration, sex: filter.sex)
        return algoliaClient.search(request: request, limit: limit, page: page)
    }

    func popularQueries() -> Single<[SearchQuery]> {
        return networking.rx.request(.showPopulars)
    }
}
