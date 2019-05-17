//
//  ArtistTarget.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/08.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Moya

enum ArtistTarget {
    case showAll
    case show(id: Artist.Id)
    case showPickups
    case showPopulars
    case showVideos(id: Artist.Id)
    case showPopularVideos(id: Artist.Id)
}

// MARK: - BaseTarget

extension ArtistTarget: BaseTarget {
    var path: String {
        switch self {
        case .showAll:
            return "/artists"

        case .show(let id):
            return "/artists/\(id)"

        case .showPickups:
            return "/artists/pickups"

        case .showPopulars:
            return "/artists/populars"

        case .showVideos(let id):
            return "/artists/\(id)/videos"

        case .showPopularVideos(let id):
            return "/artists/\(id)/popular_videos"
        }
    }

    var method: Method {
        switch self {
        case .showAll:
            return .get

        case .show:
            return .get

        case .showPickups:
            return .get

        case .showPopulars:
            return .get

        case .showVideos:
            return .get

        case .showPopularVideos:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .showAll:
            return .requestPlain

        case .show:
            return .requestPlain

        case .showPickups:
            return .requestPlain

        case .showPopulars:
            return .requestPlain

        case .showVideos:
            return .requestPlain

        case .showPopularVideos:
            return .requestPlain
        }
    }
}
