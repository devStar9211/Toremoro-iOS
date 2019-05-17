//
//  ArtistProfileViewCellReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/10/18.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import RxSwift
import ReactorKit

final class ArtistProfileViewCellReactor: Reactor {

    enum Action {
        case favorite
        case back
        case readMore
    }

    enum Mutation {
        case setFavorite(Bool)
        case setBack(Bool)
        case setReadMore(Bool)
        case setError(Error?)
    }

    struct State {
        var artist: Artist
        var isFavorited: Bool
        var isBacked: Bool
        var isReadMore: Bool
        var error: Error?
    }

    // MARK: - Property

    let initialState: State
    private let favoriteArtistService = FavoriteArtistService()

    // MARK: - Initializer

    init(artist: Artist, isFavorited: Bool) {
        self.initialState = State(artist: artist, isFavorited: isFavorited, isBacked: false, isReadMore: false, error: nil)
    }

    // MARK: - Public

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .favorite:
            let isFavorited = currentState.isFavorited
            let setFavorite: Observable<Mutation> = .just(.setFavorite(!isFavorited))

            if isFavorited {
                let favorite: Observable<Mutation> = favoriteArtistService
                    .unfavorite(currentState.artist)
                    .asObservable()
                    .flatMap { Observable.empty() }
                    .catchError { .just(.setError($0)) }
                return .merge(setFavorite, favorite)
            } else {
                let favorite: Observable<Mutation> = favoriteArtistService
                    .favorite(currentState.artist)
                    .asObservable()
                    .flatMap { Observable.empty() }
                    .catchError { .just(.setError($0)) }
                return .merge(setFavorite, favorite)
            }

        case .back:
            return .just(.setBack(true))

        case .readMore:
            let readMore = !currentState.isReadMore
            return .just(.setReadMore(readMore))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setFavorite(let favorited):
            state.isFavorited = favorited

        case .setBack(let backed):
            state.isBacked = backed

        case .setReadMore(let readMore):
            state.isReadMore = readMore

        case .setError(let error):
            state.error = error
        }

        return state
    }
}
