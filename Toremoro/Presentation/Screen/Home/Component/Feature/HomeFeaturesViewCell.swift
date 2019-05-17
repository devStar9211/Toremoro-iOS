//
//  HomeFeaturesViewCell.swift
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
import SafariServices

final class HomeFeaturesViewCell: UITableViewCell {

    enum Reusable {
        static let featureCell = ReusableCell<HomeFeaturesCollectionViewCell>(identifier: "feature")
    }

    struct Constant {
        static let cellAspectRatio: CGFloat = 142 / 284
    }

    typealias DataSource = RxCollectionViewSectionedReloadDataSource<HomeFeaturesViewSection>

    // MARK: - Outlet

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionViewLayout.itemInterval = 0
            collectionViewLayout.itemHorizontalSpacing = (frame.width - 284 - 16) / 2
            collectionViewLayout.itemVerticalSpacing = 0
            collectionViewLayout.headerWidth = 0

            sections.asObservable()
                .bind(to: collectionView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)

            collectionView.rx.itemSelected(dataSource: dataSource)
                .filter { $0.target == .artist }
                .map { $0.artist }
                .filterNil()
                .map { ArtistViewController(with: $0) }
                .bind(to: self.navigator.rx.push)
                .disposed(by: disposeBag)

            collectionView.rx.itemSelected(dataSource: dataSource)
                .filter { $0.target == .artist && $0.artist == nil }
                .map { ArtistsViewController(with: .feature($0)) }
                .bind(to: self.navigator.rx.push)
                .disposed(by: disposeBag)

            collectionView.rx.itemSelected(dataSource: dataSource)
                .filter { $0.target == .video }
                .map { $0.video }
                .filterNil()
                .map { VideoViewController(with: $0) }
                .bind(to: self.navigator.rx.push)
                .disposed(by: disposeBag)

            collectionView.rx.itemSelected(dataSource: dataSource)
                .filter { $0.target == .video && $0.video == nil }
                .map { VideosViewController(with: .feature($0)) }
                .bind(to: self.navigator.rx.push)
                .disposed(by: disposeBag)

            collectionView.rx.itemSelected(dataSource: dataSource)
                .filter { $0.target == .web }
                .map { $0.url }
                .filterNil()
                .map { SFSafariViewController(url: $0) }
                .bind(to: self.navigator.rx.present)
                .disposed(by: disposeBag)
        }
    }

    // MARK: - Property

    private var features: [Feature] = [] {
        didSet {
            let sections = [HomeFeaturesViewSection(features: features)]
            self.sections.accept(sections)
        }
    }

    private lazy var dataSource: DataSource = {
        DataSource(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
            let cell = collectionView.dequeue(Reusable.featureCell, for: indexPath, with: item)
            return cell
        })
    }()

    private lazy var collectionViewLayout: CarouselCollectionViewFlowLayout = {
        return collectionView.collectionViewLayout
            as! CarouselCollectionViewFlowLayout // swiftlint:disable:this force_cast
    }()

    private let sections: BehaviorRelay<[HomeFeaturesViewSection]> = .init(value: [])
    private let disposeBag = DisposeBag()
}

// MARK: - Injectable

extension HomeFeaturesViewCell: Injectable {
    func inject(_ dependency: [Feature]) {
        self.features = dependency
    }
}
