//
//  VideoPlayer.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/30.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Player
import ReactorKit
import MediaPlayer

final class VideoPlayer: UIViewController, PopupPresentable {

    // MARK: - Outlet

    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var controlView: UIView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var forwardButton: UIButton!
    @IBOutlet private weak var replayButton: UIButton!
    @IBOutlet private weak var skipNextButton: UIButton!
    @IBOutlet private weak var skipPrevButton: UIButton!
    @IBOutlet private weak var fullscreenButton: UIButton!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var totalTimeLabel: UILabel!
    @IBOutlet private weak var progressView: ProgressView!
    @IBOutlet private weak var progressSlider: VideoProgressSlider!

    // MARK: - Property

    private weak var player: Player! {
        didSet {
            player.automaticallyWaitsToMinimizeStalling = false
        }
    }

    fileprivate let nextVideoSubject = PublishSubject<Video>()
    private let backgroundDurationTracker = VideoBackgroundDurationTracker()
    var disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? Player {
            self.player = viewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRemoteCommand()

        view.addSubview(loadingView)
        loadingView.frame = controlView.frame
    }

    deinit {
        if let video = reactor?.currentState.video, let currentProgress = reactor?.currentState.progress {
            // 再生完了した場合progressが0になるのに対応する
            let progress: Double = currentProgress == 0 ? 1 : Double(currentProgress)
            Tracker.shared.track(.video_play(video, progress: progress, backgroundDuration: Double(backgroundDurationTracker.duration)))
        }
    }

    // MARK: - Private

    private func setupRemoteCommand() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let center = MPRemoteCommandCenter.shared()

        center.playCommand.addTarget { [weak self] _ -> MPRemoteCommandHandlerStatus in
            self?.reactor?.action.on(.next(.play))
            Tracker.shared.track(.playOnRemotePlayer)
            return .success
        }

        center.togglePlayPauseCommand.addTarget { [weak self] _ -> MPRemoteCommandHandlerStatus in
            self?.reactor?.action.on(.next(.togglePlayPause))
            Tracker.shared.track(.togglePlayOnRemotePlayer)
            return .success
        }

        center.pauseCommand.addTarget { [weak self] _ -> MPRemoteCommandHandlerStatus in
            self?.reactor?.action.on(.next(.pause))
            Tracker.shared.track(.pauseOnRemotePlayer)
            return .success
        }

        center.nextTrackCommand.addTarget { [weak self] _ -> MPRemoteCommandHandlerStatus in
            self?.reactor?.action.on(.next(.next))
            Tracker.shared.track(.nextOnRemotePlayer)
            (self?.reactor?.currentState.progress).map { self?.backgroundDurationTracker.enterForeground(at: $0) } // バックグラウンドで次へボタンを押した時にprogressを記録させる
            return .success
        }

        center.previousTrackCommand.addTarget { [weak self] _ -> MPRemoteCommandHandlerStatus in
            self?.reactor?.action.on(.next(.prev))
            Tracker.shared.track(.prevOnRemotePlayer)
            (self?.reactor?.currentState.progress).map { self?.backgroundDurationTracker.enterForeground(at: $0) } // バックグラウンドで前へボタンを押した時にprogressを記録させる
            return .success
        }
    }
}

// MARK: - StoryboardView

extension VideoPlayer: StoryboardView {
    func bind(reactor: VideoPlayerReactor) {
        UIApplication.rx.didEnterBackground
            .do(onNext: { [weak self] _ in
                let progress = reactor.currentState.progress
                self?.backgroundDurationTracker.enterBackground(at: progress)
            })
            .subscribe()
            .disposed(by: disposeBag)

        UIApplication.rx.willEnterForeground
            .do(onNext: { [weak self] _ in
                let progress = reactor.currentState.progress
                self?.backgroundDurationTracker.enterForeground(at: progress)
            })
            .subscribe()
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(NSNotification.Name.AVAudioSessionInterruption)
            .map { $0.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt }
            .filterNil()
            .map { AVAudioSessionInterruptionType(rawValue: $0) }
            .filterNil()
            .map {
                switch $0 {
                case .began: return .pause
                case .ended: return .play
                }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        nextVideoSubject
            .map { .setNextVideo($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        player.rx.didReady
            .map { [unowned self] in self.player.maximumDuration }
            .filter { !$0.isNaN }
            .map { $0.formatted }
            .bind(to: totalTimeLabel.rx.text)
            .disposed(by: disposeBag)

        player.rx.didReady
            .map { [unowned self] in self.player.maximumDuration }
            .filter { !$0.isNaN }
            .bind(to: MPNowPlayingInfoCenter.default().rx.nowPlayingDuration)
            .disposed(by: disposeBag)

        player.rx.didReady.take(1)
            .map { .ready }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        player.rx.didReady.take(1)
            .map { .play }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        Observable.combineLatest(player.rx.didChangeCurrentTime, progressSlider.rx.dragging)
            .filter { !$0.0.isNaN }
            .map { [unowned self] in $0.1 ? self.player.maximumDuration * Double(self.progressSlider.value) : $0.0 }
            .map { $0.formatted }
            .bind(to: currentTimeLabel.rx.text)
            .disposed(by: disposeBag)

        Observable.combineLatest(player.rx.didChangeCurrentTime, progressSlider.rx.dragging)
            .filter { !$0.1 }
            .map { [unowned self] in CGFloat($0.0 / self.player.maximumDuration) }
            .filter { !$0.isNaN }
            .map { .progress($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        player.rx.didEndPlayback
            .map { [unowned self] in self.reactor?.currentState.sleepTimerState }
            .filterNil()
            .map {
                switch $0 {
                case .untilTheEnd: return .sleepTimerExpired
                default: return .next
                }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        player.rx.willLoopPlayback
            .map { [unowned self] in self.reactor?.currentState.sleepTimerState }
            .filterNil()
            .filter {
                switch $0 {
                case .untilTheEnd: return true
                default: return false
                }
            }
            .map { _ in .sleepTimerExpired }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        player.rx.willLoopPlayback
            .do(onNext: { [unowned self] _ in
                let video = reactor.currentState.video
                Tracker.shared.track(.video_play(video, progress: 1, backgroundDuration: Double(self.backgroundDurationTracker.duration)))
            })
            .subscribe()
            .disposed(by: disposeBag)

        progressSlider.rx.dragging
            .distinctUntilChanged()
            .filterTrue()
            .do(onNext: { _ in
                Tracker.shared.track(.seekTimeOnPlayer)
            })
            .subscribe()
            .disposed(by: disposeBag)

        Observable.combineLatest(player.rx.didChangeCurrentTime, progressSlider.rx.dragging)
            .filter { !$0.1 }
            .map { [unowned self] in Float($0.0 / self.player.maximumDuration) }
            .distinctUntilChanged { fabs($0 - $1) < 0.1 }
            .bind(to: progressSlider.rx.value)
            .disposed(by: disposeBag)

        Observable.combineLatest(progressSlider.rx.dragging, progressSlider.rx.value)
            .filter { !$0.0 }
            .map { [unowned self] in self.player.maximumDuration * Double($0.1) }
            .bind(to: player.rx.seek)
            .disposed(by: disposeBag)

        playButton.rx.tap
            .do(onNext: {
                Tracker.shared.track(.playOnPlayer)
            })
            .map { .togglePlayPause }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        skipNextButton.rx.tap
            .do(onNext: {
                Tracker.shared.track(.nextOnPlayer)
            })
            .map { .next }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        skipPrevButton.rx.tap
            .do(onNext: {
                Tracker.shared.track(.prevOnPlayer)
            })
            .map { .prev }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        forwardButton.rx.tap
            .do(onNext: {
                Tracker.shared.track(.forwardOnPlayer)
            })
            .map { [unowned self] in self.player.currentTime + 30 }
            .map { [unowned self] in min($0, self.player.maximumDuration) }
            .bind(to: player.rx.seek)
            .disposed(by: disposeBag)

        replayButton.rx.tap
            .do(onNext: {
                Tracker.shared.track(.replayOnPlayer)
            })
            .map { [unowned self] in self.player.currentTime - 30 }
            .map { max(0, $0) }
            .bind(to: player.rx.seek)
            .disposed(by: disposeBag)

        player.view.rx.tap
            .map { .control }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        player.view.rx.tap
            .delay(3, scheduler: MainScheduler.instance)
            .withLatestFrom(reactor.state.map { $0.isControling })
            .filterTrue()
            .map { .control }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        controlView.rx.tap
            .map { .control }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        fullscreenButton.rx.tap
            .do(onNext: {
                Tracker.shared.track(.fullscreenOnPlayer)
            })
            .map { .fullscreen }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .flatMap { _ in reactor.state.map { $0.sleepTimerState } }
            .filter { $0.expired }
            .distinctUntilChanged()
            .map { _ in .sleepTimerExpired }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.video.streamingUrl }
            .filterNil()
            .distinctUntilChanged()
            .bind(to: player.rx.url)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isLoading }
            .toggle()
            .bind(to: loadingView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isPlaying }
            .map { $0 ? #imageLiteral(resourceName: "Pause(large)") : #imageLiteral(resourceName: "Play(large)") }
            .bind(to: playButton.rx.image())
            .disposed(by: disposeBag)

        reactor.state.map { $0.isPlaying }
            .filterTrue()
            .observeOn(MainScheduler.instance)
            .bind(to: player.rx.playFromCurrentTime)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isPlaying }
            .filterFalse()
            .observeOn(MainScheduler.instance)
            .bind(to: player.rx.pause)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isRepeating }
            .bind(to: player.rx.playbackLoops)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isControling }
            .toggle()
            .bind(to: controlView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isControling }
            .toggle()
            .bind(to: progressSlider.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isFullscreen }
            .map { $0 ? #imageLiteral(resourceName: "Fullscreen(on)") : #imageLiteral(resourceName: "Fullscreen") }
            .bind(to: fullscreenButton.rx.image())
            .disposed(by: disposeBag)

        reactor.state.map { $0.isFullscreen }
            .map { $0 ? .landscapeRight : .portrait }
            .bind(to: UIDevice.current.rx.orientation)
            .disposed(by: disposeBag)

        reactor.state.map { $0.progress }
            .distinctUntilChanged()
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)

        reactor.state.map { $0.nextVideo }
            .map { $0 == nil }
            .bind(to: skipNextButton.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { $0.prevVideo }
            .map { $0 == nil }
            .bind(to: skipPrevButton.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { $0.readyToPlay }
            .filterNil()
            .distinctUntilChanged()
            .bind(to: rx.play)
            .disposed(by: disposeBag)
    }
}

// MARK: - Reactive

extension Reactive where Base: VideoPlayer {
    var video: Binder<Video> {
        return Binder(self.base) { videoPlayer, video in
            videoPlayer.reactor = VideoPlayerReactor(video: video)
        }
    }

    var nextVideo: Binder<Video> {
        return Binder(self.base) { videoPlayer, video in
            videoPlayer.nextVideoSubject.onNext(video)
        }
    }
}
