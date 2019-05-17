//
//  SearchTarget.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/08.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import Moya

enum SearchTarget {
    case showPopulars
}

// MARK: - BaseTarget

extension SearchTarget: BaseTarget {
    var path: String {
        switch self {
        case .showPopulars:
            return "/searches/populars"
        }
    }

    var method: Method {
        switch self {
        case .showPopulars:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .showPopulars:
            return .requestPlain
        }
    }
}
