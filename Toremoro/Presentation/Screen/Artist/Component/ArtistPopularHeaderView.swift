//
//  ArtistPopularHeaderView.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/10/17.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import UIKit

final class ArtistPopularHeaderView: UIView {

    // MARK: - Action

    @IBAction private func didTapVideoButton(_ sender: UIButton) {
        let viewController = VideosViewController(with: .populars(artist))
        navigator.push(viewController)
    }

    // MARK: - Property

    var artist: Artist!
}
