//
//  WatchHistoryTarget.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/11.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Moya

enum WatchHistoryTarget {
    case showAll
    case create(id: Video.Id)
}

// MARK: - BaseTarget

extension WatchHistoryTarget: BaseTarget {
    var path: String {
        switch self {
        case .showAll:
            return "/watch_histories"

        case .create:
            return "/watch_histories"
        }
    }

    var method: Method {
        switch self {
        case .showAll:
            return .get

        case .create:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .showAll:
            return .requestPlain

        case .create(let id):
            let parameters = [
                "video": [
                    "id": id
                ]
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}
