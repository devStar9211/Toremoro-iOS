//
//  RefreshControl.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/08/18.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit

final class RefreshControl: UIRefreshControl {

    private static let swizzle: Void = {
        let originalSelector = NSSelectorFromString("_scrollViewHeight")
        let swizzledSelector = NSSelectorFromString("ss_scrollViewHeight")
        RefreshControl.swizzling(original: originalSelector, swizzled: swizzledSelector)
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.zPosition = -999
    }

    override convenience init() {
        self.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func didMoveToSuperview() {
        RefreshControl.swizzle
        super.didMoveToSuperview()
        if let scrollView = self.superview as? UIScrollView {
            self.tintColor = self.tintColor ?? UIRefreshControl.appearance().tintColor
            scrollView.contentOffset.y = -self.frame.height
        }
    }

    // MARK: - Private

    @objc private func ss_scrollViewHeight() -> CGFloat {
        // this makes refresh control distance shorter
        return 0
    }
}
