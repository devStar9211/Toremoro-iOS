//
//  Video.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/18.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import Foundation

struct Video: Identifiable, Decodable {

    // MARK: - Property

    let id: Int
    let title: String
    let description: String
    let url: URL?
    let streamingUrl: URL?
    let thumbnailUrl: URL?
    let views: Int
    let duration: TimeInterval
    let artistId: Artist.Id
    let shareUrl: URL?
}
