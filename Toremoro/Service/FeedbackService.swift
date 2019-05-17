//
//  FeedbackService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import RxSwift

struct FeedbackService {

    // MARK: - Property

    private let networking = Networking<FeedbackTarget>()

    // MARK: - Public

    func submit(_ draft: DraftFeedback) -> Single<Void> {
        let result: Single<Feedback> = networking.rx.request(.create(body: draft.body, email: draft.email))
        return result.map { _ in  }
    }
}
