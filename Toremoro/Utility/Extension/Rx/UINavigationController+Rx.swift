//
//  UINavigationController+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/10/02.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UINavigationController {
    var pop: Binder<Void> {
        return Binder(self.base) { navigationController, _ in
            navigationController.popViewController(animated: true)
        }
    }
}
