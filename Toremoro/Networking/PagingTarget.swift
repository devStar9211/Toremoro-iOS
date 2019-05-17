//
//  PagingTarget.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/13.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Moya

struct PagingTarget<Target: TargetType> {

    // MARK: - Property

    let originalTarget: Target
    let limit: Int
    let page: Int
}

// MARK: - BaseTarget

extension PagingTarget: BaseTarget {
    var baseURL: URL {
        return originalTarget.baseURL
    }

    var path: String {
        return originalTarget.path
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return originalTarget.sampleData
    }

    var task: Task {
        let original: (parameters: [String: Any], encoding: ParameterEncoding) = {
            if case .requestParameters(let parameters, let encoding) = originalTarget.task {
                return (parameters, encoding)
            } else {
                return ([:], URLEncoding.default)
            }
        }()
        let parameters: [String: Any] = {
            var parameters = original.parameters
            parameters["limit"] = limit
            parameters["page"] = page
            return parameters
        }()
        return Task.requestParameters(parameters: parameters, encoding: original.encoding)
    }

    var headers: [String: String]? {
        return originalTarget.headers
    }
}
