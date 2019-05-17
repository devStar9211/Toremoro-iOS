//
//  UIButton+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/02/11.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    var setTitleColor: Binder<UIColor> {
        return Binder(self.base) { button, color in
            button.setTitleColor(color, for: .normal)
        }
    }
}
