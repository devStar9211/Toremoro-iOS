//
//  TutorialViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/08/30.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import ReactorKit
import RxSwift

final class TutorialViewReactor: Reactor {

    enum Action {
        case move(Int)
        case skip
        case start
    }

    enum Mutation {
        case setPage(Int)
        case setSkipped(Bool)
        case setStarting(Bool)
    }

    struct State {
        var page = 0
        var isSkipped = false
        var isStarting = false
    }

    // MARK: - Property

    let initialState: State = State()

    // MARK: - Public

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .move(let page):
            return .just(.setPage(page))

        case .skip:
            return .just(.setSkipped(true))

        case .start:
            return .just(.setStarting(true))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.isSkipped = false
        state.isStarting = false

        switch mutation {
        case .setPage(let page):
            state.page = page

        case .setSkipped(let isSkipped):
            state.isSkipped = isSkipped

        case .setStarting(let isStarting):
            state.isStarting = isStarting
        }

        return state
    }
}
