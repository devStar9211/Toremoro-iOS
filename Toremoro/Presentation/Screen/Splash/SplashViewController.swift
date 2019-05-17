//
//  SplashViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/06.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxViewController
import RxOptional
import RxAlertController
import SwiftyUserDefaults

final class SplashViewController: UIViewController {

    // MARK: - Property

    var disposeBag = DisposeBag()

    // MARK: - Private

    private func showForceUpdateAlert() -> Single<Void> {
        return UIAlertController.rx.show(in: self, title: "新しいバージョンがあります", message: "ストアからアップデートをしてください", closeTitle: "OK")
    }

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.launchCount] += 1
        Tracker.shared.track(.splash)
    }
}

// MARK: - StoryboardView

extension SplashViewController: StoryboardView {
    func bind(reactor: SplashViewReactor) {
        rx.viewWillAppear.take(1)
            .map { _ in Reactor.Action.prepare }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isRequiredUpdate }
            .filterNil()
            .filterTrue()
            .flatMap { [unowned self] _ in self.showForceUpdateAlert() }
            .map { reactor.currentState.appStoreUrl }
            .filterNil()
            .bind(to: UIApplication.rx.open)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isRequiredUpdate }
            .filterNil()
            .filterFalse()
            .flatMap { reactor.state.map { $0.isAuthenticated }.filterNil() }
            .filterTrue()
            .map { Defaults[.isStarted] ? .main : .tutorial }
            .bind { SceneRouter.shared.route(to: $0, animated: true) }
            .disposed(by: disposeBag)

        reactor.state.map { $0.error }
            .filterNil()
            .flatMap { [unowned self] in self.rx.handle(error: $0) }
            .map { .dismissErrorAlert }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - StoryboardInstantiatable

extension SplashViewController: StoryboardInstantiatable {
    func inject(_ dependency: ()) {
        self.reactor = SplashViewReactor()
    }
}
