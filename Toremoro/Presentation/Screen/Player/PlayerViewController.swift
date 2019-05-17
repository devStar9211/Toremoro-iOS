//
//  PlayerViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/18.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import LNPopupController

final class PlayerViewController: LNPopupCustomBarViewController, PopupPresentable {

    // MARK: - Outlet

    @IBOutlet private weak var progressView: ProgressView!
    @IBOutlet private weak var openButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var playButton: UIButton!

    // MARK: - Property

    var disposeBag = DisposeBag()
}

// MARK: - StoryboardView

extension PlayerViewController: StoryboardView {
    func bind(reactor: PlayerViewReactor) {
        openButton.rx.tap
            .do(onNext: {
                Tracker.shared.track(.openPlayer)
            })
            .bind(to: rx.open)
            .disposed(by: disposeBag)

        playButton.rx.tap
            .do(onNext: {
                Tracker.shared.track(.playOnMiniPlayer)
            })
            .map { .play }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.video?.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isPlaying }
            .map { $0 ? #imageLiteral(resourceName: "Pause(large)") : #imageLiteral(resourceName: "Play(large)") }
            .bind(to: playButton.rx.image())
            .disposed(by: disposeBag)

        reactor.state.map { $0.progress }
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
    }
}

// MARK: - StoryboardInstantiatable

extension PlayerViewController: StoryboardInstantiatable {
    func inject(_ dependency: Video) {
        self.reactor = PlayerViewReactor(video: dependency)
    }
}
