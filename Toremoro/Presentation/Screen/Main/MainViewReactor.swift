//
//  MainViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/18.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import ReactorKit
import RxSwift

final class MainViewReactor: Reactor {

    typealias Action = NoAction

    enum Mutation {
        case setSelectedIndex(Int)
    }

    struct State {
        var selectedIndex: Int?
    }

    // MARK: - Property

    let initialState = State()

    // MARK: - Public

    func reduce(state: State, mutation: Mutation) -> MainViewReactor.State {
        var state = state

        switch mutation {
        case .setSelectedIndex(let index):
            state.selectedIndex = index
        }

        return state
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let setSelectedIndex: Observable<Mutation> = AppState.selectTab.map { .setSelectedIndex($0.rawValue) }
        return .merge(mutation, setSelectedIndex)
    }
}
