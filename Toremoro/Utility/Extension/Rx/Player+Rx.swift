//
//  Player+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/31.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import Player
import RxSwift
import RxCocoa
import AVFoundation

extension Reactive where Base: Player {
    var url: Binder<URL> {
        return Binder(self.base) { player, url in
            player.url = url
        }
    }

    var playFromCurrentTime: Binder<Void> {
        return Binder(self.base) { player, _ in
            player.playFromCurrentTime()
        }
    }

    var pause: Binder<Void> {
        return Binder(self.base) { player, _ in
            player.pause()
        }
    }

    var playbackLoops: Binder<Bool> {
        return Binder(self.base) { player, playbackLoops in
            player.playbackLoops = playbackLoops
        }
    }

    var seek: Binder<Double> {
        return Binder(self.base) { player, seconds in
            let time = CMTimeMakeWithSeconds(seconds, Int32(NSEC_PER_SEC))
            player.seekToTime(to: time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
}

final class RxPlayerDelegateProxy: DelegateProxy<Player, PlayerDelegate>, DelegateProxyType, PlayerDelegate {
    typealias Delegate = PlayerDelegate

    static func registerKnownImplementations() {
        self.register { RxPlayerDelegateProxy(player: $0) }
    }

    static func currentDelegate(for object: Player) -> PlayerDelegate? {
        return object.playerDelegate
    }

    static func setCurrentDelegate(_ delegate: PlayerDelegate?, to object: Player) {
        object.playerDelegate = delegate
    }

    init(player: Player) {
        super.init(parentObject: player, delegateProxy: RxPlayerDelegateProxy.self)
    }

    lazy var didReadySubject = PublishSubject<Void>()
    lazy var didChangePlaybackStateSubject = PublishSubject<PlaybackState>()
    lazy var didChangeBufferingStateSubject = PublishSubject<BufferingState>()
    lazy var didChangeBufferTimeSubject = PublishSubject<Double>()
    lazy var didFailSubject = PublishSubject<Error?>()

    func playerReady(_ player: Player) {
        forwardToDelegate()?.playerReady(player)
        didReadySubject.onNext(())
    }

    func playerPlaybackStateDidChange(_ player: Player) {
        forwardToDelegate()?.playerPlaybackStateDidChange(player)
        didChangePlaybackStateSubject.onNext(player.playbackState)
    }

    func playerBufferingStateDidChange(_ player: Player) {
        forwardToDelegate()?.playerPlaybackStateDidChange(player)
        didChangeBufferingStateSubject.onNext(player.bufferingState)
    }

    func playerBufferTimeDidChange(_ bufferTime: Double) {
        forwardToDelegate()?.playerBufferTimeDidChange(bufferTime)
        didChangeBufferTimeSubject.onNext(bufferTime)
    }

    func player(_ player: Player, didFailWithError error: Error?) {
        forwardToDelegate()?.player(player, didFailWithError: error)
        didFailSubject.onNext(error)
    }

    deinit {
        self.didReadySubject.on(.completed)
        self.didChangePlaybackStateSubject.on(.completed)
        self.didChangeBufferingStateSubject.on(.completed)
        self.didChangeBufferTimeSubject.on(.completed)
    }
}

extension Reactive where Base: Player {
    var didReady: Observable<Void> {
        return RxPlayerDelegateProxy.proxy(for: base).didReadySubject.asObservable()
    }

    var didChangePlaybackState: Observable<PlaybackState> {
        return RxPlayerDelegateProxy.proxy(for: base).didChangePlaybackStateSubject.asObservable()
    }

    var didChangeBufferingState: Observable<BufferingState> {
        return RxPlayerDelegateProxy.proxy(for: base).didChangeBufferingStateSubject.asObservable()
    }

    var didChangeBufferTime: Observable<Double> {
        return RxPlayerDelegateProxy.proxy(for: base).didChangeBufferTimeSubject.asObserver()
    }

    var didFail: Observable<Error?> {
        return RxPlayerDelegateProxy.proxy(for: base).didFailSubject.asObserver()
    }
}

final class RxPlaybackDelegateProxy: DelegateProxy<Player, PlayerPlaybackDelegate>, DelegateProxyType, PlayerPlaybackDelegate {
    typealias Delegate = PlayerPlaybackDelegate

    static func registerKnownImplementations() {
        self.register { RxPlaybackDelegateProxy(player: $0) }
    }

    static func currentDelegate(for object: Player) -> PlayerPlaybackDelegate? {
        return object.playbackDelegate
    }

    static func setCurrentDelegate(_ delegate: PlayerPlaybackDelegate?, to object: Player) {
        object.playbackDelegate = delegate
    }

    init(player: Player) {
        super.init(parentObject: player, delegateProxy: RxPlaybackDelegateProxy.self)
    }

    lazy var didChangeCurrentTimeSubject = PublishSubject<TimeInterval>()
    lazy var willStartFromBeginningSubject = PublishSubject<Void>()
    lazy var didEndPlaybackSubject = PublishSubject<Void>()
    lazy var willLoopPlaybackSubject = PublishSubject<Void>()

    func playerCurrentTimeDidChange(_ player: Player) {
        forwardToDelegate()?.playerCurrentTimeDidChange(player)
        didChangeCurrentTimeSubject.onNext(player.currentTime)
    }

    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        forwardToDelegate()?.playerPlaybackWillStartFromBeginning(player)
        willStartFromBeginningSubject.onNext(())
    }

    func playerPlaybackDidEnd(_ player: Player) {
        forwardToDelegate()?.playerPlaybackDidEnd(player)
        didEndPlaybackSubject.onNext(())
    }

    func playerPlaybackWillLoop(_ player: Player) {
        forwardToDelegate()?.playerPlaybackWillLoop(player)
        willLoopPlaybackSubject.onNext(())
    }

    deinit {
        self.didChangeCurrentTimeSubject.on(.completed)
        self.willStartFromBeginningSubject.on(.completed)
        self.didEndPlaybackSubject.on(.completed)
        self.willLoopPlaybackSubject.on(.completed)
    }
}

extension Reactive where Base: Player {
    var didChangeCurrentTime: Observable<TimeInterval> {
        return RxPlaybackDelegateProxy.proxy(for: base).didChangeCurrentTimeSubject.asObservable()
    }

    var willStartFromBeginning: Observable<Void> {
        return RxPlaybackDelegateProxy.proxy(for: base).willStartFromBeginningSubject.asObservable()
    }

    var didEndPlayback: Observable<Void> {
        return RxPlaybackDelegateProxy.proxy(for: base).didEndPlaybackSubject.asObservable()
    }

    var willLoopPlayback: Observable<Void> {
        return RxPlaybackDelegateProxy.proxy(for: base).willLoopPlaybackSubject.asObserver()
    }
}
