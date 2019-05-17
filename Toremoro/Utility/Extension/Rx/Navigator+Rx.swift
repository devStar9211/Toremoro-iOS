//
//  Navigator+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/17.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import URLNavigator
import RxSwift

extension Navigator: ReactiveCompatible {}

extension Reactive where Base: Navigator {
    var push: AnyObserver<UIViewController> {
        return AnyObserver<UIViewController> { observer in
            guard let viewController = observer.element else {
                return
            }
            self.base.push(viewController)
        }
    }

    var present: AnyObserver<UIViewController> {
        return AnyObserver<UIViewController> { observer in
            guard let viewController = observer.element else {
                return
            }
            self.base.present(viewController)
        }
    }

    var pop: AnyObserver<Void> {
        return AnyObserver<Void> { _ in
            self.base.popViewController(animated: true)
        }
    }
}

protocol Navigatable {
    var navigator: Navigator { get }
}

extension Navigatable {
    var navigator: Navigator {
        return Navigator()
    }
}

extension UIViewController: Navigatable {}
extension UIView: Navigatable {}
