//
//  AlgoliaQuery.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/09.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import InstantSearchClient

typealias AlgoliaQuery = Query

extension AlgoliaQuery {
    convenience init(query: String, tags: [String], limit: Int, page: Int) {
        let query = Query(query: query)
        query.hitsPerPage = UInt(limit)
        query.page = UInt(page)
        query.tagFilters = tags
        self.init(copy: query)
    }
}
