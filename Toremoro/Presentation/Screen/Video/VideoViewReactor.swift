//
//  VideoViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/18.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import ReactorKit
import RxSwift

final class VideoViewReactor: Reactor {

    enum Action {
        case prepare
        case dismissErrorAlert
    }

    enum Mutation {
        case setLoading(Bool)
        case setSections(artist: Artist, isFavorited: Bool, videos: [Video])
        case setError(Error?)
    }

    struct State {
        var video: Video
        var artist: Artist?
        var nextVideo: Video?
        var isLoading = false
        var sections: [VideoViewSection] = []
        var error: Error?
    }

    // MARK: - Property

    let initialState: State
    private let artistService = ArtistService()
    private let favoriteVideoService = FavoriteVideoService()
    private let videoService = VideoService()
    private let watchHistoryService = WatchHistoryService()

    // MARK: - Initializer

    init(video: Video) {
        self.initialState = State(video: video, artist: nil, nextVideo: nil, isLoading: false, sections: [], error: nil)
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
                    artistService.artist(by: currentState.video),
                    favoriteVideoService.isFavorite(currentState.video),
                    videoService.reletedVideos(by: currentState.video, limit: 10)
                )
                .map {
                    Mutation.setSections(artist: $0.0, isFavorited: $0.1, videos: $0.2)
                }
                .catchError { .just(.setError($0)) }
                .asObservable()
            let view = watchHistoryService.watch(currentState.video)
            return view.asObservable().flatMap { _ -> Observable<Mutation> in .concat(start, setSections, finish) }

        case .dismissErrorAlert:
            return .just(.setError(nil))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setLoading(let isLoading):
            state.isLoading = isLoading

        case .setSections(let artist, let isFavorited, let videos):
            state.sections = [
                VideoViewSection(video: state.video, artist: artist, isFavorited: isFavorited),
                VideoViewSection(related: videos)
            ]
            state.artist = artist
            state.nextVideo = videos.first

        case .setError(let error):
            state.error = error
        }

        return state
    }
}
