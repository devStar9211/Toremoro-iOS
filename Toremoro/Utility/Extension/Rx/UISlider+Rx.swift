//
//  UISlider+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/08/02.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UISlider {
    var dragging: Observable<Bool> {
        return Observable
            .merge(
                .just(false),
                base.rx.controlEvent(.valueChanged).map { true },
                base.rx.controlEvent(.touchUpInside).map { false }
            )
            .distinctUntilChanged()
    }
}
