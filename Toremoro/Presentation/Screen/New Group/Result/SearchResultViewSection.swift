//
//  SearchResultViewSection.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/06.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import RxDataSources

struct SearchResultViewSection: SectionModelType {

    enum Item {
        case artists([Artist])
        case video(Video)
    }

    // MARK: - Proeprty

    var items: [Item]

    var videos: [Video] {
        return items.compactMap {
            switch $0 {
            case .artists:
                return nil
            case .video(let video):
                return video
            }
        }
    }

    // MARK: - Initializer

    init(artists: [Artist]) {
        self.items = [.artists(artists)]
    }

    init(videos: [Video]) {
        self.items = videos.map { .video($0) }
    }

    init(original: SearchResultViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}
