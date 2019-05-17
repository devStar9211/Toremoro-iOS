//
//  Identifiable.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/12.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Foundation

protocol Identifiable: Equatable {
    associatedtype Id: Comparable
    var id: Id { get }
}

extension Identifiable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
