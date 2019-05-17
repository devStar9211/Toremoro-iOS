//
//  Genre.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/13.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import Foundation

struct Genre: Identifiable, Decodable {

    // MARK: - Property

    let id: Int
    let title: String
    let thumbnailUrl: URL?
}
