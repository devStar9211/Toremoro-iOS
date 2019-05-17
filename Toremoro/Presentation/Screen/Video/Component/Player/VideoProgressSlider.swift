//
//  VideoProgressSlider.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/17.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import UIKit

final class VideoProgressSlider: UISlider {

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Lifecycle

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return true
    }

    // MARK: - Private

    private func setup() {
        setThumbImage(#imageLiteral(resourceName: "ProgressThumb"), for: .normal)
        setThumbImage(#imageLiteral(resourceName: "ProgressThumb(large)"), for: .highlighted)
    }
}
