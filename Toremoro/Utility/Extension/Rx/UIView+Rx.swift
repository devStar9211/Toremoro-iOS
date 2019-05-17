//
//  UIView+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/08/02.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxSwift
import RxCocoa
import RxGesture

extension Reactive where Base == UIView {
    var tap: Observable<Void> {
        return base.rx.tapGesture().when(.recognized).map { _ in }
    }
}
