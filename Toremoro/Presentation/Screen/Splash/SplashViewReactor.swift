//
//  SplashViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/07.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxSwift
import RxOptional
import ReactorKit

final class SplashViewReactor: Reactor {

    enum Action {
        case prepare
        case dismissErrorAlert
    }

    enum Mutation {
        case setAppStoreUrl(URL)
        case setAuthenticated(Bool)
        case setRequiredUpdate(Bool)
        case setError(Error?)
    }

    struct State {
        var appStoreUrl: URL?
        var isAuthenticated: Bool?
        var isRequiredUpdate: Bool?
        var error: Error?
    }

    // MARK: - Property

    let initialState = State()

    private let userService = UserService()
    private let forceUpdateService = ForceUpdateService()
    private let remoteConfigClient = RemoteConfigClient()

    // MARK: - Public

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .prepare:
            let setAppStoreUrl: Observable<Mutation> = remoteConfigClient.get(by: .appStoreUrl).filterNil().map { URL(string: $0)! }.asObservable().map { .setAppStoreUrl($0) }
            let setAuthenticated: Observable<Mutation> = userService.authenticate().asObservable().map { .setAuthenticated(true) }
            let setRequiredUpdate: Observable<Mutation> = forceUpdateService.checkUpdate().asObservable().map { .setRequiredUpdate($0) }
            return .concat(setAppStoreUrl, setAuthenticated, setRequiredUpdate)

        case .dismissErrorAlert:
            return .just(.setError(nil))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setAppStoreUrl(let url):
            state.appStoreUrl = url

        case .setAuthenticated(let isAuthenticated):
            state.isAuthenticated = isAuthenticated

        case .setRequiredUpdate(let isRequiredUpdate):
            state.isRequiredUpdate = isRequiredUpdate

        case .setError(let error):
            state.error = error
        }

        return state
    }
}
