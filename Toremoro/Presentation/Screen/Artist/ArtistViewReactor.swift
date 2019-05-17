//
//  ArtistViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/14.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxSwift
import ReactorKit

final class ArtistViewReactor: Reactor {

    enum Action {
        case prepare
        case dismissErrorAlert
    }

    enum Mutation {
        case setLoading(Bool)
        case setSections(isFavorited: Bool, new: [Video], popular: [Video])
        case setError(Error?)
    }

    struct State {
        var artist: Artist
        var isLoading = false
        var sections: [ArtistViewSection] = []
        var error: Error?
    }

    // MARK: - Property

    let initialState: State
    private let artistService = ArtistService()
    private let favoriteArtistService = FavoriteArtistService()

    // MARK: - Initializer

    init(artist: Artist) {
        self.initialState = State(artist: artist, isLoading: false, sections: [], error: nil)
    }

    // MARK: - Public

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .prepare:
            guard !self.currentState.isLoading else { return .empty() }
            let start: Observable<Mutation> = .just(.setLoading(true))
            let finish: Observable<Mutation> = .just(.setLoading(false))
            let setSections = Single
                .zip(
                    favoriteArtistService.isFavorite(currentState.artist),
                    artistService.videos(by: currentState.artist, limit: 5),
                    artistService.popularVideos(by: currentState.artist, limit: 5)
                )
                .map {
                    Mutation.setSections(isFavorited: $0.0, new: $0.1, popular: $0.2)
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

        case .setSections(let isFavorited, let newVideos, let popularVideos):
            state.sections = [
                ArtistViewSection(profile: state.artist, isFavorited: isFavorited),
                ArtistViewSection(popular: popularVideos),
                ArtistViewSection(new: newVideos)
            ]

        case .setError(let error):
            state.error = error
        }

        return state
    }
}
