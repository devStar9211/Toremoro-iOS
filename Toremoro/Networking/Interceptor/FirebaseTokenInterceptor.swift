//
//  FirebaseTokenInterceptor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/10.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Moya
import Firebase
import Result

private struct EmptyError: Error {}

struct FirebaseTokenInterceptor: RequestInterceptor {

    // MARK: - Public

    func intercept<T: TargetType>(_ target: T.Type, endpoint: Endpoint, done: @escaping MoyaProvider<T>.RequestResultClosure) {
        guard let request = try? endpoint.urlRequest() else {
            done(.failure(.requestMapping(endpoint.url)))
            return
        }

        getIdToken { result in
            switch result {
            case .success(let token):
                let newRequest = self.createRequest(with: token, from: request)
                done(.success(newRequest))
            case .failure:
                done(.failure(.requestMapping("Invalid authorization token")))
            }
        }
    }

    // MARK: - Private

    private func getIdToken(callback: @escaping (Result<String, EmptyError>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            callback(.failure(EmptyError()))
            return
        }

        user.getIDToken { token, error in
            guard let token = token, error == nil else {
                callback(.failure(EmptyError()))
                return
            }
            callback(.success(token))
        }
    }

    private func createRequest(with token: String, from request: URLRequest) -> URLRequest {
        var request = request
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
