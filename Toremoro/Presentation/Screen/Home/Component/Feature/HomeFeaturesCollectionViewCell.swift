//
//  HomeFeaturesCollectionViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/09/24.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit

final class HomeFeaturesCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var thumbnailImageView: UIImageView!

    // MARK: - Property

    private var feature: Feature! {
        didSet {
            thumbnailImageView.url = feature.thumbnailUrl
        }
    }
}

// MARK: - Injectable

extension HomeFeaturesCollectionViewCell: Injectable {
    func inject(_ dependency: Feature) {
        self.feature = dependency
    }
}
