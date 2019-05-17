//
//  TrackingEvent.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/12/08.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Foundation

enum TrackingEvent {
    case screen_view(TrackingScreen)
    case tap_action(TrackingAction)
    case video_play(Video, progress: Double, backgroundDuration: Double)
    case share(ActivityType, Video)
    case search(SearchQuery, SearchFilter)
    case error(PresentationError)
}

extension TrackingEvent {
    var name: String {
        switch self {
        case .screen_view: return "screen_views" // screen_viewはデフォルトで使われているため
        case .tap_action: return "tap_action"
        case .video_play: return "video_play"
        case .share: return "video_share"
        case .search: return "search"
        case .error: return "error"
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .screen_view(let screen):
            return screen.parameters

        case .tap_action(let action):
            return action.parameters

        case .video_play(let video, let progress, let backgroundDuration):
            return [
                "video_id": video.id,
                "progress": progress,
                "viewing_time": video.duration * progress,
                "background_duration": backgroundDuration,
                "background_time": video.duration * backgroundDuration
            ]

        case .share(let activity, let video):
            return [
                "destination": activity.name,
                "video_id": video.id
            ]

        case .search(let query, let filter):
            return [
                "query": query,
                "order": filter.order.rawValue,
                "duration": filter.duration.rawValue,
                "sex": filter.sex.rawValue
            ]

        case .error(let error):
            return [
                "title": error.title,
                "message": error.message ?? ""
            ]
        }
    }
}
