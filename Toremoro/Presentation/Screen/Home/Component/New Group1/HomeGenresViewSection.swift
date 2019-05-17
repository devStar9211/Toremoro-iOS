//
//  HomeGenresViewSection.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/14.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxDataSources

struct HomeGenresViewSection: SectionModelType {

    enum Item {
        case genre(Genre)
        case more
    }

    // MARK: - Property

    var items: [Item]

    // MARK: - Initializer

    init(genres: [Genre]) {
        self.items = genres.map { .genre($0) } + [.more]
    }

    init(original: HomeGenresViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}

// MARK: - Equatable

extension HomeGenresViewSection.Item: Equatable {
    static func == (lhs: HomeGenresViewSection.Item, rhs: HomeGenresViewSection.Item) -> Bool {
        switch (lhs, rhs) {
        case (.genre(let lhsGenre), .genre(let rhsGenre)):
            return lhsGenre == rhsGenre
        case (.more, .more):
            return true
        default:
            return false
        }
    }
}
