//
//  DesignablePlaceholderTextView.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/08/05.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

@IBDesignable final class DesignablePlaceholderTextView: KMPlaceholderTextView {

    // MARK: - Proeprty

    @IBInspectable var padding: CGFloat = 0 {
        didSet {
            layoutSubviews()
        }
    }

    private var paddingInset: UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        textContainerInset = paddingInset
        textContainer.lineFragmentPadding = 0
    }
}
