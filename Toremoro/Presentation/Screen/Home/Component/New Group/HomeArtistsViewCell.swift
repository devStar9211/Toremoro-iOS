//
//  HomeArtistsViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/13.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReusableKit

final class HomeArtistsViewCell: UITableViewCell {

    enum Reusable {
        static let artistCell = ReusableCell<HomeArtistsCollectionViewCell>(identifier: "artist")
        static let moreCell = ReusableCell<HomeArtistsCollectionViewMoreCell>(identifier: "more")
    }

    typealias DataSource = RxCollectionViewSectionedReloadDataSource<HomeArtistsViewSection>

    // MARK: - Outlet

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            sections.asObservable()
                .bind(to: collectionView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)

            collectionView.rx.itemSelected(dataSource: dataSource)
                .map { item -> Artist? in
                    guard case .artist(let artist) = item else { return nil }
                    return artist
                }
                .filterNil()
                .map { ArtistViewController(with: $0) }
                .bind(to: self.navigator.rx.push)
                .disposed(by: disposeBag)

            collectionView.rx.itemSelected(dataSource: dataSource)
                .filter { $0 == .more }
                .do(onNext: { _ in
                    Tracker.shared.track(.seeMoreArtists)
                })
                .map { _ in .artists }
                .bind(to: AppState.selectTab)
                .disposed(by: disposeBag)
        }
    }

    // MARK: - Property

    private var artists: [Artist] = [] {
        didSet {
            let sections = [HomeArtistsViewSection(artists: artists)]
            self.sections.accept(sections)
        }
    }

    private lazy var dataSource: DataSource = {
        DataSource(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .artist(let artist):
                let cell = collectionView.dequeue(Reusable.artistCell, for: indexPath, with: artist)
                return cell
            case .more:
                let cell = collectionView.dequeue(Reusable.moreCell, for: indexPath)
                return cell
            }
        })
    }()

    private let sections: BehaviorRelay<[HomeArtistsViewSection]> = .init(value: [])
    private let disposeBag = DisposeBag()
}

// MARK: - Injectable

extension HomeArtistsViewCell: Injectable {
    func inject(_ dependency: [Artist]) {
        self.artists = dependency
    }
}
