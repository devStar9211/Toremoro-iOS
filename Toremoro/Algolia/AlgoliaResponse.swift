//
//  AlgoliaResponse.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/09.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import Foundation

private struct DummyCodable: Codable {}

struct AlgoliaResponse<T: Decodable> {

    private enum Keys: String, CodingKey {
        case page
        case params
        case processingTimeMS
        case query
        case exhaustiveNbHits
        case nbPages
        case hits
        case hitsPerPage
        case nbHits
    }

    // MARK: - Property

    let page: Int
    let params: String
    let processingTimeMS: Int
    let query: String
    let exhaustiveNbHits: Bool
    let nbPages: Int
    let hits: [T]
    let hitsPerPage: Int
    let nbHits: Int
}

// MARK: - Decodable

extension AlgoliaResponse: Decodable {
    init(from decoder: Decoder) throws {
        var hits: [T] = []
        let container = try decoder.container(keyedBy: Keys.self)
        var hitsContainer = try container.nestedUnkeyedContainer(forKey: .hits)
        while !hitsContainer.isAtEnd {
            if let hit = try? hitsContainer.decode(T.self) {
                hits.append(hit)
            } else {
                // next container
                _ = try? hitsContainer.decode(DummyCodable.self)
            }
        }
        self.hits = hits
        self.page = try container.decode(Int.self, forKey: .page)
        self.params = try container.decode(String.self, forKey: .params)
        self.processingTimeMS = try container.decode(Int.self, forKey: .processingTimeMS)
        self.query = try container.decode(String.self, forKey: .query)
        self.exhaustiveNbHits = try container.decode(Bool.self, forKey: .exhaustiveNbHits)
        self.nbPages = try container.decode(Int.self, forKey: .nbPages)
        self.hitsPerPage = try container.decode(Int.self, forKey: .hitsPerPage)
        self.nbHits = try container.decode(Int.self, forKey: .nbHits)
    }
}
