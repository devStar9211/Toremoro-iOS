//
//  TutorialViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/08/30.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SwiftyUserDefaults

final class TutorialViewController: UIViewController {

    // MARK: - Outlet

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var firstView: UIView!
    @IBOutlet private weak var secondView: UIView!
    @IBOutlet private weak var thirdView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var stackViewWidth: NSLayoutConstraint!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var skipButton: UIButton!
    @IBOutlet private weak var startButton: UIButton!

    // MARK: - Property

    var disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        stackViewWidth.constant = view.frame.width * 3
        stackView.addArrangedSubview(firstView)
        stackView.addArrangedSubview(secondView)
        stackView.addArrangedSubview(thirdView)
    }
}

// MARK: - StoryboardView

extension TutorialViewController: StoryboardView {
    func bind(reactor: TutorialViewReactor) {
        scrollView.rx.contentOffset
            .map { Int($0.x / self.view.frame.width) }
            .distinctUntilChanged()
            .do(onNext: {
                Tracker.shared.track(.tutorial(index: $0))
            })
            .map { .move($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        skipButton.rx.tap
            .do(onNext: {
                Tracker.shared.track(.tutorialSkip)
            })
            .map { .skip }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        startButton.rx.tap
            .do(onNext: {
                Tracker.shared.track(.tutorialStart)
            })
            .map { .start }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.page }
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)

        reactor.state.map { $0.page }
            .distinctUntilChanged()
            .map { $0 == self.stackView.arrangedSubviews.count - 1 }
            .bind(to: skipButton.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isSkipped }
            .distinctUntilChanged()
            .filterTrue()
            .map { self.view.frame.width * 2.0 }
            .map { CGPoint(x: $0, y: 0) }
            .bind(to: scrollView.rx.setContentOffset)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isStarting }
            .filter { $0 }
            .do(onNext: { _ in Defaults[.isStarted] = true })
            .bind { _ in SceneRouter.shared.route(to: .main, animated: true) }
            .disposed(by: disposeBag)
    }
}

// MARK: - StoryboardInstantiatable

extension TutorialViewController: StoryboardInstantiatable {
    func inject(_ dependency: ()) {
        self.reactor = TutorialViewReactor()
    }
}
