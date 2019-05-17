//
//  UITextView+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/08/05.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITextView {
    var becomeFirstResponder: Binder<Void> {
        return Binder(self.base) { textView, _ in
            textView.becomeFirstResponder()
        }
    }

    var resignFirstResponder: Binder<Void> {
        return Binder(self.base) { textView, _ in
            textView.resignFirstResponder()
        }
    }
}
