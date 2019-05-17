//
//  AppState.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/12/02.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Foundation
import RxSwift

struct AppState {

    enum Tab: Int {
        case home, artists, genres, myPage
    }

    // MARK: - Property

    static let selectTab = PublishSubject<Tab>()
    static let watchedVideos = Variable<[Video]>([])
    static let isPlaying = PublishSubject<Bool>()
    static let progress = PublishSubject<CGFloat>()
    static let isRepeating = PublishSubject<Bool>()
    static let searchQuery = PublishSubject<SearchQuery>()
    static let searchFilter = PublishSubject<SearchFilter>()
}
