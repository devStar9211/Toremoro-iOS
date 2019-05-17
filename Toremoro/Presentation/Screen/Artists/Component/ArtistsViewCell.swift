//
//  ArtistsViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/25.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ArtistsViewCell: UITableViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var subscribersLabel: UILabel!

    // MARK: - Property

    private var artist: Artist! {
        didSet {
            thumbnailImageView.url = artist.thumbnailUrl
            nameLabel.text = artist.name
            descriptionLabel.text = artist.description
            subscribersLabel.text = "Subscribers \(artist.subscriberCount)"
        }
    }
}

// MARK: - Injectable

extension ArtistsViewCell: Injectable {
    func inject(_ dependency: Artist) {
        self.artist = dependency
    }
}
