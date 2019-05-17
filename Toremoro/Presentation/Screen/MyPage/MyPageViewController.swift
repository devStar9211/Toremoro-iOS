//
//  MyPageViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/13.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import ReusableKit
import ReactorKit

final class MyPageViewController: UIViewController {

    enum Reusable {
        static let iconCell = ReusableCell<MyPageIconViewCell>(identifier: "iconCell")
        static let textCell = ReusableCell<MyPageTextViewCell>(identifier: "textCell")
        static let detailCell = ReusableCell<MyPageDetailViewCell>(identifier: "detailCell")
        static let supportHeader = ReusableCell<UITableViewCell>(identifier: "supportHeader")
    }

    typealias DataSource = RxTableViewSectionedReloadDataSource<MyPageViewSection>

    // MARK: - Outlet

    @IBOutlet private(set) weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Pattern"))
        }
    }

    // MARK: - Property

    var disposeBag = DisposeBag()

    private lazy var dataSource: DataSource = {
        DataSource(configureCell: { _, tableView, indexPath, item -> UITableViewCell in
            if item.icon != nil {
                let cell = tableView.dequeue(Reusable.iconCell, for: indexPath, with: item)
                return cell
            } else if item.detail != nil {
                let cell = tableView.dequeue(Reusable.detailCell, for: indexPath, with: item)
                return cell
            } else {
                let cell = tableView.dequeue(Reusable.textCell, for: indexPath, with: item)
                return cell
            }
        })
    }()

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Tracker.shared.track(.myPage)
    }
}

// MARK: - UITableViewDelegate

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 1 ? tableView.dequeue(Reusable.supportHeader) : nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 120 : .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

// MARK: - StoryboardView

extension MyPageViewController: StoryboardView {
    func bind(reactor: MyPageViewReactor) {
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected(dataSource: dataSource)
            .map { $0.destination }
            .filterNil()
            .bind(to: self.navigator.rx.push)
            .disposed(by: disposeBag)

        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - StoryboardInstantiatable

extension MyPageViewController: StoryboardInstantiatable {
    func inject(_ dependency: ()) {
        self.reactor = MyPageViewReactor()
    }
}
