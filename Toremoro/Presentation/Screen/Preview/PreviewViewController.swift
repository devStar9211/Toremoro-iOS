//
//  PreviewViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/02/24.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

final class PreviewViewController: UIViewController, PopupPresentable {

    enum Context {
        case video(Video.Id)
    }

    // MARK: - Property

    var disposeBag = DisposeBag()
}

// MARK: - StroyboardView

extension PreviewViewController: StoryboardView {
    func bind(reactor: PreviewViewReactor) {
        rx.viewWillAppear.take(1)
            .map { _ in .prepare }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.destination }
            .filterNil()
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .video(let video):
                    self?.play(video)
                    self?.dismiss(animated: false)
                }
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.error }
            .filterNil()
            .flatMap { [unowned self] in self.rx.handle(error: $0) }
            .map { .dismiss }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.dismissed }
            .filterTrue()
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - StoryboardInstantiatable

extension PreviewViewController: StoryboardInstantiatable {
    func inject(_ dependency: Context) {
        self.reactor = PreviewViewReactor(context: dependency)
    }
}
