//
//  SearchTopViewSection.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/06.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import RxDataSources

struct SearchTopViewSection: SectionModelType {

    typealias Item = Genre

    // MARK: - Proeprty

    var items: [Item]

    // MARK: - Initializer

    init(genres: [Item]) {
        self.items = genres
    }

    init(original: SearchTopViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}
