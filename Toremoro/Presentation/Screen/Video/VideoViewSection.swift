//
//  VideoViewSection.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/26.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxDataSources

struct VideoViewSection: SectionModelType {

    enum Item {
        case detail(VideoDetailViewCellReactor)
        case related(Video)

        var video: Video? {
            switch self {
            case .detail:
                return nil
            case .related(let video):
                return video
            }
        }
    }

    // MARK: - Property

    var items: [Item]

    // MARK: - Initializer

    init(video: Video, artist: Artist, isFavorited: Bool) {
        let detailReactor = VideoDetailViewCellReactor(video: video, artist: artist, isFavorited: isFavorited)
        self.items = [.detail(detailReactor)]
    }

    init(related videos: [Video]) {
        self.items = videos.map { .related($0) }
    }

    init(original: VideoViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}

// MARK: - Equatable

extension VideoViewSection.Item: Equatable {
    static func == (lhs: VideoViewSection.Item, rhs: VideoViewSection.Item) -> Bool {
        switch (lhs, rhs) {
        case (.related(let _lhs), .related(let _rhs)):
            return _lhs == _rhs
        default:
            return false
        }
    }
}

extension VideoViewSection: Equatable {
    static func == (lhs: VideoViewSection, rhs: VideoViewSection) -> Bool {
        return lhs.items == rhs.items
    }
}
