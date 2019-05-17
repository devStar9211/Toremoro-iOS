//
//  Mutable.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/29.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import Foundation

protocol Mutable {}

extension Mutable {
    func mutateOne<T>(transform: (inout Self) -> T) -> Self {
        var newSelf = self
        _ = transform(&newSelf)
        return newSelf
    }

    func mutate(transform: (inout Self) -> Void) -> Self {
        var newSelf = self
        transform(&newSelf)
        return newSelf
    }

    func mutate(transform: (inout Self) throws -> Void) rethrows -> Self {
        var newSelf = self
        try transform(&newSelf)
        return newSelf
    }
}
