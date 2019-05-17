//
//  UIApplication+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/12/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIApplication {
    static var open: AnyObserver<URL> {
        return AnyObserver<URL> { observer in
            guard let url = observer.element else {
                return
            }
            UIApplication.shared.open(url)
        }
    }

    static var didFinishLaunching: Observable<Void> {
        return NotificationCenter.default.rx
            .notification(Notification.Name.UIApplicationDidFinishLaunching)
            .map { _ in }
    }

    static var willEnterForeground: Observable<Void> {
        return NotificationCenter.default.rx
            .notification(Notification.Name.UIApplicationWillEnterForeground)
            .map { _ in }
    }

    static var didBecomeActive: Observable<Void> {
        return NotificationCenter.default.rx
            .notification(Notification.Name.UIApplicationDidBecomeActive)
            .map { _ in }
    }

    static var didEnterBackground: Observable<Void> {
        return NotificationCenter.default.rx
            .notification(Notification.Name.UIApplicationDidEnterBackground)
            .map { _ in }
    }

    static var willResignActive: Observable<Void> {
        return NotificationCenter.default.rx
            .notification(Notification.Name.UIApplicationWillResignActive)
            .map { _ in }
    }

    static var willTerminate: Observable<Void> {
        return NotificationCenter.default.rx
            .notification(Notification.Name.UIApplicationWillTerminate)
            .map { _ in }
    }
}
