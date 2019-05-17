//
//  UIImageView+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/10/18.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIImageView {
    var url: Binder<URL?> {
        return Binder(self.base) { imageView, url in
            imageView.url = url
        }
    }
}
