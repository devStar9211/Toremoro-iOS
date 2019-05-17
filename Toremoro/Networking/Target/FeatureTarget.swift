//
//  FeatureTarget.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Moya

enum FeatureTarget {
    case showAll
    case showArtists(id: Feature.Id)
    case showVideos(id: Feature.Id)
}

// MARK: - BaseTarget

extension FeatureTarget: BaseTarget {
    var path: String {
        switch self {
        case .showAll:
            return "/features"

        case .showArtists(let id):
            return "/features/\(id)/artists"

        case .showVideos(let id):
            return "/features/\(id)/videos"
        }
    }

    var method: Method {
        switch self {
        case .showAll:
            return .get

        case .showArtists:
            return .get

        case .showVideos:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .showAll:
            return .requestPlain

        case .showArtists:
            return .requestPlain

        case .showVideos:
            return .requestPlain
        }
    }
}
