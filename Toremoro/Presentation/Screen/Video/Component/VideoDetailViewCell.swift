//
//  VideoDetailViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/10/19.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import ReactorKit
import ActiveLabel
import SafariServices

final class VideoDetailViewCell: UITableViewCell, PopupPresentable {

    // MARK: - Outlet

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var playCountLabel: UILabel!
    @IBOutlet private weak var artistImageView: UIImageView!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var artistStackView: UIStackView!
    @IBOutlet private weak var timerButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var repeatButton: UIButton!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var readMoreButton: UIButton!

    @IBOutlet private weak var descriptionLabel: ActiveLabel! {
        didSet {
            descriptionLabel.enabledTypes = [.url]
            descriptionLabel.URLColor = #colorLiteral(red: 0, green: 0.4310425818, blue: 0.8352131248, alpha: 1)
            descriptionLabel.handleURLTap { [weak self] in
                let viewController = SFSafariViewController(url: $0)
                self?.navigator.present(viewController)
            }
        }
    }

    // MARK: - Property

    private var sleepTimerHandler: (() -> Void)?
    private var refreshHandler: (() -> Void)?
    var disposeBag = DisposeBag()
}

// MARK: - View

extension VideoDetailViewCell: ReactorKit.View {
    func bind(reactor: VideoDetailViewCellReactor) {
        artistStackView.rx.tapGesture()
            .when(.recognized)
            .do(onNext: { [weak self] _ in
                self?.close()
                Tracker.shared.track(.showArtistFromPlayer)
            })
            .map { _ in ArtistViewController(with: reactor.currentState.artist) }
            .bind(to: navigator.rx.push)
            .disposed(by: disposeBag)

        timerButton.rx.tap
            .map { self.reactor?.currentState.sleepTimerState }
            .filterNil()
            .filter {
                if case .off = $0 {
                    return true
                } else {
                    return false
                }
            }
            .subscribe(onNext: { [weak self] _ in
                self?.sleepTimerHandler?()
            })
            .disposed(by: disposeBag)

        timerButton.rx.tap
            .map { self.reactor?.currentState.sleepTimerState }
            .filterNil()
            .filter {
                if case .off = $0 {
                    return false
                } else {
                    return true
                }
            }
            .do(onNext: { _ in
                Tracker.shared.track(.sleepTimerOff)
            })
            .map { _ in .offSleepTimer }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        shareButton.rx.tap
            .do(onNext: { _ in
                Tracker.shared.track(.share)
            })
            .map { _ in .share }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        repeatButton.rx.tap
            .do(onNext: { [unowned self] in
                (self.reactor?.currentState.isRepeating).map {
                    if $0 {
                        Tracker.shared.track(.repeatOff)
                    } else {
                        Tracker.shared.track(.repeatOn)
                    }
                }
            })
            .map { .repeat }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        favoriteButton.rx.tap
            .do(onNext: { [unowned self] in
                (self.reactor?.currentState.isFavorited).map {
                    if $0 {
                        Tracker.shared.track(.unfavoriteVideo)
                    } else {
                        Tracker.shared.track(.favoriteVideo)
                    }
                }
            })
            .map { .favorite }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        readMoreButton.rx.tap
            .do(onNext: {
                Tracker.shared.track(.readMoreVideo)
            })
            .map { .readMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.video.title }
            .distinctUntilChanged()
            .bind(to: self.titleLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.video.views }
            .distinctUntilChanged()
            .map { "再生回数 \($0)回" }
            .bind(to: self.playCountLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.artist.thumbnailUrl }
            .distinctUntilChanged()
            .filterNil()
            .bind(to: self.artistImageView.rx.url)
            .disposed(by: disposeBag)

        reactor.state.map { $0.artist.name }
            .distinctUntilChanged()
            .bind(to: self.artistNameLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isFavorited }
            .map { $0 ? #imageLiteral(resourceName: "Favorite(On)") : #imageLiteral(resourceName: "Favorite(Off)") }
            .bind(to: favoriteButton.rx.image())
            .disposed(by: disposeBag)

        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .flatMap { _ in reactor.state.map { $0.sleepTimerState } }
            .map {
                guard !$0.expired else {
                    return #imageLiteral(resourceName: "Timer(Off)")
                }
                switch $0 {
                case .time: return #imageLiteral(resourceName: "Timer(On)")
                case .untilTheEnd: return #imageLiteral(resourceName: "Timer(On)")
                case .off: return #imageLiteral(resourceName: "Timer(Off)")
                }
            }
            .distinctUntilChanged()
            .bind(to: timerButton.rx.image())
            .disposed(by: disposeBag)

        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .flatMap { _ in reactor.state.map { $0.sleepTimerState } }
            .map {
                guard !$0.expired else {
                    return "スリープタイマー"
                }
                switch $0 {
                case .time: return $0.remainingTime?.formatted ?? "--:--"
                case .untilTheEnd: return "動画終了時"
                case .off: return "スリープタイマー"
                }
            }
            .distinctUntilChanged()
            .bind(to: timerButton.rx.title())
            .disposed(by: disposeBag)

        reactor.state.map { $0.isRepeating }
            .distinctUntilChanged()
            .map { $0 ? #imageLiteral(resourceName: "Repeat(On)") : #imageLiteral(resourceName: "Repeat(Off)") }
            .bind(to: repeatButton.rx.image())
            .disposed(by: disposeBag)

        Observable
            .combineLatest(
                reactor.state.map { $0.shareText }.distinctUntilChanged().filterNil(),
                reactor.state.map { $0.video }.distinctUntilChanged()
            )
            .flatMap { message, video in
                UIActivityViewController.rx.show(message: message).map { ($0, video) }
            }
            .do(onNext: { type, video in
                guard let type = type else { return }
                let activityType = ActivityType(type)
                Tracker.shared.track(.share(activityType, video))
            })
            .map { _ in .dismissShareActivity }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.video.description }
            .distinctUntilChanged()
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isReadMore }
            .distinctUntilChanged()
            .map { $0 ? "隠す" : "続きを見る" }
            .bind(to: readMoreButton.rx.title())
            .disposed(by: disposeBag)

        reactor.state.map { $0.isReadMore }
            .distinctUntilChanged()
            .map { $0 ? 0 : 3 }
            .subscribe(onNext: { [weak self] in
                self?.descriptionLabel.numberOfLines = $0
                self?.refreshHandler?()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Injectable

extension VideoDetailViewCell: Injectable {
    func inject(_ dependency: (reactor: VideoDetailViewCellReactor, sleepTimerHandler: (() -> Void)?, refreshHandler: (() -> Void)?)) {
        self.reactor = dependency.reactor
        self.sleepTimerHandler = dependency.sleepTimerHandler
        self.refreshHandler = dependency.refreshHandler
    }
}
