//
//  Single+.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/08/21.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxSwift
import RxOptional

extension Single where Element: OptionalType {
    func filterNil() -> Single<Element.Wrapped> {
        return asObservable().filterNil().asSingle()
    }
}
