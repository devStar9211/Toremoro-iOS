//
//  PresentationError.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/24.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Foundation

enum PresentationError: Error {
    case unauthorized(message: String?)
    case forbidden(message: String?)
    case `internal`(message: String?)
    case network
    case invalidate(messages: [String])
    case unknown(underlying: Error)

    // MARK: - Property

    var title: String {
        switch self {
        case .unauthorized:
            return "認証エラー"
        case .forbidden:
            return "権限エラー"
        case .internal:
            return "内部エラー"
        case .network:
            return "通信エラー"
        case .invalidate:
            return "入力エラー"
        case .unknown:
            return "不明なエラー"
        }
    }

    var message: String? {
        switch self {
        case .unauthorized(let message):
            return message
        case .forbidden(let message):
            return message
        case .internal(let message):
            return message
        case .network:
            return "通信環境をお確かめの上、再度お試しください。"
        case .invalidate(let messages):
            return messages.joined(separator: "。")
        case .unknown(let underlying):
            return underlying.localizedDescription
        }
    }

    // MARK: - Initializer

    init(_ error: Error) {
        defer {
            Tracker.shared.track(.error(self))
        }

        switch error {
        case let networkingError as NetworkingError:
            self.init(networkingError)
        case let validationError as ValidationError:
            self.init(validationError)
        default:
            self = .unknown(underlying: error)
        }
    }

    // MARK: - Private

    private init(_ error: NetworkingError) {
        switch error {
        case .unauthorized(let message):
            self = .unauthorized(message: message)
        case .forbidden(let message):
            self = .forbidden(message: message)
        case .internal(let message):
            self = .internal(message: message)
        case .network:
            self = .network
        case .unknown:
            self = .unknown(underlying: error)
        }
    }

    private init(_ error: ValidationError) {
        self = .invalidate(messages: error.messages)
    }
}

// MARK: - Equatable

extension PresentationError: Equatable {
    static func == (lhs: PresentationError, rhs: PresentationError) -> Bool {
        switch (lhs, rhs) {
        case (.unauthorized(let _lhs), .unauthorized(let _rhs)):
            return _lhs == _rhs
        case (.forbidden(let _lhs), .forbidden(let _rhs)):
            return _lhs == _rhs
        case (.`internal`(let _lhs), .`internal`(let _rhs)):
            return _lhs == _rhs
        case (.network, .network):
            return true
        case (.invalidate(let _lhs), .invalidate(let _rhs)):
            return _lhs == _rhs
        case (.unknown, .unknown):
            return false
        default:
            return false
        }
    }
}
