//
//  HomeGenresViewCell.swift
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

final class HomeGenresViewCell: UITableViewCell {

    enum Reusable {
        static let genreCell = ReusableCell<HomeGenresCollectionViewCell>(identifier: "genre")
        static let moreCell = ReusableCell<HomeGenresCollectionViewMoreCell>(identifier: "more")
    }

    typealias DataSource = RxCollectionViewSectionedReloadDataSource<HomeGenresViewSection>

    // MARK: - Outlet

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            sections.asObservable()
                .bind(to: collectionView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)

            collectionView.rx.itemSelected(dataSource: dataSource)
                .map { item -> Genre? in
                    guard case .genre(let genre) = item else { return nil }
                    return genre
                }
                .filterNil()
                .map { VideosViewController(with: .genre($0)) }
                .bind(to: self.navigator.rx.push)
                .disposed(by: disposeBag)

            collectionView.rx.itemSelected(dataSource: dataSource)
                .filter { $0 == .more }
                .do(onNext: { _ in
                    Tracker.shared.track(.seeMoreGenres)
                })
                .map { _ in .genres }
                .bind(to: AppState.selectTab)
                .disposed(by: disposeBag)
        }
    }

    // MARK: - Property

    private var genres: [Genre] = [] {
        didSet {
            let sections = [HomeGenresViewSection(genres: genres)]
            self.sections.accept(sections)
        }
    }

    private lazy var dataSource: DataSource = {
        DataSource(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .genre(let genre):
                let cell = collectionView.dequeue(Reusable.genreCell, for: indexPath, with: genre)
                return cell
            case .more:
                let cell = collectionView.dequeue(Reusable.moreCell, for: indexPath)
                return cell
            }
        })
    }()

    private let sections: BehaviorRelay<[HomeGenresViewSection]> = .init(value: [])
    private let disposeBag = DisposeBag()
}

// MARK: - Injectable

extension HomeGenresViewCell: Injectable {
    func inject(_ dependency: [Genre]) {
        self.genres = dependency
    }
}
