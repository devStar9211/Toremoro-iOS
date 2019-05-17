//
//  SearchFilterViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/29.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import ReusableKit
import ReactorKit
import PanModal

final class SearchFilterViewController: UIViewController {

    enum Reusable {
        static let headerCell = ReusableCell<SearchFilterHeaderViewCell>(identifier: "headerCell")
        static let cell = ReusableCell<SearchFilterViewCell>(identifier: "cell")
    }

    typealias DataSource = RxTableViewSectionedReloadDataSource<SearchFilterViewSection>

    // MARK: - Outlet

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!

    // MARK: - Property

    var disposeBag = DisposeBag()

    private lazy var dataSource: DataSource = { [unowned self] in
        DataSource(configureCell: { _, tableView, indexPath, item -> UITableViewCell in
            let cell = tableView.dequeue(Reusable.cell, for: indexPath, with: item)
            return cell
        })
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        Tracker.shared.track(.searchFilter)
    }
}

// MARK: - UITableViewDelegate

extension SearchFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = dataSource.sectionModels[section]
        let view = tableView.dequeue(Reusable.headerCell, with: item)
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

// MARK: - PanModalPresentable

extension SearchFilterViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return tableView
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(32)
    }
}

// MARK: - StoryboardView

extension SearchFilterViewController: StoryboardView {
    func bind(reactor: SearchFilterViewReactor) {
        rx.viewWillAppear.take(1)
            .map { _ in .prepare }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected(dataSource: dataSource)
            .map { .select($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        closeButton.rx.tap
            .bind(to: rx.dismiss)
            .disposed(by: disposeBag)

        resetButton.rx.tap
            .map { .reset }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - StoryboardInstantiatable

extension SearchFilterViewController: StoryboardInstantiatable {
    func inject(_ dependency: SearchFilter) {
        self.reactor = SearchFilterViewReactor(filter: dependency)
    }
}
