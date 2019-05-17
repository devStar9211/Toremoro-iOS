//
//  VideosViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/26.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxSwift
import ReactorKit

final class VideosViewReactor: Reactor {

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
        case setLoadingMore(Bool)
        case setSections(videos: [Video], nextPage: Int?)
        case addVideos(videos: [Video], nextPage: Int?)
        case setError(Error?)
    }

    struct State {
        var context: Context
        var isLoading = false
        var isLoadingMore = false
        var sections: [VideosViewSection] = []
        var title: String?
        var nextPage: Int?
        var error: Error?
    }

    typealias Context = VideosViewController.Context

    // MARK: - Property

    let initialState: State
    private let artistService = ArtistService()
    private let genreService = GenreService()
    private let featureService = FeatureService()
    private let favoriteVideoService = FavoriteVideoService()

    // MARK: - Initializer

    init(context: Context) {
        let title = VideosViewReactor.title(for: context)
        self.initialState = State(context: context, isLoading: false, isLoadingMore: false, sections: [], title: title, nextPage: 1, error: nil)
    }

    // MARK: - Public

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .prepare:
            guard !self.currentState.isLoading else { return .empty() }
            let start: Observable<Mutation> = .just(.setLoading(true))
            let finish: Observable<Mutation> = .just(.setLoading(false))
            let setSections: Observable<Mutation> = videos(by: currentState.context, page: 1)
                .map {
                    let page = $0.count == Constant.limit ? 2 : nil
                    return .setSections(videos: $0, nextPage: page)
                }
                .catchError { .just(.setError($0)) }
                .asObservable()
            return .concat(start, setSections, finish)

        case .loadMore:
            guard !self.currentState.isLoading else { return .empty() }
            guard !self.currentState.isLoadingMore else { return .empty() }
            guard let nextPage = self.currentState.nextPage else { return .empty() }
            let start: Observable<Mutation> = .just(.setLoadingMore(true))
            let finish: Observable<Mutation> = .just(.setLoadingMore(false))
            let addVideos: Observable<Mutation> = videos(by: currentState.context, page: nextPage)
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

        case .setSections(let videos, let nextPage):
            state.sections = [
                VideosViewSection(videos: videos)
            ]
            state.nextPage = nextPage

        case .addVideos(let videos, let nextPage):
            let allVideos = state.sections[0].items + videos
            state.sections = [
                VideosViewSection(videos: allVideos)
            ]
            state.nextPage = nextPage

        case .setError(let error):
            state.error = error
        }

        return state
    }

    // MARK: - Private

    private static func title(for context: Context) -> String? {
        switch context {
        case .artist(let artist):
            return artist.name
        case .populars(let artist):
            return artist.name
        case .genre(let genre):
            return genre.title
        case .feature(let feature):
            return feature.title
        case .favorites:
            return "FAVORITE VIDEOS"
        }
    }

    private func videos(by context: Context, page: Int) -> Single<[Video]> {
        switch context {
        case .artist(let artist):
            return artistService.videos(by: artist, limit: Constant.limit, page: page)
        case .populars(let artist):
            return artistService.popularVideos(by: artist, limit: Constant.limit, page: page)
        case .genre(let genre):
            return genreService.videos(in: genre, limit: Constant.limit, page: page)
        case .feature(let feature):
            return featureService.videos(in: feature, limit: Constant.limit, page: page)
        case .favorites:
            return favoriteVideoService.favoriteVideos(limit: Constant.limit, page: page)
        }
    }
}
