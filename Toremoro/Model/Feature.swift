//
//  Feature.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/13.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import Foundation

struct Feature: Identifiable, Decodable {

    enum Target: String, Decodable {
        case video, artist, web
    }

    // MARK: - Property

    let id: Int
    let title: String
    let thumbnailUrl: URL?
    let target: Target
    let url: URL?
    let video: Video?
    let artist: Artist?
}
