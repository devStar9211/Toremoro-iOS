//
//  ProgressView.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/28.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ProgressView: UIControl {

    // MARK: - Property

    var progress: CGFloat = 0 {
        didSet {
            widthConstraint.constant = frame.width * progress
        }
    }

    private let barView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9221251607, green: 0.167568326, blue: 0.5362950563, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var widthConstraint: NSLayoutConstraint!

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - private

    private func commonInit() {
        backgroundColor = #colorLiteral(red: 0.0015818713, green: 0.3729451597, blue: 0.6508985758, alpha: 1)
        addSubview(barView)
        barView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        barView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        barView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        widthConstraint = barView.widthAnchor.constraint(equalToConstant: 0)
        widthConstraint.isActive = true
    }
}

// MARK: - Rx

extension Reactive where Base: ProgressView {
    var progress: Binder<CGFloat> {
        return Binder(self.base) { progressView, progress in
            progressView.progress = progress
        }
    }
}
