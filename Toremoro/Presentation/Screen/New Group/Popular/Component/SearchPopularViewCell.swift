//
//  SearchPopularViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/08.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import UIKit

final class SearchPopularViewCell: UITableViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var queryLabel: UILabel!

    // MARK: - Property

    private var query: SearchQuery! {
        didSet {
            queryLabel.text = query
        }
    }
}

// MARK: - Injectable

extension SearchPopularViewCell: Injectable {
    func inject(_ dependency: SearchQuery) {
        self.query = dependency
    }
}
