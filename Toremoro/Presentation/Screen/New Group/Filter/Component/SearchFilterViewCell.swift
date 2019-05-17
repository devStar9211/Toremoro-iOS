//
//  SearchFilterViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/29.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import UIKit

final class SearchFilterViewCell: UITableViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var checkImageView: UIImageView!

    // MARK: - Property

    private var item: SearchFilterViewSection.Item! {
        didSet {
            nameLabel.text = item.name
            checkImageView.isHidden = !item.isSelected
        }
    }
}

// MARK: - Injectable

extension SearchFilterViewCell: Injectable {
    func inject(_ dependency: SearchFilterViewSection.Item) {
        self.item = dependency
    }
}
