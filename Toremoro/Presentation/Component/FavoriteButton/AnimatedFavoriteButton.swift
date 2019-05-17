//
//  FavoriteButton.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/12/21.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

final class AnimatedFavoriteButton: UIView {

    // MARK: - Property

    private let animatedSwitch: LOTAnimatedSwitch = {
        let `switch` = LOTAnimatedSwitch(named: "favorite")
        `switch`.translatesAutoresizingMaskIntoConstraints = false
        `switch`.setProgressRangeForOnState(fromProgress: 0, toProgress: 1)
        return `switch`
    }()

    private let maskImageView: UIImageView = {
        let image = #imageLiteral(resourceName: "FavoriteMask")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()

    fileprivate var isFavorite: Bool? {
        didSet {
            switch (oldValue, isFavorite) {
            case (nil, true):
                animatedSwitch.setOn(true, animated: false)
            case (_, true):
                animatedSwitch.setOn(true, animated: true)
            case (_, false):
                animatedSwitch.setOn(false, animated: false)
            default:
                break
            }
        }
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(animatedSwitch)
        addSubview(maskImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(animatedSwitch)
        addSubview(maskImageView)
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        animatedSwitch.topAnchor.constraint(equalTo: topAnchor).isActive = true
        animatedSwitch.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        animatedSwitch.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        animatedSwitch.leftAnchor.constraint(equalTo: leftAnchor).isActive = true

        maskImageView.topAnchor.constraint(equalTo: topAnchor, constant: -1).isActive = true
        maskImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1).isActive = true
        maskImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 1).isActive = true
        maskImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: -1).isActive = true
    }
}

// MARK: - Rx

extension Reactive where Base: AnimatedFavoriteButton {
    var isFavorite: Binder<Bool> {
        return Binder(self.base) { favoriteButton, isFavorite in
            favoriteButton.isFavorite = isFavorite
        }
    }
}
