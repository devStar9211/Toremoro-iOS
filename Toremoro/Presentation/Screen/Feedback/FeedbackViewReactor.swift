//
//  FeedbackViewReactor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/26.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxSwift
import ReactorKit

final class FeedbackViewReactor: Reactor {

    enum Action {
        case inputBody(String)
        case inputEmail(String)
        case submit
        case dismissErrorAlert
    }

    enum Mutation {
        case setLoading(Bool)
        case setSuccessed(Bool)
        case setBody(String)
        case setEmail(String)
        case setError(Error?)
    }

    struct State {
        var isLoading = false
        var isSuccessed = false
        var body: String = ""
        var email: String = ""
        var error: Error?
    }

    // MARK: - Property

    let initialState = State()
    private let feedbackService = FeedbackService()

    // MARK: - Public

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .inputBody(let body):
            return .just(.setBody(body))

        case .inputEmail(let email):
            return .just(.setEmail(email))

        case .submit:
            guard !self.currentState.isLoading else { return .empty() }
            let draft = DraftFeedback(body: currentState.body, email: currentState.email)
            if let error = draft.validatedError {
                return .just(.setError(error))
            } else {
                let startLoading: Observable<Mutation> = .just(.setLoading(true))
                let endLoading: Observable<Mutation> = .just(.setLoading(false))
                let setSuccessed: Observable<Mutation> = feedbackService.submit(draft)
                    .map {
                        .setSuccessed(true)
                    }
                    .catchError { .just(.setError($0)) }
                    .asObservable()
                return .concat(startLoading, setSuccessed, endLoading)
            }

        case .dismissErrorAlert:
            return .just(.setError(nil))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setLoading(let isLoading):
            state.isLoading = isLoading

        case .setSuccessed(let isSuccessed):
            state.isSuccessed = isSuccessed

        case .setBody(let body):
            state.body = body

        case .setEmail(let email):
            state.email = email

        case .setError(let error):
            state.error = error
        }

        return state
    }
}
