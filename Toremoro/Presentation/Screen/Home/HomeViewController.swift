//
//  HomeViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/13.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxOptional
import ReusableKit
import ReactorKit

final class HomeViewController: UIViewController {

    enum Reusable {
        static let featuresCell = ReusableCell<HomeFeaturesViewCell>(identifier: "featuresCell")
        static let artistsHeader = ReusableCell<UITableViewCell>(identifier: "artistsHeader")
        static let artistsCell = ReusableCell<HomeArtistsViewCell>(identifier: "artistsCell")
        static let genresHeader = ReusableCell<UITableViewCell>(identifier: "genresHeader")
        static let genresCell = ReusableCell<HomeGenresViewCell>(identifier: "genresCell")
    }

    typealias DataSource = RxTableViewSectionedReloadDataSource<HomeViewSection>

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
            switch item {
            case .features(let features):
                let cell = tableView.dequeue(Reusable.featuresCell, for: indexPath, with: features)
                return cell
            case .artists(let artists):
                let cell = tableView.dequeue(Reusable.artistsCell, for: indexPath, with: artists)
                return cell
            case .genres(let genres):
                let cell = tableView.dequeue(Reusable.genresCell, for: indexPath, with: genres)
                return cell
            }
        })
    }()

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Tracker.shared.track(.home)
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            return tableView.dequeue(Reusable.artistsHeader)

        case 2:
            return tableView.dequeue(Reusable.genresHeader)

        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1, 2:
            return 70

        default:
            return 16
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 150
        default:
            return 170
        }
    }
}

// MARK: - StoryboardView

extension HomeViewController: StoryboardView {
    func bind(reactor: HomeViewReactor) {
        rx.viewWillAppear.take(1)
            .map { _ in .prepare }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        tableView.rx
            .setDelegate(self)
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

extension HomeViewController: StoryboardInstantiatable {
    func inject(_ dependency: ()) {
        self.reactor = HomeViewReactor()
    }
}
