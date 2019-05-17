//
//  ArtistNewHeaderView.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/10/17.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import UIKit

final class ArtistNewHeaderView: UIView {

    // MARK: - Action

    @IBAction private func didTapVideoButton(_ sender: UIButton) {
        let viewController = VideosViewController(with: .artist(artist))
        navigator.push(viewController)
    }

    // MARK: - Property

    var artist: Artist!
}
