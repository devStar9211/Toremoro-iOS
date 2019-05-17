//
//  UITextField+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/25.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    var becomeFirstResponder: Binder<Void> {
        return Binder(self.base) { textField, _ in
            textField.becomeFirstResponder()
        }
    }

    var resignFirstResponder: Binder<Void> {
        return Binder(self.base) { textField, _ in
            textField.resignFirstResponder()
        }
    }
}
