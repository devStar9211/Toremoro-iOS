//
//  UIActivityViewController+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/02/17.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import RxSwift
import UIKit

enum RxActivityControllerError: Error {
    case presentingViewControllerDeallocated
    case unknown
}

extension Reactive where Base: UIActivityViewController {
    func show(in vc: UIViewController) -> Single<UIActivityType?> {
        return Single<UIActivityType?>.create(subscribe: { [weak vc] observer in
            guard let vc = vc else {
                observer(.error(RxActivityControllerError.presentingViewControllerDeallocated))
                return Disposables.create()
            }

            let activityViewController = self.base
            activityViewController.completionWithItemsHandler = { activity, _, _, error in
                if let error = error {
                    observer(.error(error))
                    return
                }

                observer(.success(activity))
            }

            DispatchQueue.main.async(execute: {
                vc.present(self.base, animated: true, completion: nil)
                self.base.view.layoutIfNeeded()
            })

            return Disposables.create(with: {
                if activityViewController.presentingViewController != nil {
                    activityViewController.dismiss(animated: true, completion: nil)
                }
            })
        })
    }

    static func show(in vc: UIViewController, activity items: [Any], application activities: [UIActivity]?) -> Single<UIActivityType?> {
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: activities)
        return activityViewController.rx.show(in: vc)
    }

    static func show(in vc: UIViewController, title: String? = nil, message: String) -> Single<UIActivityType?> {
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        title.map { activityViewController.setValue($0, forKey: "Subject") }
        return activityViewController.rx.show(in: vc)
    }

    static func show(title: String? = nil, message: String) -> Single<UIActivityType?> {
        let viewController = UIViewController.topMost!
        return show(in: viewController, title: title, message: message)
    }
}
