//
//  VideosViewSection.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/26.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxDataSources

struct VideosViewSection: SectionModelType {

    typealias Item = Video

    // MARK: - Proeprty

    var items: [Item]

    // MARK: - Initializer

    init(videos: [Item]) {
        self.items = videos
    }

    init(original: VideosViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}
