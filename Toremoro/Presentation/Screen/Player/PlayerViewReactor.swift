//
//  PlayerViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/18.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import ReactorKit
import RxSwift

final class PlayerViewReactor: Reactor {

    enum Action {
        case play
    }

    enum Mutation {
        case setPlaying(Bool)
        case setProgress(CGFloat)
    }

    struct State {
        var video: Video?
        var isPlaying: Bool
        var progress: CGFloat
    }

    // MARK: - Property

    let initialState: State

    // MARK: - Initializer

    init(video: Video) {
        self.initialState = State(video: video, isPlaying: false, progress: 0)
    }

    // MARK: - Public

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .play:
            let playing = currentState.isPlaying
            AppState.isPlaying.on(.next(!playing))
            return .just(.setPlaying(!playing))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setPlaying(let playing):
            state.isPlaying = playing

        case .setProgress(let progress):
            state.progress = progress
        }

        return state
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let setPlaying: Observable<Mutation> = AppState.isPlaying.asObserver().map { .setPlaying($0) }
        let setProgress: Observable<Mutation> = AppState.progress.asObserver().map { .setProgress($0) }
        return .merge(mutation, setPlaying, setProgress)
    }
}
