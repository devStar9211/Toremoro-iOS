//
//  FavoriteArtistTarget.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/11.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Moya

enum FavoriteArtistTarget {
    case showAll
    case show(id: Artist.Id)
    case create(id: Artist.Id)
    case delete(id: Artist.Id)
}

// MARK: - BaseTarget

extension FavoriteArtistTarget: BaseTarget {
    var path: String {
        switch self {
        case .showAll:
            return "/favorite_artists"

        case .show(let id):
            return "/favorite_artists/\(id)"

        case .create:
            return "/favorite_artists"

        case .delete(let id):
            return "/favorite_artists/\(id)"
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
                "artist": [
                    "id": id
                ]
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)

        case .delete:
            return .requestPlain
        }
    }
}
