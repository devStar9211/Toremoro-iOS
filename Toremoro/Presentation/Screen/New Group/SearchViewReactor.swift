//
//  SearchViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/06.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import ReactorKit
import RxSwift

final class SearchViewReactor: Reactor {

    typealias ContainerViewState = SearchViewController.ContainerViewState

    enum Action {
        case beginEditing
        case endEditing
        case search
        case cancel
        case input(SearchQuery)
    }

    enum Mutation {
        case setContainerViewState(ContainerViewState)
        case setQuery(SearchQuery)
    }

    struct State {
        var containerViewState: ContainerViewState = .top
        var query: SearchQuery = ""
    }

    // MARK: - Property

    let initialState: State = State()
    private let searchHistoryService = SearchHistoryService()

    // MARK: - Public

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .beginEditing:
            let state: ContainerViewState = currentState.query.isEmpty ? .popular : .result
            return .just(.setContainerViewState(state))

        case .endEditing:
            return searchHistoryService.search(currentState.query).asObservable().flatMap { _ in Observable.empty() }

        case .search:
            let state: ContainerViewState = currentState.query.isEmpty ? .popular : .result
            return .just(.setContainerViewState(state))

        case .cancel:
            let state: ContainerViewState = .top
            let setContainerViewState: Observable<Mutation> = .just(.setContainerViewState(state))
            let setQuery: Observable<Mutation> = .just(.setQuery(""))
            return .concat(setContainerViewState, setQuery)

        case .input(let query):
            let state: ContainerViewState = {
                guard query.isEmpty else {
                    return .result
                }
                switch currentState.containerViewState {
                case .top:
                    return .top
                case .popular:
                    return .popular
                case .result:
                    return .popular
                }
            }()
            let setQuery: Observable<Mutation> = .just(.setQuery(query))
            let setContainerViewState: Observable<Mutation> = .just(.setContainerViewState(state))
            return .concat(setQuery, setContainerViewState)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setContainerViewState(let containerViewState):
            state.containerViewState = containerViewState

        case .setQuery(let query):
            state.query = query
        }

        return state
    }

    func transform(action: Observable<Action>) -> Observable<Action> {
        return action
            .do(onNext: {
                switch $0 {
                case .input(let query):
                    AppState.searchQuery.onNext(query)
                default:
                    break
                }
            })
    }
}
