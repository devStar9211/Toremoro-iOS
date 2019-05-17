//
//  SearchResultArtistsCollectionViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/08.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import UIKit

final class SearchResultArtistsCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Property

    private var artist: Artist! {
        didSet {
            thumbnailImageView.url = artist.thumbnailUrl
            titleLabel.text = artist.name
        }
    }
}

// MARK: - Injectable

extension SearchResultArtistsCollectionViewCell: Injectable {
    func inject(_ dependency: Artist) {
        self.artist = dependency
    }
}
