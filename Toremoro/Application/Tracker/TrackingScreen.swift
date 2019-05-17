//
//  TrackingScreen.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/12/08.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Foundation

enum TrackingScreen {
    case splash
    case tutorial(index: Int)
    case home
    case artists
    case favoriteArtists
    case featureArtists(Feature)
    case artist(Artist)
    case genres
    case artistVideos(Artist)
    case artistPopularVideos(Artist)
    case genreVideos(Genre)
    case featureVideos(Feature)
    case favoriteVideos
    case video(Video)
    case sleepTimer
    case myPage
    case web(URL)
    case feedback
    case search
    case searchFilter
}

extension TrackingScreen {
    private var name: String {
        switch self {
        case .splash: return "splash"
        case .tutorial: return "tutorial"
        case .home: return "home"
        case .artists: return "artists"
        case .favoriteArtists: return "favorite_artists"
        case .featureArtists: return "feature_artists"
        case .artist: return "artist"
        case .genres: return "genres"
        case .artistVideos: return "artist_videos"
        case .artistPopularVideos: return "artist_popular_videos"
        case .genreVideos: return "genre_videos"
        case .featureVideos: return "feature_videos"
        case .favoriteVideos: return "favorite_videos"
        case .video: return "video"
        case .sleepTimer: return "sleep_timer"
        case .myPage: return "my_page"
        case .web: return "web"
        case .feedback: return "feedback"
        case .search: return "search"
        case .searchFilter: return "search_filter"
        }
    }

    private var contentId: String? {
        switch self {
        case .splash: return nil
        case .tutorial(let index): return "\(index)"
        case .home: return nil
        case .artists: return nil
        case .favoriteArtists: return nil
        case .featureArtists(let feature): return "\(feature.id)"
        case .artist(let artist): return "\(artist.id)"
        case .genres: return nil
        case .artistVideos(let artist): return "\(artist.id)"
        case .artistPopularVideos(let artist): return "\(artist.id)"
        case .genreVideos(let genre): return "\(genre.id)"
        case .featureVideos(let feature): return "\(feature.id)"
        case .favoriteVideos: return nil
        case .video(let video): return "\(video.id)"
        case .sleepTimer: return nil
        case .myPage: return nil
        case .web(let url): return url.absoluteString
        case .feedback: return nil
        case .search: return nil
        case .searchFilter: return nil
        }
    }

    var parameters: [String: Any] {
        var parameters = ["name": name]

        if let contentId = contentId {
            parameters["content_id"] = contentId
        }

        return parameters
    }
}
