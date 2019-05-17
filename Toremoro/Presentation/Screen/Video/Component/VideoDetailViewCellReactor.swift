//
//  VideoDetailViewCellReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/10/19.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import RxSwift
import ReactorKit

final class VideoDetailViewCellReactor: Reactor {

    enum Action {
        case favorite
        case `repeat`
        case offSleepTimer
        case share
        case readMore
        case dismissShareActivity
    }

    enum Mutation {
        case setFavorite(Bool)
        case setRepeating(Bool)
        case setSleepTimerState(SleepTimer.State)
        case setShareText(String?)
        case setReadMore(Bool)
        case setError(Error?)
    }

    struct State {
        var video: Video
        var artist: Artist
        var isFavorited: Bool
        var isRepeating: Bool
        var sleepTimerState: SleepTimer.State
        var shareText: String?
        var isReadMore: Bool
        var error: Error?
    }

    // MARK: - Property

    let initialState: State
    private let favoriteVideoService = FavoriteVideoService()

    // MARK: - Initializer

    init(video: Video, artist: Artist, isFavorited: Bool) {
        self.initialState = State(
            video: video,
            artist: artist,
            isFavorited: isFavorited,
            isRepeating: false,
            sleepTimerState: SleepTimer.shared.state,
            shareText: nil,
            isReadMore: false,
            error: nil
        )
    }

    // MARK: - Public

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .favorite:
            let isFavorited = currentState.isFavorited
            let setFavorite: Observable<Mutation> = .just(.setFavorite(!isFavorited))

            if isFavorited {
                let favorite: Observable<Mutation> = favoriteVideoService
                    .unfavorite(currentState.video)
                    .asObservable()
                    .flatMap { Observable.empty() }
                    .catchError { .just(.setError($0)) }
                return .merge(setFavorite, favorite)
            } else {
                let favorite: Observable<Mutation> = favoriteVideoService
                    .favorite(currentState.video)
                    .asObservable()
                    .flatMap { Observable.empty() }
                    .catchError { .just(.setError($0)) }
                return .merge(setFavorite, favorite)
            }

        case .repeat:
            let repeating = !currentState.isRepeating
            AppState.isRepeating.onNext(repeating)
            return .just(.setRepeating(repeating))

        case .offSleepTimer:
            return .just(.setSleepTimerState(.off))

        case .share:
            let text = """
            \(currentState.video.title)
            \(currentState.video.shareUrl?.absoluteString ?? "")

            @toremoro_app より
            #ASMR #toremoro
            """
            return .just(.setShareText(text))

        case .readMore:
            let readMore = !currentState.isReadMore
            return .just(.setReadMore(readMore))

        case .dismissShareActivity:
            return .just(.setShareText(nil))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setFavorite(let favorited):
            state.isFavorited = favorited

        case .setRepeating(let repeating):
            state.isRepeating = repeating

        case .setSleepTimerState(let sleepTimerState):
            state.sleepTimerState = sleepTimerState

        case .setShareText(let shareText):
            state.shareText = shareText

        case .setReadMore(let readMore):
            state.isReadMore = readMore

        case .setError(let error):
            state.error = error
        }

        return state
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let setSleepTimerState: Observable<Mutation> = SleepTimer.shared.rx.state.map { .setSleepTimerState($0) }
        return .merge(mutation, setSleepTimerState)
    }
}
