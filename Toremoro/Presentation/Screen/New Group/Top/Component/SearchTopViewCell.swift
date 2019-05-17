//
//  SearchTopViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/08.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import UIKit

final class SearchTopViewCell: UICollectionViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var thumbnailImageView: UIImageView!

    // MARK: - Property

    private var genre: Genre! {
        didSet {
            thumbnailImageView.url = genre.thumbnailUrl
        }
    }
}

// MARK: - Injectable

extension SearchTopViewCell: Injectable {
    func inject(_ dependency: Genre) {
        self.genre = dependency
    }
}
