//
//  UIDevice+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/08/03.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIDevice {
    var orientation: Binder<UIInterfaceOrientation> {
        return Binder(self.base) { device, orientation in
            device.setValue(orientation.rawValue, forKey: "orientation")
        }
    }
}
