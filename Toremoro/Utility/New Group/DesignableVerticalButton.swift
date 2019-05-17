//
//  DesignableVerticalButton.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/02/10.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import UIKit

@IBDesignable final class DesignableVerticalButton: UIButton {

    // MARK: - Property

    @IBInspectable var verticalSpacing: CGFloat = 8

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    // MARK: - Private

    private func setup() {
        let labelString = NSString(string: currentTitle!)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: titleLabel!.font])
        let imageSize = imageView!.frame.size

        titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(imageSize.height + verticalSpacing),
            right: 0
        )

        imageEdgeInsets = UIEdgeInsets(
            top: -(titleSize.height + verticalSpacing),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )

        contentEdgeInsets = UIEdgeInsets(
            top: titleSize.height,
            left: 0,
            bottom: titleSize.height,
            right: 0
        )
    }
}
