//
//  MyPageViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/13.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import ReactorKit
import RxSwift

final class MyPageViewReactor: Reactor {

    typealias Action = NoAction

    struct State {
        let sections = MyPageViewSection.default
    }

    // MARK: - Property

    let initialState: State

    // MARK: - Initializer

    init() {
        self.initialState = State()
        _ = self.state
    }
}
