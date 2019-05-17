//
//  SearchFilter.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/29.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import Foundation

struct SearchFilter: Mutable {

    enum Order: String {
        case new
        case popular
    }

    enum Duration: String {
        case all
        case under10min
        case under20min
        case over20min
    }

    enum Sex: String {
        case all
        case female
        case male
        case other
    }

    // MARK: - Property

    var order: Order
    var duration: Duration
    var sex: Sex

    // MARK: - Initializer

    init(order: Order = .new, duration: Duration = .all, sex: Sex = .all) {
        self.order = order
        self.duration = duration
        self.sex = sex
    }
}
