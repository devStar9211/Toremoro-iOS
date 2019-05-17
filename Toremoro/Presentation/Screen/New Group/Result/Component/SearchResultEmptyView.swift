//
//  SearchResultEmptyView.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/10.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchResultEmptyView: UIView {

    // MARK: - Outlet

    @IBOutlet private weak var textLabel: UILabel!

    // MARK: - Public

    func update(for query: SearchQuery) {
        textLabel.text = "「\(query)」の検索結果はありませんでした。"
    }
}

// MARK: - Reactive

extension Reactive where Base: SearchResultEmptyView {
    var query: Binder<SearchQuery> {
        return Binder(self.base) { view, query in
            view.update(for: query)
        }
    }
}
