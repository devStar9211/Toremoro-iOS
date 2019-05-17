//
//  VideoPlayerReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/31.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxSwift
import ReactorKit

final class VideoPlayerReactor: Reactor {

    enum Action {
        case ready
        case play
        case pause
        case togglePlayPause
        case next
        case prev
        case control
        case fullscreen
        case progress(CGFloat)
        case setNextVideo(Video)
        case sleepTimerExpired
    }

    enum Mutation {
        case setLoading(Bool)
        case setPlaying(Bool)
        case setRepeating(Bool)
        case setControling(Bool)
        case setFullscreen(Bool)
        case setProgress(CGFloat)
        case setNextVideo(Video)
        case setPrevVideo(Video)
        case setReadyToPlay(Video)
        case setSleepTimerState(SleepTimer.State)
    }

    struct State {
        var video: Video
        var nextVideo: Video?
        var prevVideo: Video?
        var isLoading: Bool
        var isPlaying: Bool
        var isRepeating: Bool
        var isControling: Bool
        var isFullscreen: Bool
        var progress: CGFloat
        var readyToPlay: Video?
        var sleepTimerState: SleepTimer.State
    }

    // MARK: - Property

    let initialState: State

    // MARK: - Initializer

    init(video: Video) {
        self.initialState = State(
            video: video,
            nextVideo: nil,
            prevVideo: nil,
            isLoading: true,
            isPlaying: false,
            isRepeating: false,
            isControling: false,
            isFullscreen: false,
            progress: 0,
            readyToPlay: nil,
            sleepTimerState: SleepTimer.shared.state
        )
    }

    // MARK: - Public

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .ready:
            return .just(.setLoading(false))

        case .play:
            AppState.isPlaying.on(.next(true))
            return .just(.setPlaying(true))

        case .pause:
            AppState.isPlaying.on(.next(false))
            return .just(.setPlaying(false))

        case .togglePlayPause:
            let playing = currentState.isPlaying
            AppState.isPlaying.on(.next(!playing))
            return .just(.setPlaying(!playing))

        case .next:
            guard let video = currentState.nextVideo else {
                return .empty()
            }
            return .just(.setReadyToPlay(video))

        case .prev:
            guard let video = currentState.prevVideo else {
                return .empty()
            }
            return .just(.setReadyToPlay(video))

        case .control:
            let controling = currentState.isControling
            return .just(.setControling(!controling))

        case .fullscreen:
            let fullscreen = currentState.isFullscreen
            return .just(.setFullscreen(!fullscreen))

        case .progress(let progress):
            AppState.progress.on(.next(progress))
            return .just(.setProgress(progress))

        case .setNextVideo(let video):
            return .just(.setNextVideo(video))

        case .sleepTimerExpired:
            return .just(.setPlaying(false))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setLoading(let loading):
            state.isLoading = loading

        case .setPlaying(let playing):
            state.isPlaying = playing

        case .setRepeating(let repeating):
            state.isRepeating = repeating

        case .setControling(let controling):
            state.isControling = controling

        case .setFullscreen(let fullscreen):
            state.isFullscreen = fullscreen

        case .setProgress(let progress):
            state.progress = progress

        case .setNextVideo(let video):
            state.nextVideo = video

        case .setPrevVideo(let video):
            state.prevVideo = video

        case .setReadyToPlay(let video):
            state.readyToPlay = video

        case .setSleepTimerState(let sleepTimerState):
            state.sleepTimerState = sleepTimerState
        }

        return state
    }

    func transform(action: Observable<Action>) -> Observable<Action> {
        return action
            .do(onNext: {
                switch $0 {
                case .sleepTimerExpired:
                    SleepTimer.shared.state = .off
                default:
                    break
                }
            })
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let setPlaying: Observable<Mutation> = AppState.isPlaying.asObserver().map { .setPlaying($0) }
        let setPrevVideo: Observable<Mutation> = AppState.watchedVideos.asObservable().filter { $0.count > 1 }.map { $0[$0.count - 2] }.map { .setPrevVideo($0) }
        let setRepeating: Observable<Mutation> = AppState.isRepeating.asObserver().map { .setRepeating($0) }
        let setSleepTimerState: Observable<Mutation> = SleepTimer.shared.rx.state.map { .setSleepTimerState($0) }
        return .merge(mutation, setPlaying, setPrevVideo, setRepeating, setSleepTimerState)
    }
}
