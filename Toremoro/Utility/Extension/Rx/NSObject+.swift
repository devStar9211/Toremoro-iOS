//
//  NSObject+.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/06.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import Foundation

extension NSObject {

    static func swizzling(original: Selector, swizzled: Selector) {
        let originalMethod = class_getInstanceMethod(self, original)
        let swizzledMethod = class_getInstanceMethod(self, swizzled)

        let didAddMethod = class_addMethod(self, original, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))

        if didAddMethod {
            class_replaceMethod(self, swizzled, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }

    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}
