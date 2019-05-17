//
//  ExtensionProperty.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/08/05.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import Foundation

protocol ExtensionProperty {
    func getProperty<T>(key: UnsafeRawPointer) -> T?
    func setProperty<T>(key: UnsafeRawPointer, newValue: T, policy: objc_AssociationPolicy)
}

extension ExtensionProperty {
    func getProperty<T>(key: UnsafeRawPointer) -> T? {
        return objc_getAssociatedObject(self, key) as? T
    }

    func setProperty<T>(key: UnsafeRawPointer, newValue: T, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN) {
        objc_setAssociatedObject(self, key, newValue, policy)
    }
}
