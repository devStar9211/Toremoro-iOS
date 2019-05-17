//
//  SearchTopViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/06.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import ReusableKit
import ReactorKit

final class SearchTopViewController: UIViewController {

    enum Reusable {
        static let cell = ReusableCell<SearchTopViewCell>(identifier: "cell")
    }

    typealias DataSource = RxCollectionViewSectionedReloadDataSource<SearchTopViewSection>

    // MARK: - Outlet

    @IBOutlet private(set) weak var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Pattern"))
        }
    }

    // MARK: - Property

    var disposeBag = DisposeBag()

    private lazy var dataSource: DataSource = {
        DataSource(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
            let cell = collectionView.dequeue(Reusable.cell, for: indexPath, with: item)
            return cell
        })
    }()
}

// MARK: - UICollectionViewDelegate

extension SearchTopViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchTopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 8 * 2) / 2
        return CGSize(width: width, height: width)
    }
}

// MARK: - StoryboardView

extension SearchTopViewController: StoryboardView {
    func bind(reactor: SearchTopViewReactor) {
        rx.viewWillAppear.take(1)
            .map { _ in .prepare }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected(dataSource: dataSource)
            .map { VideosViewController(with: .genre($0)) }
            .bind(to: navigator.rx.push)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: rx.loading)
            .disposed(by: disposeBag)

        reactor.state.map { $0.sections }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        reactor.state.map { $0.error }
            .filterNil()
            .flatMap { [unowned self] in self.rx.handle(error: $0) }
            .map { .dismissErrorAlert }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - StoryboardInstantiatable

extension SearchTopViewController: StoryboardInstantiatable {
    func inject(_ dependency: ()) {
        self.reactor = SearchTopViewReactor()
    }
}
