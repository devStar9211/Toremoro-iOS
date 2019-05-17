//
//  HomeArtistsCollectionViewMoreCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/10/16.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import UIKit

final class HomeArtistsCollectionViewMoreCell: UICollectionViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var thumbnailImageView: DesignableShadowImageView!

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        thumbnailImageView.image = #imageLiteral(resourceName: "Gradation")
    }
}
