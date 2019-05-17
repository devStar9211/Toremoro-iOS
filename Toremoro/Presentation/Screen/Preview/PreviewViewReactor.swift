//
//  PreviewViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/02/24.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import RxSwift
import ReactorKit

final class PreviewViewReactor: Reactor {

    enum Action {
        case prepare
        case dismiss
    }

    enum Mutation {
        case setError(Error?)
        case setDestination(Destination?)
        case setDismiss(Bool)
    }

    struct State {
        var context: Context
        var error: Error?
        var destination: Destination?
        var dismissed: Bool
    }

    enum Destination {
        case video(Video)
    }

    typealias Context = PreviewViewController.Context

    // MARK: - Property

    let initialState: State
    private let videoService = VideoService()

    // MARK: - Initializer

    init(context: Context) {
        self.initialState = State(context: context, error: nil, destination: nil, dismissed: false)
    }

    // MARK: - Public

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .prepare:
            return destination(for: currentState.context)
                .map { .setDestination($0) }
                .catchError { .just(.setError($0)) }
                .asObservable()

        case .dismiss:
            return .just(.setDismiss(true))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setError(let error):
            state.error = error

        case .setDestination(let destination):
            state.destination = destination

        case .setDismiss(let dismiss):
            state.dismissed = dismiss
        }

        return state
    }

    // MARK: - Private

    func destination(for context: Context) -> Single<Destination> {
        switch context {
        case .video(let id):
            return videoService.video(by: id).map { .video($0) }
        }
    }
}
