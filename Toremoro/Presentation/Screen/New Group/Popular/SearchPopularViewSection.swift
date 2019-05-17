//
//  SearchPopularViewSection.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/06.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import RxDataSources

struct SearchPopularViewSection: SectionModelType {

    typealias Item = SearchQuery

    // MARK: - Proeprty

    var items: [Item]

    // MARK: - Initializer

    init(queries: [Item]) {
        self.items = queries
    }

    init(original: SearchPopularViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}
