//
//  AlgoliaRequest.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/09.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import Foundation

protocol AlgoliaRequest {
    associatedtype Response: Decodable
    var indexName: String { get }
    var query: String { get }
    var tags: [String] { get }
}
