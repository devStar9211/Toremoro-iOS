//
//  WKWebView+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/26.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import WebKit
import RxSwift
import RxCocoa

extension Reactive where Base: WKWebView {
    var load: Binder<URL> {
        return Binder(self.base) { webView, url in
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
