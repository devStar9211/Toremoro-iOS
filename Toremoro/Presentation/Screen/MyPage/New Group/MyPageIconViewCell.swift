//
//  MyPageIconViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/10/17.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import UIKit

final class MyPageIconViewCell: UITableViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Property

    private var item: MyPageViewSection.Item! {
        didSet {
            iconImageView.image = item.icon
            titleLabel.text = item.title
        }
    }
}

// MARK: - Injectable

extension MyPageIconViewCell: Injectable {
    func inject(_ dependency: MyPageViewSection.Item) {
        self.item = dependency
    }
}
