//
//  ObservableType+.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/31.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxSwift

extension ObservableType where E == Bool {
    func filterTrue() -> Observable<Void> {
        return flatMap { element -> Observable<Void> in
            if element {
                return .just(())
            } else {
                return .empty()
            }
        }
    }

    func filterFalse() -> Observable<Void> {
        return flatMap { element -> Observable<Void> in
            if element {
                return .empty()
            } else {
                return .just(())
            }
        }
    }

    func toggle() -> Observable<Bool> {
        return map { !$0 }
    }
}
