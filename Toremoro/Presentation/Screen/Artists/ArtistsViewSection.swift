//
//  ArtistsViewSection.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/24.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxDataSources

struct ArtistsViewSection: SectionModelType {

    enum Item {
        case pickup(Artist)
        case popular(Artist)
        case artist(Artist)

        var artist: Artist {
            switch self {
            case .pickup(let artist):
                return artist

            case .popular(let artist):
                return artist

            case .artist(let artist):
                return artist
            }
        }
    }

    // MARK: - Proeprty

    var items: [Item]

    // MARK: - Initializer

    init(pickup artists: [Artist]) {
        self.items = artists.map { .pickup($0) }
    }

    init(popular artists: [Artist]) {
        self.items = artists.map { .popular($0) }
    }

    init(artists: [Artist]) {
        self.items = artists.map { .artist($0) }
    }

    init(original: ArtistsViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}
