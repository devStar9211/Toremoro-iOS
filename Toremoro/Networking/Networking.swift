//
//  Networking.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/08.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Moya
import Firebase
import RxSwift

private let manager: Manager = {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
    configuration.timeoutIntervalForRequest = 30

    let manager = Manager(configuration: configuration)
    manager.startRequestsImmediately = false

    return manager
}()

private let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

protocol NetworkingType {
    associatedtype Target: TargetType
    var provider: MoyaProvider<Target> { get }
    var pagingProvider: MoyaProvider<PagingTarget<Target>> { get }
}

struct Networking<Target: TargetType>: NetworkingType {

    // MARK: - Property

    let provider: MoyaProvider<Target>
    let pagingProvider: MoyaProvider<PagingTarget<Target>>

    // MARK: - Initializer

    init() {
        let interceptors = [FirebaseTokenInterceptor()]
        self.provider = MoyaProvider<Target>(
            requestClosure: Networking.createRequestClosure(forTarget: Target.self, with: interceptors),
            manager: manager,
            plugins: [
                LoggerPlugin(),
                BenchmarkPlugin()
            ]
        )
        self.pagingProvider = MoyaProvider<PagingTarget<Target>>(
            requestClosure: Networking.createRequestClosure(forTarget: Target.self, with: interceptors),
            manager: manager,
            plugins: [
                LoggerPlugin(),
                BenchmarkPlugin()
            ]
        )
    }

    // MARK: - Private

    private static func createRequestClosure(forTarget target: Target.Type, with interceptors: [RequestInterceptor]) -> MoyaProvider<Target>.RequestClosure {
        return { (endpoint: Endpoint, done: @escaping MoyaProvider.RequestResultClosure) in
            interceptors.forEach { $0.intercept(target, endpoint: endpoint, done: done) }
        }
    }
}

extension Networking: ReactiveCompatible {}

extension Reactive where Base: NetworkingType, Base.Target: BaseTarget {
    func request<T: Decodable>(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<T> {
        return base.provider.rx.request(token, callbackQueue: callbackQueue)
            .filterSuccessfulStatusCodes()
            .catchError { throw NetworkingError(error: $0) }
            .map(T.self, using: decoder)
    }

    func request<T: Decodable>(_ token: Base.Target, limit: Int, page: Int, callbackQueue: DispatchQueue? = nil) -> Single<T> {
        let pagingTarget = PagingTarget(originalTarget: token, limit: limit, page: page)
        return base.pagingProvider.rx.request(pagingTarget, callbackQueue: callbackQueue)
            .filterSuccessfulStatusCodes()
            .catchError { throw NetworkingError(error: $0) }
            .map(T.self, using: decoder)
    }
}
