//
//  HomeArtistsCollectionViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/14.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit

final class HomeArtistsCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: - Property

    private var artist: Artist! {
        didSet {
            thumbnailImageView.url = artist.thumbnailUrl
            nameLabel.text = artist.name
        }
    }
}

// MARK: - Injectable

extension HomeArtistsCollectionViewCell: Injectable {
    func inject(_ dependency: Artist) {
        self.artist = dependency
    }
}
