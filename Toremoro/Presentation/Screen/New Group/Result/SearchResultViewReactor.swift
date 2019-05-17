//
//  SearchResultViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/06.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import ReactorKit
import RxSwift

final class SearchResultViewReactor: Reactor {

    private struct Constant {
        static let limit = 20
    }

    enum Action {
        case prepare
        case search(SearchQuery)
        case filter(SearchFilter)
        case loadMore
        case dismissErrorAlert
    }

    enum Mutation {
        case setLoading(Bool)
        case setLoadingMore(Bool)
        case setEmpty(Bool)
        case setQuery(SearchQuery)
        case setFilter(SearchFilter)
        case setSections(artists: [Artist], videos: [Video], nextPage: Int?)
        case addVideos(videos: [Video], nextPage: Int?)
        case setError(Error?)
    }

    struct State {
        var isLoading = false
        var isLoadingMore = false
        var isEmpty = false
        var query: SearchQuery
        var filter: SearchFilter
        var sections: [SearchResultViewSection] = []
        var nextPage: Int?
        var error: Error?
    }

    // MARK: - Property

    let initialState: State
    private let searchService = SearchService()

    // MARK: - Initializer

    init(query: SearchQuery) {
        self.initialState = State(
            isLoading: false,
            isLoadingMore: false,
            isEmpty: false,
            query: query,
            filter: SearchFilter(),
            sections: [],
            nextPage: nil,
            error: nil
        )
    }

    // MARK: - Public

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .prepare:
            guard !self.currentState.isLoading else { return .empty() }
            let start: Observable<Mutation> = .just(.setLoading(true))
            let finish: Observable<Mutation> = .just(.setLoading(false))
            let setSections: Observable<Mutation> = Single
                .zip(
                    searchService.searchArtists(with: currentState.query, filter: currentState.filter, limit: Constant.limit, page: 0),
                    searchService.searchVideos(with: currentState.query, filter: currentState.filter, limit: Constant.limit, page: 0)
                )
                .map {
                    let page = $0.1.count == Constant.limit ? 1 : nil
                    return .setSections(artists: $0.0, videos: $0.1, nextPage: page)
                }
                .catchError { .just(.setError($0)) }
                .asObservable()
            return .concat(start, setSections, finish)

        case .search(let query):
            let start: Observable<Mutation> = .just(.setLoading(true))
            let finish: Observable<Mutation> = .just(.setLoading(false))
            let setSections: Observable<Mutation> = Single
                .zip(
                    searchService.searchArtists(with: query, filter: currentState.filter, limit: Constant.limit, page: 0),
                    searchService.searchVideos(with: query, filter: currentState.filter, limit: Constant.limit, page: 0)
                )
                .map {
                    let page = $0.1.count == Constant.limit ? 1 : nil
                    return .setSections(artists: $0.0, videos: $0.1, nextPage: page)
                }
                .catchError { .just(.setError($0)) }
                .asObservable()
            let setQuery: Observable<Mutation> = .just(.setQuery(query))
            Tracker.shared.track(.search(query, currentState.filter))
            return .concat(start, setSections, finish, setQuery)

        case .filter(let filter):
            let start: Observable<Mutation> = .just(.setLoading(true))
            let finish: Observable<Mutation> = .just(.setLoading(false))
            let setSections: Observable<Mutation> = Single
                .zip(
                    searchService.searchArtists(with: currentState.query, filter: filter, limit: Constant.limit, page: 0),
                    searchService.searchVideos(with: currentState.query, filter: filter, limit: Constant.limit, page: 0)
                )
                .map {
                    let page = $0.1.count == Constant.limit ? 1 : nil
                    return .setSections(artists: $0.0, videos: $0.1, nextPage: page)
                }
                .catchError { .just(.setError($0)) }
                .asObservable()
            let setFilter: Observable<Mutation> = .just(.setFilter(filter))
            Tracker.shared.track(.search(currentState.query, filter))
            return .concat(start, setSections, finish, setFilter)

        case .loadMore:
            guard !self.currentState.isLoading, let nextPage = currentState.nextPage else { return .empty() }
            let start: Observable<Mutation> = .just(.setLoading(true))
            let finish: Observable<Mutation> = .just(.setLoading(false))
            let addVideos: Observable<Mutation> = searchService.searchVideos(with: currentState.query, filter: currentState.filter, limit: Constant.limit, page: nextPage)
                .map {
                    let page = $0.count == Constant.limit ? nextPage + 1 : nil
                    return .addVideos(videos: $0, nextPage: page)
                }
                .catchError { .just(.setError($0)) }
                .asObservable()
            return .concat(start, addVideos, finish)

        case .dismissErrorAlert:
            return .just(.setError(nil))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setLoading(let isLoading):
            state.isLoading = isLoading

        case .setLoadingMore(let isLoadingMore):
            state.isLoadingMore = isLoadingMore

        case .setEmpty(let isEmpty):
            state.isEmpty = isEmpty

        case .setQuery(let query):
            state.query = query

        case .setFilter(let filter):
            state.filter = filter

        case .setSections(let artists, let videos, let nextPage):
            state.sections = []
            if !artists.isEmpty {
                state.sections += [SearchResultViewSection(artists: artists)]
            }
            if !videos.isEmpty {
                state.sections += [SearchResultViewSection(videos: videos)]
            }
            state.isEmpty = artists.isEmpty && videos.isEmpty
            state.nextPage = nextPage

        case .addVideos(let videos, let nextPage):
            let allVideos = state.sections.last!.videos + videos
            state.sections[state.sections.count - 1] = SearchResultViewSection(videos: allVideos)
            state.nextPage = nextPage

        case .setError(let error):
            state.error = error
        }

        return state
    }

    func transform(action: Observable<Action>) -> Observable<Action> {
        let search: Observable<Action> = AppState.searchQuery.asObservable().debounce(0.3, scheduler: MainScheduler.instance).distinctUntilChanged().map { .search($0) }
        let filter: Observable<Action> = AppState.searchFilter.asObservable().map { .filter($0) }
        return .merge(action, search, filter)
    }
}
