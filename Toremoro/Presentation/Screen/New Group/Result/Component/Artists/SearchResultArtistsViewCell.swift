//
//  SearchResultArtistViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/08.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReusableKit

final class SearchResultArtistsViewCell: UITableViewCell {

    enum Reusable {
        static let cell = ReusableCell<SearchResultArtistsCollectionViewCell>(identifier: "cell")
    }

    typealias DataSource = RxCollectionViewSectionedReloadDataSource<SearchResultArtistsViewSection>

    // MARK: - Outlet

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            setup()
        }
    }

    // MARK: - Property

    let didSelectArtist = PublishSubject<Artist>()

    private var artists: [Artist] = [] {
        didSet {
            let sections = [SearchResultArtistsViewSection(artists: artists)]
            self.sections.accept(sections)
        }
    }

    private lazy var dataSource: DataSource = {
        DataSource(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
            let cell = collectionView.dequeue(Reusable.cell, for: indexPath, with: item)
            return cell
        })
    }()

    private let sections: BehaviorRelay<[SearchResultArtistsViewSection]> = .init(value: [])
    private(set) var disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        setup()
    }

    // MARK: - Private

    private func setup() {
        sections.asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected(dataSource: dataSource)
            .bind(to: didSelectArtist)
            .disposed(by: disposeBag)
    }
}

// MARK: - Injectable

extension SearchResultArtistsViewCell: Injectable {
    func inject(_ dependency: [Artist]) {
        self.artists = dependency
    }
}
