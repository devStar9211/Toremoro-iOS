//
//  SearchPopularViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/06.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import ReactorKit
import RxSwift

final class SearchPopularViewReactor: Reactor {

    enum Action {
        case prepare
        case dismissErrorAlert
    }

    enum Mutation {
        case setLoading(Bool)
        case setSections(queries: [SearchQuery])
        case setError(Error?)
    }

    struct State {
        var isLoading = false
        var sections: [SearchPopularViewSection] = []
        var error: Error?
    }

    // MARK: - Property

    let initialState: State = State()
    private let searchService = SearchService()

    // MARK: - Public

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .prepare:
            guard !self.currentState.isLoading else { return .empty() }
            let start: Observable<Mutation> = .just(.setLoading(true))
            let finish: Observable<Mutation> = .just(.setLoading(false))
            let setSections = searchService.popularQueries()
                .map {
                    Mutation.setSections(queries: $0)
                }
                .catchError { .just(.setError($0)) }
                .asObservable()
            return .concat(start, setSections, finish)

        case .dismissErrorAlert:
            return .just(.setError(nil))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setLoading(let isLoading):
            state.isLoading = isLoading

        case .setSections(let queries):
            state.sections = [
                SearchPopularViewSection(queries: queries)
            ]

        case .setError(let error):
            state.error = error
        }

        return state
    }
}
