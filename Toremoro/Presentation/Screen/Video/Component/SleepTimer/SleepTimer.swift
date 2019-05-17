//
//  SleepTimer.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/02/11.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SleepTimer: NSObject {

    enum State {
        case time(start: Date, limit: TimeInterval)
        case untilTheEnd
        case off
    }

    // MARK: - Property

    static let shared = SleepTimer()

    var state: State = .off {
        didSet {
            stateSubject.onNext(state)
        }
    }

    fileprivate let stateSubject = PublishSubject<State>()

    // MARK: - Initializer

    private override init() {}
}

extension SleepTimer.State {
    init(minutes: TimeInterval) {
        self = .time(start: Date(), limit: 60 * minutes)
    }

    var remainingTime: TimeInterval? {
        guard case .time(let start, let limit) = self else {
            return nil
        }
        return limit - Date().timeIntervalSince(start)
    }

    var expired: Bool {
        guard case .time(let start, let limit) = self else {
            return false
        }
        return limit < Date().timeIntervalSince(start) + 1
    }
}

// MARK: - Equatable

extension SleepTimer.State: Equatable {
    static func == (lhs: SleepTimer.State, rhs: SleepTimer.State) -> Bool {
        switch (lhs, rhs) {
        case (.time(let lstart, _), .time(let rstart, _)):
            return lstart == rstart
        case (.untilTheEnd, .untilTheEnd):
            return true
        case (.off, .off):
            return true
        default:
            return false
        }
    }
}

// MARK: - Rx

extension Reactive where Base: SleepTimer {
    var state: Observable<Base.State> {
        return self.base.stateSubject.asObservable()
    }

    var set: Binder<Base.State> {
        return Binder(self.base) { timer, state in
            timer.state = state
        }
    }
}
