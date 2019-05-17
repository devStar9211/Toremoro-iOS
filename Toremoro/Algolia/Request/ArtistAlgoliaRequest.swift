//
//  ArtistAlgoliaRequest.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/09.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import Foundation

struct ArtistAlgoliaRequest {
    let query: String
    let order: SearchFilter.Order
    let sex: SearchFilter.Sex
}

// MARK: - AlgoliaRequest

extension ArtistAlgoliaRequest: AlgoliaRequest {
    typealias Response = Artist

    var indexName: String {
        switch order {
        case .new: return "Artist"
        case .popular: return "Artist_popular_order"
        }
    }

    var tags: [String] {
        var tags: [String] = []

        switch sex {
        case .all: break
        case .female: tags.append("female")
        case .male: tags.append("male")
        case .other: tags.append("other")
        }

        return tags
    }
}
