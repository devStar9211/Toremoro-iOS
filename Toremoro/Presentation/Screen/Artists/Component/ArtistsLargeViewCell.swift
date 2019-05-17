//
//  ArtistsLargeViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/25.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ArtistsLargeViewCell: UITableViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var subscribersLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - Property

    private var artist: Artist! {
        didSet {
            thumbnailImageView.url = artist.thumbnailUrl
            nameLabel.text = artist.name
            subscribersLabel.text = "Subscribers \(artist.subscriberCount)"
            descriptionLabel.text = artist.description
        }
    }
}

// MARK: - Injectable

extension ArtistsLargeViewCell: Injectable {
    func inject(_ dependency: Artist) {
        self.artist = dependency
    }
}
