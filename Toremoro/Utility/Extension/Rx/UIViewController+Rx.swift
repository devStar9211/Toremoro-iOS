//
//  UIViewController+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/02/11.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import RxSwift
import RxCocoa
import PanModal

extension Reactive where Base: UIViewController {
    var dismiss: Binder<Void> {
        return Binder(self.base) { viewController, _ in
            viewController.dismiss(animated: true)
        }
    }

    var presentPanModal: Binder<UIViewController & PanModalPresentable> {
        return Binder(self.base) { viewController, modal in
            viewController.presentPanModal(modal)
        }
    }
}
