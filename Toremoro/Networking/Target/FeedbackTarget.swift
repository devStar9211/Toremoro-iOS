//
//  FeedbackTarget.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Moya

enum FeedbackTarget {
    case create(body: String, email: String?)
}

// MARK: - BaseTarget

extension FeedbackTarget: BaseTarget {
    var path: String {
        switch self {
        case .create:
            return "/feedbacks"
        }
    }

    var method: Method {
        switch self {
        case .create:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .create(let body, let email):
            var parameters = [
                "feedback": [
                    "body": body
                ]
            ]
            if let email = email, !email.isEmpty {
                parameters["feedback"]!["email"] = email
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}
