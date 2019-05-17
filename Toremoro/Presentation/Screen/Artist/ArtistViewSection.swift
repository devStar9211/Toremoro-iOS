//
//  ArtistViewSection.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/26.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxDataSources

struct ArtistViewSection: SectionModelType {

    enum Item {
        case profile(ArtistProfileViewCellReactor)
        case popular(Video)
        case new(Video)

        var video: Video? {
            switch self {
            case .profile:
                return nil
            case .popular(let video):
                return video
            case .new(let video):
                return video
            }
        }
    }

    // MARK: - Property

    var items: [Item]

    // MARK: - Initializer

    init(profile artist: Artist, isFavorited: Bool) {
        let reactor = ArtistProfileViewCellReactor(artist: artist, isFavorited: isFavorited)
        self.items = [.profile(reactor)]
    }

    init(popular videos: [Video]) {
        self.items = videos.map { .popular($0) }
    }

    init(new videos: [Video]) {
        self.items = videos.map { .new($0) }
    }

    init(original: ArtistViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}
