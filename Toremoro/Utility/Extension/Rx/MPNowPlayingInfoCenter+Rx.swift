//
//  MPNowPlayingInfoCenter+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/27.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import UIKit
import MediaPlayer
import RxSwift
import RxCocoa

private func artwork(for image: UIImage) -> MPMediaItemArtwork {
    return MPMediaItemArtwork(boundsSize: image.size) { _ -> UIImage in
        return image
    }
}

private let defaultPlayingInfo: [String: Any] = {
    return [
        MPMediaItemPropertyArtwork: artwork(for: #imageLiteral(resourceName: "App"))
    ]
}()

extension Reactive where Base: MPNowPlayingInfoCenter {
    var nowPlayingTitle: Binder<String> {
        return Binder(self.base) { center, title in
            var nowPlayingInfo = center.nowPlayingInfo ?? defaultPlayingInfo
            nowPlayingInfo[MPMediaItemPropertyTitle] = title
            center.nowPlayingInfo = nowPlayingInfo
        }
    }

    var nowPlayingArtist: Binder<String> {
        return Binder(self.base) { center, artist in
            var nowPlayingInfo = center.nowPlayingInfo ?? defaultPlayingInfo
            nowPlayingInfo[MPMediaItemPropertyArtist] = artist
            center.nowPlayingInfo = nowPlayingInfo
        }
    }

    var nowPlayingDuration: Binder<TimeInterval> {
        return Binder(self.base) { center, duration in
            var nowPlayingInfo = center.nowPlayingInfo ?? defaultPlayingInfo
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
            center.nowPlayingInfo = nowPlayingInfo
        }
    }
}
