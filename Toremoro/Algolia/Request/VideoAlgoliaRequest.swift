//
//  VideoAlgoliaRequest.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/09.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import Foundation

struct VideoAlgoliaRequest {
    let query: String
    let order: SearchFilter.Order
    let duration: SearchFilter.Duration
    let sex: SearchFilter.Sex
}

// MARK: - AlgoliaRequest

extension VideoAlgoliaRequest: AlgoliaRequest {
    typealias Response = Video

    var indexName: String {
        switch order {
        case .new: return "Video"
        case .popular: return "Video_popular_order"
        }
    }

    var tags: [String] {
        var tags: [String] = []

        switch duration {
        case .all: break
        case .under10min: tags.append("under_10min")
        case .under20min: tags.append("under_20min")
        case .over20min: tags.append("over_20min")
        }

        switch sex {
        case .all: break
        case .female: tags.append("female")
        case .male: tags.append("male")
        case .other: tags.append("other")
        }

        return tags
    }
}
