//
//  VideoViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/10/20.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class VideoViewCell: UITableViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var playCountLabel: UILabel!

    // MARK: - Property

    private var video: Video! {
        didSet {
            thumbnailImageView.url = video.thumbnailUrl
            durationLabel.text = video.duration.formatted
            titleLabel.text = video.title
            playCountLabel.text = "\(video.views) 回再生"
        }
    }
}

// MARK: - Injectable

extension VideoViewCell: Injectable {
    func inject(_ dependency: Video) {
        self.video = dependency
    }
}
