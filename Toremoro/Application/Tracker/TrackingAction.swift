//
//  TrackingAction.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/12/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Foundation

enum TrackingAction {
    case tutorialSkip
    case tutorialStart
    case openPlayer
    case playOnMiniPlayer
    case seeMoreArtists
    case seeMoreGenres
    case readMoreArtist
    case closePlayer
    case showArtistFromPlayer
    case readMoreVideo
    case playOnRemotePlayer
    case togglePlayOnRemotePlayer
    case pauseOnRemotePlayer
    case nextOnRemotePlayer
    case prevOnRemotePlayer
    case seekTimeOnPlayer
    case playOnPlayer
    case nextOnPlayer
    case prevOnPlayer
    case forwardOnPlayer
    case replayOnPlayer
    case fullscreenOnPlayer
    case sleepTimer15min
    case sleepTimer30min
    case sleepTimer45min
    case sleepTimer1h
    case sleepTimer2h
    case sleepTimerUntilTheEnd
    case sleepTimerCustom
    case sleepTimerOff
    case share
    case repeatOn
    case repeatOff
    case favoriteVideo
    case unfavoriteVideo
    case favoriteArtist
    case unfavoriteArtist
    case submitFeedback
    case completeFeedback
    case inputSearch
    case doneSearch
    case cancelSearch
}

extension TrackingAction {
    private var name: String {
        switch self {
        case .tutorialSkip: return "tutorial_skip"
        case .tutorialStart: return "tutorial_start"
        case .openPlayer: return "open_player"
        case .playOnMiniPlayer: return "play_on_mini_player"
        case .seeMoreArtists: return "see_more_artist"
        case .seeMoreGenres: return "see_more_genres"
        case .readMoreArtist: return "read_more_artist"
        case .closePlayer: return "close_player"
        case .showArtistFromPlayer: return "show_artist_from_player"
        case .readMoreVideo: return "read_more_video"
        case .playOnRemotePlayer: return "play_on_remote_player"
        case .togglePlayOnRemotePlayer: return "toggle_play_on_remote_player"
        case .pauseOnRemotePlayer: return "pause_on_remote_player"
        case .nextOnRemotePlayer: return "next_on_remote_player"
        case .prevOnRemotePlayer: return "prev_on_remote_player"
        case .seekTimeOnPlayer: return "seek_time_on_player"
        case .playOnPlayer: return "play_on_player"
        case .nextOnPlayer: return "next_on_player"
        case .prevOnPlayer: return "prev_on_player"
        case .forwardOnPlayer: return "forward_on_player"
        case .replayOnPlayer: return "replay_on_player"
        case .fullscreenOnPlayer: return "fullscreen_on_player"
        case .sleepTimer15min: return "sleep_timer_15min"
        case .sleepTimer30min: return "sleep_timer_30min"
        case .sleepTimer45min: return "sleep_timer_45min"
        case .sleepTimer1h: return "sleep_timer_1h"
        case .sleepTimer2h: return "sleep_timer_2h"
        case .sleepTimerUntilTheEnd: return "sleep_timer_until_the_end"
        case .sleepTimerCustom: return "sleep_timer_custom"
        case .sleepTimerOff: return "sleep_timer_off"
        case .share: return "share"
        case .repeatOn: return "repeat_on"
        case .repeatOff: return "repeat_off"
        case .favoriteVideo: return "favorite_video"
        case .unfavoriteVideo: return "unfavorite_video"
        case .favoriteArtist: return "favorite_artist"
        case .unfavoriteArtist: return "unfavorite_artist"
        case .submitFeedback: return "submit_feedback"
        case .completeFeedback: return "complete_feedback"
        case .inputSearch: return "input_search"
        case .doneSearch: return "done_search"
        case .cancelSearch: return "cancel_search"
        }
    }

    var parameters: [String: Any] {
        return ["name": name]
    }
}
