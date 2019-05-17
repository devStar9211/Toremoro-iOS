//
//  AlgoliaClient.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/09.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import InstantSearchClient
import RxSwift

private let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

struct AlgoliaClient {

    private struct Constant {
        static let stagingAppId = "7KFNDWG7XC"
        static let stagingApiKey = "a9989189467bbb896c274b2659f460a3"
        static let productionAppId = "82F8FAOH7B"
        static let productionApiKey = "7a0a13a2c90c260df8ae37b4207aabc1"
    }

    // MARK: - Property

    private let client: Client = {
        switch AppEnvironment.current {
        case .debug:
            return Client(appID: Constant.stagingAppId, apiKey: Constant.stagingApiKey)
        case .release:
            return Client(appID: Constant.productionAppId, apiKey: Constant.productionApiKey)
        }
    }()

    // MARK: - Public

    func search<T: AlgoliaRequest>(request: T, limit: Int, page: Int) -> Single<[T.Response]> {
        return Single<[T.Response]>.create { observer in
            let index = self.client.index(withName: request.indexName)
            let query = AlgoliaQuery(query: request.query, tags: request.tags, limit: limit, page: page)

            index.search(query) { json, error in
                if error != nil {
                    observer(.error(AlgoliaError.searchError))
                }

                guard let json = json else {
                    observer(.error(AlgoliaError.searchError))
                    return
                }

                do {
                    let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let response = try decoder.decode(AlgoliaResponse<T.Response>.self, from: data)
                    observer(.success(response.hits))
                } catch {
                    observer(.error(AlgoliaError.cannnotDecodeResponse))
                }
            }

            return Disposables.create()
        }
    }
}
