//
//  VideoTarget.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Moya

enum VideoTarget {
    case showAll
    case showRelatedVideos(id: Video.Id)
    case show(id: Video.Id)
}

// MARK: - BaseTarget

extension VideoTarget: BaseTarget {
    var path: String {
        switch self {
        case .showAll:
            return "/videos"

        case .showRelatedVideos(let id):
            return "/videos/\(id)/related_videos"

        case .show(let id):
            return "/videos/\(id)"
        }
    }

    var method: Method {
        switch self {
        case .showAll:
            return .get

        case .showRelatedVideos:
            return .get

        case .show:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .showAll:
            return .requestPlain

        case .showRelatedVideos:
            return .requestPlain

        case .show:
            return .requestPlain
        }
    }
}
