//
//  FeedbackViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/26.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxKeyboard
import RxOptional
import RxAlertController
import ReactorKit

final class FeedbackViewController: UIViewController {

    // MARK: - Outlet

    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!

    // MARK: - Property

    var disposeBag = DisposeBag()

    private var successedAlertController: Single<Void> {
        return UIAlertController.rx.show(
            in: self,
            title: "送信完了",
            message: "お問い合わせありがとうございます。",
            closeTitle: "OK"
        )
    }

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Tracker.shared.track(.feedback)
    }
}

// MARK: - StoryboardView

extension FeedbackViewController: StoryboardView {
    func bind(reactor: FeedbackViewReactor) {
        rx.viewWillAppear.take(1)
            .map { _ in () }
            .bind(to: textView.rx.becomeFirstResponder)
            .disposed(by: disposeBag)

        view.rx.tap
            .bind(to: textView.rx.resignFirstResponder)
            .disposed(by: disposeBag)

        view.rx.tap
            .bind(to: emailTextField.rx.resignFirstResponder)
            .disposed(by: disposeBag)

        RxKeyboard.instance.visibleHeight
            .drive(onNext: {
                self.scrollView.contentInset.bottom = $0
            })
            .disposed(by: disposeBag)

        textView.rx.text
            .filterNil()
            .distinctUntilChanged()
            .map { .inputBody($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        emailTextField.rx.text
            .filterNil()
            .distinctUntilChanged()
            .map { .inputEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        submitButton.rx.tap
            .do(onNext: {
                Tracker.shared.track(.submitFeedback)
            })
            .map { .submit }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isLoading }
            .bind(to: rx.loading)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isSuccessed }
            .filterTrue()
            .do(onNext: {
                Tracker.shared.track(.completeFeedback)
            })
            .flatMap { [unowned self] in self.successedAlertController }
            .bind(to: self.navigationController!.rx.pop)
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

extension FeedbackViewController: StoryboardInstantiatable {
    func inject(_ dependency: ()) {
        self.reactor = FeedbackViewReactor()
    }
}
