//
//  UIScrollView+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/10/16.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

private extension UIScrollView {
    var isOverflowVertical: Bool {
        return self.contentSize.height > self.frame.size.height && self.frame.size.height > 0
    }

    func isReachedBottom(withTolerance tolerance: CGFloat = 0) -> Bool {
        guard self.isOverflowVertical else { return false }
        let contentOffsetBottom = self.contentOffset.y + self.frame.size.height
        return contentOffsetBottom >= self.contentSize.height - tolerance
    }
}

extension Reactive where Base: UIScrollView {
    var setContentOffset: Binder<CGPoint> {
        return Binder(self.base) { scrollView, offset in
            scrollView.setContentOffset(offset, animated: true)
        }
    }

    var isReachedBottom: ControlEvent<Void> {
        let source = self.contentOffset
            .filter { [weak base = self.base] _ in
                guard let base = base else { return false }
                return base.isReachedBottom(withTolerance: base.frame.size.height / 2)
            }
            .map { _ in }
        return ControlEvent(events: source)
    }
}
