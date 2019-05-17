//
//  WebViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/26.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit
import WebKit

final class WebViewController: UIViewController {

    // MARK: - Property

    var disposeBag = DisposeBag()
    private let webView = WKWebView(frame: .zero)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (reactor?.currentState.url).map { Tracker.shared.track(.web($0)) }
    }
}

// MARK: - StoryboardView

extension WebViewController: StoryboardView {
    func bind(reactor: WebViewReactor) {
        reactor.state.map { $0.url }
            .bind(to: webView.rx.load)
            .disposed(by: disposeBag)
    }
}

// MARK: - StoryboardInstantiatable

extension WebViewController: StoryboardInstantiatable {
    func inject(_ dependency: (title: String, url: URL)) {
        self.title = dependency.title
        self.reactor = WebViewReactor(url: dependency.url)
    }
}
