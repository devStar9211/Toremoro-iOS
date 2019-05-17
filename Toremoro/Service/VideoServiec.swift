//
//  VideoServiec.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import RxSwift

struct VideoService {

    // MARK: - Property

    private let networking = Networking<VideoTarget>()

    // MARK: - Public

    func videos(limit: Int = 20, page: Int = 1) -> Single<[Video]> {
        return networking.rx.request(.showAll, limit: limit, page: page)
    }

    func reletedVideos(by video: Video, limit: Int = 20, page: Int = 1) -> Single<[Video]> {
        return networking.rx.request(.showRelatedVideos(id: video.id), limit: limit, page: page)
    }

    func video(by id: Video.Id) -> Single<Video> {
        return networking.rx.request(.show(id: id))
    }
}
