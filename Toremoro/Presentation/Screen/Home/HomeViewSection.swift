//
//  HomeViewSection.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/13.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxDataSources

struct HomeViewSection: SectionModelType {

    enum Item {
        case features([Feature])
        case artists([Artist])
        case genres([Genre])
    }

    // MARK: - Proeprty

    var items: [Item]

    // MARK: - Initializer

    init(features: [Feature]) {
        self.items = [.features(features)]
    }

    init(artists: [Artist]) {
        self.items = [.artists(artists)]
    }

    init(genres: [Genre]) {
        self.items = [.genres(genres)]
    }

    init(original: HomeViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}
