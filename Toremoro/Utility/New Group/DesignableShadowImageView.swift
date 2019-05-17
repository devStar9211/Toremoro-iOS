//
//  DesignableShadowImageView.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/09/26.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import Spring

@IBDesignable class DesignableShadowImageView: UIImageView {

    // MARK: - IBInspectable

    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowY: CGFloat = 6 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 4 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Property

    override var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    override var backgroundColor: UIColor? {
        get {
            return imageView.backgroundColor
        }
        set {
            super.backgroundColor = nil
            imageView.backgroundColor = newValue
        }
    }

    private var shadowView = UIView()
    private var imageView = UIImageView()

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = false

        shadowView.layer.cornerRadius = cornerRadius
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.backgroundColor = shadowColor
        shadowView.frame = bounds
        addSubview(shadowView)

        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
    }
}
