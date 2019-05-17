//
//  DesignableRoundedLabel.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/10/20.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import UIKit

@IBDesignable class DesignableRoundedLabel: UILabel {

    // MARK: - IBInspectable

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var padding: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        let newRect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: newRect)
    }

    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.height += padding * 2
        intrinsicContentSize.width += padding * 2
        return intrinsicContentSize
    }
}
