//
//  WebViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/26.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxSwift
import ReactorKit

final class WebViewReactor: Reactor {

    typealias Action = NoAction

    struct State {
        let url: URL
    }

    // MARK: - Property

    let initialState: State

    // MARK: - Initializer

    init(url: URL) {
        self.initialState = State(url: url)
        _ = self.state
    }
}
