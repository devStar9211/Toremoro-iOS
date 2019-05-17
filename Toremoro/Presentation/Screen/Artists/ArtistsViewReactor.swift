//
//  ArtistsViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/13.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import ReactorKit
import RxSwift

final class ArtistsViewReactor: Reactor {

    private struct Constant {
        static let limit = 20
    }

    enum Action {
        case prepare
        case loadMore
        case dismissErrorAlert
    }

    enum Mutation {
        case setLoading(Bool)
        case setSections(pickup: [Artist], popular: [Artist], nextPage: Int?)
        case setSection(artists: [Artist], nextPage: Int?)
        case addArtists(artists: [Artist], nextPage: Int?)
        case setError(Error?)
    }

    struct State {
        var context: Context
        var isLoading = false
        var isLoadingMore = false
        var sections: [ArtistsViewSection] = []
        var title: String?
        var nextPage: Int?
        var error: Error?
    }

    typealias Context = ArtistsViewController.Context

    // MARK: - Property

    let initialState: State
    private let artistService = ArtistService()
    private let favoriteArtistService = FavoriteArtistService()
    private let featureService = FeatureService()

    // MARK: - Initializer

    init(context: ArtistsViewController.Context) {
        let title = ArtistsViewReactor.title(for: context)
        self.initialState = State(context: context, isLoading: false, isLoadingMore: false, sections: [], title: title, nextPage: 1, error: nil)
    }

    // MARK: - Public

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .prepare:
            guard !currentState.isLoading else { return .empty() }
            let start: Observable<Mutation> = .just(.setLoading(true))
            let finish: Observable<Mutation> = .just(.setLoading(false))
            let setSections: Observable<Mutation> = artists(by: currentState.context, page: 1)
                .flatMap { artists -> Single<Mutation> in
                    let page = artists.count == Constant.limit ? 2 : nil
                    switch self.currentState.context {
                    case .main:
                        return self.artistService.pickupArtists(limit: 5)
                            .map {
                                .setSections(pickup: $0, popular: artists, nextPage: page)
                            }
                    case .favorite, .feature:
                        return .just(.setSection(artists: artists, nextPage: page))
                    }
                }
                .catchError { .just(.setError($0)) }
                .asObservable()
            return .concat(start, setSections, finish)

        case .loadMore:
            guard !currentState.isLoading else { return .empty() }
            guard !self.currentState.isLoadingMore else { return .empty() }
            guard let nextPage = self.currentState.nextPage else { return .empty() }
            let start: Observable<Mutation> = .just(.setLoading(true))
            let finish: Observable<Mutation> = .just(.setLoading(false))
            let addArtists: Observable<Mutation> = artists(by: currentState.context, page: nextPage)
                .map {
                    let page = $0.count == Constant.limit ? nextPage + 1 : nil
                    return .addArtists(artists: $0, nextPage: page)
                }
                .catchError { .just(.setError($0)) }
                .asObservable()
            return .concat(start, addArtists, finish)

        case .dismissErrorAlert:
            return .just(.setError(nil))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setLoading(let isLoading):
            state.isLoading = isLoading

        case .setSections(let pickup, let popular, let nextPage):
            state.sections = [
                ArtistsViewSection(pickup: pickup),
                ArtistsViewSection(popular: popular)
            ]
            state.nextPage = nextPage

        case .setSection(let artists, let nextPage):
            state.sections = [
                ArtistsViewSection(artists: artists)
            ]
            state.nextPage = nextPage

        case .addArtists(let artists, let nextPage):
            let allArtists: [Artist] = {
                switch state.context {
                case .main:
                    return state.sections[1].items.map { $0.artist } + artists
                case .favorite, .feature:
                    return state.sections[0].items.map { $0.artist } + artists
                }
            }()
            state.sections[state.sections.count - 1] = ArtistsViewSection(artists: allArtists)
            state.nextPage = nextPage

        case .setError(let error):
            state.error = error
        }

        return state
    }

    // MARK: - Private

    private static func title(for context: Context) -> String? {
        switch context {
        case .main:
            return nil
        case .favorite:
            return "FAVORITE ARTISTS"
        case .feature(let feature):
            return feature.title
        }
    }

    private func artists(by context: Context, page: Int) -> Single<[Artist]> {
        switch context {
        case .main:
            return artistService.artists(limit: Constant.limit, page: page)
        case .favorite:
            return favoriteArtistService.favoriteArtists(limit: Constant.limit, page: page)
        case .feature(let feature):
            return featureService.artists(in: feature, limit: Constant.limit, page: page)
        }
    }
}
