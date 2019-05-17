//
//  NetworkingError.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Moya

enum NetworkingError: Error {
    case unauthorized(message: String?)
    case forbidden(message: String?)
    case `internal`(message: String?)
    case network
    case unknown

    struct Response: Decodable {
        let message: String
    }

    // MARK: - Initializer

    init(error: Error) {
        guard let moyaError = error as? MoyaError else {
            self = .unknown
            return
        }

        switch moyaError {
        case .statusCode(let response):
            let message = try? JSONDecoder().decode(Response.self, from: response.data).message

            switch response.statusCode {
            case 401:
                self = .unauthorized(message: message)
            case 403:
                self = .forbidden(message: message)
            default:
                self = .internal(message: message)
            }
        default:
            self = .network
        }
    }
}
