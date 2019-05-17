//
//  SearchHistoryService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/08.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import RxSwift

struct SearchHistoryService {

    // MARK: - Property

    private let networking = Networking<SearchHistoryTarget>()

    // MARK: - Public

    func searchHistories(limit: Int = 20, page: Int = 1) -> Single<[SearchQuery]> {
        return networking.rx.request(.showAll, limit: limit, page: page)
    }

    func search(_ query: SearchQuery) -> Single<Void> {
        let response: Single<SearchQuery> = networking.rx.request(.create(query: query))
        return response.map { _ in }
    }
}
