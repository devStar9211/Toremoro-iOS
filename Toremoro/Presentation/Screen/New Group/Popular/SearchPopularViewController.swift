//
//  SearchPopularViewController.swift
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

final class SearchPopularViewController: UIViewController {

    enum Reusable {
        static let cell = ReusableCell<SearchPopularViewCell>(identifier: "cell")
    }

    typealias DataSource = RxTableViewSectionedReloadDataSource<SearchPopularViewSection>

    // MARK: - Outlet

    @IBOutlet private(set) weak var tableView: UITableView!

    // MARK: - Property

    let didSelectSearchQuery = PublishSubject<SearchQuery>()
    var disposeBag = DisposeBag()

    private lazy var dataSource: DataSource = {
        DataSource(configureCell: { _, tableView, indexPath, item -> UITableViewCell in
            let cell = tableView.dequeue(Reusable.cell, for: indexPath, with: item)
            return cell
        })
    }()
}

// MARK: - UITableViewDelegate

extension SearchPopularViewController: UITableViewDelegate {}

// MARK: - StoryboardView

extension SearchPopularViewController: StoryboardView {
    func bind(reactor: SearchPopularViewReactor) {
        rx.viewWillAppear.take(1)
            .map { _ in .prepare }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected(dataSource: dataSource)
            .bind(to: didSelectSearchQuery)
            .disposed(by: disposeBag)

        tableView.rx.willBeginDragging
            .subscribe(onNext: { [weak self] in
                self?.view.window?.endEditing(true)
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: rx.loading)
            .disposed(by: disposeBag)

        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
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

extension SearchPopularViewController: StoryboardInstantiatable {
    func inject(_ dependency: ()) {
        self.reactor = SearchPopularViewReactor()
    }
}
