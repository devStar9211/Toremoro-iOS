//
//  SearchResultArtistsViewSection.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/08.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import RxDataSources

struct SearchResultArtistsViewSection: SectionModelType {

    typealias Item = Artist

    // MARK: - Property

    var items: [Item]

    // MARK: - Initializer

    init(artists: [Artist]) {
        self.items = artists
    }

    init(original: SearchResultArtistsViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}
