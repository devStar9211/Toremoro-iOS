//
//  SearchHistoryTarget.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/08.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import Moya

enum SearchHistoryTarget {
    case showAll
    case create(query: String)
}

// MARK: - BaseTarget

extension SearchHistoryTarget: BaseTarget {
    var path: String {
        switch self {
        case .showAll:
            return "/search_histories"

        case .create:
            return "/search_histories"
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

        case .create(let query):
            let parameters = [
                "search_history": [
                    "query": query
                ]
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}
