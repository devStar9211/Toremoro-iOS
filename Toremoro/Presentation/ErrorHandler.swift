//
//  ErrorHandler.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/10.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxAlertController

protocol ErrorHandleable: class {
    func handle(error: Error) -> Single<Void>
}

extension ErrorHandleable where Self: UIViewController {
    func handle(error: Error) -> Single<Void> {
        let presentationError = PresentationError(error)
        let show = UIAlertController.rx.show(
            in: self,
            title: presentationError.title,
            message: presentationError.message,
            closeTitle: "OK"
        )
        return show
    }
}

extension UIViewController: ErrorHandleable {}

extension Reactive where Base: UIViewController {
    func handle(error: Error) -> Single<Void> {
        return base.handle(error: error)
    }
}
