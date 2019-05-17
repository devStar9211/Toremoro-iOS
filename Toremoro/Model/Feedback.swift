//
//  Feedback.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/11.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Foundation

struct Feedback: Identifiable, Decodable {

    // MARK: - Property

    let id: Int
    let body: String
    let email: String?
}
