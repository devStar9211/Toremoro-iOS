//
//  HomeArtistsViewSection.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/14.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxDataSources

struct HomeArtistsViewSection: SectionModelType {

    enum Item {
        case artist(Artist)
        case more
    }

    // MARK: - Property

    var items: [Item]

    // MARK: - Initializer

    init(artists: [Artist]) {
        self.items = artists.map { .artist($0) } + [.more]
    }

    init(original: HomeArtistsViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}

// MARK: - Equatable

extension HomeArtistsViewSection.Item: Equatable {
    static func == (lhs: HomeArtistsViewSection.Item, rhs: HomeArtistsViewSection.Item) -> Bool {
        switch (lhs, rhs) {
        case (.artist(let lhsArtist), .artist(let rhsArtist)):
            return lhsArtist == rhsArtist
        case (.more, .more):
            return true
        default:
            return false
        }
    }
}
