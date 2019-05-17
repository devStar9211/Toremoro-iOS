//
//  SearchFilterHeaderViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/04/14.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import UIKit

final class SearchFilterHeaderViewCell: UITableViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: - Property

    private var item: SearchFilterViewSection! {
        didSet {
            nameLabel.text = item.name
        }
    }
}

// MARK: - Injectable

extension SearchFilterHeaderViewCell: Injectable {
    func inject(_ dependency: SearchFilterViewSection) {
        self.item = dependency
    }
}
