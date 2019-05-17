//
//  DesignableGradientView.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/24.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import Spring

@IBDesignable class DesignableGradientView: UIView {

    // MARK: - IBInspectable

    @IBInspectable var topColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var bottomColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }

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

    @IBInspectable var shadowY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowBlur: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var startPointY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var endPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var endPointY: CGFloat = 0 {
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

    private var gradientLayer: CAGradientLayer!

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer = (self.layer as! CAGradientLayer) // swiftlint:disable:this force_cast
        self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        self.layer.shadowRadius = shadowBlur
        self.layer.shadowOpacity = 1
    }
}
