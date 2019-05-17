//
//  HomeGenresCollectionViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/14.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit

final class HomeGenresCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Property

    private var genre: Genre! {
        didSet {
            thumbnailImageView.url = genre.thumbnailUrl
            titleLabel.text = genre.title
        }
    }
}

// MARK: - Injectable

extension HomeGenresCollectionViewCell: Injectable {
    func inject(_ dependency: Genre) {
        self.genre = dependency
    }
}
