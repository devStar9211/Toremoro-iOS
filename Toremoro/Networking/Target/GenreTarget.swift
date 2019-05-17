//
//  GenreTarget.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Moya

enum GenreTarget {
    case showAll
    case showPickups
    case showVideos(id: Genre.Id)
}

// MARK: - BaseTarget

extension GenreTarget: BaseTarget {
    var path: String {
        switch self {
        case .showAll:
            return "/genres"

        case .showPickups:
            return "/genres/pickups"

        case .showVideos(let id):
            return "/genres/\(id)/videos"
        }
    }

    var method: Method {
        switch self {
        case .showAll:
            return .get

        case .showPickups:
            return .get

        case .showVideos:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .showAll:
            return .requestPlain

        case .showPickups:
            return .requestPlain

        case .showVideos:
            return .requestPlain
        }
    }
}
