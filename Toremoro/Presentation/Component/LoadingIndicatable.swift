//
//  LoadingIndicatable.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/08/05.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private enum Key {
    static var indicatorView = "LoadingIndicatable.indicatorView"
}

protocol LoadingIndicatable: class {
    func startLoading()
    func stopLoading()
}

extension UIViewController: LoadingIndicatable, ExtensionProperty {
    var indicatorView: UIActivityIndicatorView? {
        get {
            return getProperty(key: &Key.indicatorView)
        }
        set {
            setProperty(key: &Key.indicatorView, newValue: newValue)
        }
    }

    func startLoading() {
        if indicatorView == nil {
            configure()
        }

        view.isUserInteractionEnabled = false
        indicatorView?.startAnimating()
    }

    func stopLoading() {
        view.isUserInteractionEnabled = true
        indicatorView?.stopAnimating()
    }

    private func configure() {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicatorView.color = .gray
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = true
        view.addSubview(indicatorView)
        indicatorView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        indicatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        indicatorView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.indicatorView = indicatorView
    }
}

extension Reactive where Base: UIViewController {
    var loading: Binder<Bool> {
        return Binder(self.base) { viewController, loading in
            loading ? viewController.startLoading() : viewController.stopLoading()
        }
    }
}
