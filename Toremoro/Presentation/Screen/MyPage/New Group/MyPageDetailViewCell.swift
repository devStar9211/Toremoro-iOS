//
//  MyPageDetailViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/25.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import UIKit

final class MyPageDetailViewCell: UITableViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!

    // MARK: - Property

    private var item: MyPageViewSection.Item! {
        didSet {
            titleLabel.text = item.title
            detailLabel.text = item.detail
        }
    }
}

// MARK: - Injectable

extension MyPageDetailViewCell: Injectable {
    func inject(_ dependency: MyPageViewSection.Item) {
        self.item = dependency
    }
}
