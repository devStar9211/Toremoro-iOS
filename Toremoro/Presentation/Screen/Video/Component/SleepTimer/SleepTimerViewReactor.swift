//
//  SleepTimerViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/02/10.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import RxSwift
import ReactorKit

final class SleepTimerViewReactor: Reactor {

    typealias Action = NoAction

    struct State {
        let sections = SleepTimerViewSection.default
    }

    // MARK: - Property

    let initialState: State

    // MARK: - Initializer

    init() {
        self.initialState = State()
        _ = self.state
    }
}
