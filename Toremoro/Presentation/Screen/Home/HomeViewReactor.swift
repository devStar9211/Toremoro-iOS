//
//  HomeViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/13.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import ReactorKit
import RxSwift

final class HomeViewReactor: Reactor {

    enum Action {
        case prepare
        case dismissErrorAlert
    }

    enum Mutation {
        case setLoading(Bool)
        case setSections(features: [Feature], artists: [Artist], genres: [Genre])
        case setError(Error?)
    }

    struct State {
        var isLoading = false
        var sections: [HomeViewSection] = []
        var error: Error?
    }

    // MARK: - Property

    let initialState: State = State()
    private let featureService = FeatureService()
    private let artistService = ArtistService()
    private let genreService = GenreService()

    // MARK: - Public

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .prepare:
            guard !self.currentState.isLoading else { return .empty() }
            let start: Observable<Mutation> = .just(.setLoading(true))
            let finish: Observable<Mutation> = .just(.setLoading(false))
            let setSections = Single
                .zip(
                    featureService.features(limit: 200),
                    artistService.pickupArtists(limit: 5),
                    genreService.pickupGenres(limit: 5)
                )
                .map {
                    Mutation.setSections(features: $0.0, artists: $0.1, genres: $0.2)
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

        case .setSections(let features, let artists, let genres):
            state.sections = [
                HomeViewSection(features: features),
                HomeViewSection(artists: artists),
                HomeViewSection(genres: genres)
            ]

        case .setError(let error):
            state.error = error
        }

        return state
    }
}
