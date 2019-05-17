//
//  SleepTimerViewSelectionCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/02/10.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import UIKit

final class SleepTimerViewSelectionCell: UITableViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: - Property

    private var item: SleepTimerViewSection.Item! {
        didSet {
            nameLabel.text = item.name
        }
    }
}

// MARK: - Injectable

extension SleepTimerViewSelectionCell: Injectable {
    func inject(_ dependency: SleepTimerViewSection.Item) {
        self.item = dependency
    }
}
