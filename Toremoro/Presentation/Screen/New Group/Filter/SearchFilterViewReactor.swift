//
//  SearchFilterViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/29.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import ReactorKit
import RxSwift

final class SearchFilterViewReactor: Reactor {

    enum Action {
        case prepare
        case select(Item)
        case reset
    }

    enum Mutation {
        case setFilter(SearchFilter)
    }

    struct State {
        var sections: [SearchFilterViewSection] = []
        var filter: SearchFilter
    }

    typealias Item = SearchFilterViewSection.Item

    // MARK: - Property

    let initialState: State

    // MARK: - Initializer

    init(filter: SearchFilter) {
        self.initialState = State(sections: SearchFilterViewSection.default, filter: filter)
    }

    // MARK: - Public

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .prepare:
            return .just(.setFilter(currentState.filter))

        case .select(let item):
            let filter: SearchFilter = {
                switch item {
                case .orderNew:
                    return currentState.filter.mutate { $0.order = .new }
                case .orderPopular:
                    return currentState.filter.mutate { $0.order = .popular }
                case .durationAll:
                    return currentState.filter.mutate { $0.duration = .all }
                case .durationUnder10min:
                    return currentState.filter.mutate { $0.duration = .under10min }
                case .durationUnder20min:
                    return currentState.filter.mutate { $0.duration = .under20min }
                case .durationOver20min:
                    return currentState.filter.mutate { $0.duration = .over20min }
                case .sexAll:
                    return currentState.filter.mutate { $0.sex = .all }
                case .sexMale:
                    return currentState.filter.mutate { $0.sex = .male }
                case .sexFemale:
                    return currentState.filter.mutate { $0.sex = .female }
                case .sexOther:
                    return currentState.filter.mutate { $0.sex = .other }
                }
            }()
            return .just(.setFilter(filter))

        case .reset:
            let filter = SearchFilter(order: .new, duration: .all, sex: .all)
            return .just(.setFilter(filter))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setFilter(let filter):
            state.filter = filter
            state.sections = [
                .sort([
                    Item.orderNew(state.filter.order == .new),
                    Item.orderPopular(state.filter.order == .popular)
                ]),
                .duration([
                    Item.durationAll(state.filter.duration == .all),
                    Item.durationUnder10min(state.filter.duration == .under10min),
                    Item.durationUnder20min(state.filter.duration == .under20min),
                    Item.durationOver20min(state.filter.duration == .over20min)
                ]),
                .sex([
                    Item.sexAll(state.filter.sex == .all),
                    Item.sexFemale(state.filter.sex == .female),
                    Item.sexMale(state.filter.sex == .male),
                    Item.sexOther(state.filter.sex == .other)
                ])
            ]
        }

        return state
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return mutation
            .do(onNext: {
                switch $0 {
                case .setFilter(let filter):
                    AppState.searchFilter.onNext(filter)
                }
            })
    }
}
