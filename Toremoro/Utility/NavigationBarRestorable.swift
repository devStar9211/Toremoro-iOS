//
//  NavigationBarRestorable.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/28.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit

private enum Key {
    static var isPreviousNavigationBarHidden = "NavigationBarHandleable.UINavigationController"
}

protocol NavigationBarHandleable {
    func showNavigationBar(animated: Bool)
    func hideNavigationBar(animated: Bool)
    func restoreNavigationBar(animated: Bool)
}

extension UINavigationController: NavigationBarHandleable {

    var isPreviousNavigationBarHidden: Bool? {
        get {
            return getProperty(key: &Key.isPreviousNavigationBarHidden)
        }
        set {
            setProperty(key: &Key.isPreviousNavigationBarHidden, newValue: newValue)
        }
    }

    func showNavigationBar(animated: Bool) {
        isPreviousNavigationBarHidden = isNavigationBarHidden
        setNavigationBarHidden(false, animated: animated)
    }

    func hideNavigationBar(animated: Bool) {
        isPreviousNavigationBarHidden = isNavigationBarHidden
        setNavigationBarHidden(true, animated: animated)
        interactivePopGestureRecognizer?.delegate = nil
    }

    func restoreNavigationBar(animated: Bool) {
        guard let isPreviousNavigationBarHidden = isPreviousNavigationBarHidden else {
            return
        }
        setNavigationBarHidden(isPreviousNavigationBarHidden, animated: animated)
    }
}
