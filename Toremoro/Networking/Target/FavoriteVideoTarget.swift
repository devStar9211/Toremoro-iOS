//
//  FavoriteVideoTarget.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/11.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Moya

enum FavoriteVideoTarget {
    case showAll
    case show(id: Video.Id)
    case create(id: Video.Id)
    case delete(id: Video.Id)
}

// MARK: - BaseTarget

extension FavoriteVideoTarget: BaseTarget {
    var path: String {
        switch self {
        case .showAll:
            return "/favorite_videos"

        case .show(let id):
            return "/favorite_videos/\(id)"

        case .create:
            return "/favorite_videos"

        case .delete(let id):
            return "/favorite_videos/\(id)"
        }
    }

    var method: Method {
        switch self {
        case .showAll:
            return .get

        case .show:
            return .get

        case .create:
            return .post

        case .delete:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .showAll:
            return .requestPlain

        case .show:
            return .requestPlain

        case .create(let id):
            let parameters = [
                "video": [
                    "id": id
                ]
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)

        case .delete:
            return .requestPlain
        }
    }
}
