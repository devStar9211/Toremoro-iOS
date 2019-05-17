//
//  ArtistsViewController.swift
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

final class ArtistsViewController: UIViewController {

    enum Context {
        case main
        case favorite
        case feature(Feature)
    }

    enum Reusable {
        static let pickupHeader = ReusableCell<UITableViewCell>(identifier: "pickupHeader")
        static let allHeader = ReusableCell<UITableViewCell>(identifier: "allHeader")
        static let artistLargeCell = ReusableCell<ArtistsLargeViewCell>(identifier: "artistLargeCell")
        static let artistCell = ReusableCell<ArtistsViewCell>(identifier: "artistCell")
    }

    typealias DataSource = RxTableViewSectionedReloadDataSource<ArtistsViewSection>

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
            case .pickup(let artist):
                let cell = tableView.dequeue(Reusable.artistLargeCell, for: indexPath, with: artist)
                return cell

            case .popular(let artist), .artist(let artist):
                let cell = tableView.dequeue(Reusable.artistCell, for: indexPath, with: artist)
                return cell
            }
        })
    }()

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (reactor?.currentState.context).map {
            switch $0 {
            case .main: Tracker.shared.track(.artists)
            case .favorite: Tracker.shared.track(.favoriteArtists)
            case .feature(let feature): Tracker.shared.track(.featureArtists(feature))
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension ArtistsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let context = reactor?.currentState.context else {
            return nil
        }

        switch context {
        case .main:
            switch section {
            case 0:
                return tableView.dequeue(Reusable.pickupHeader)

            default:
                return tableView.dequeue(Reusable.allHeader)
            }

        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let context = reactor?.currentState.context else {
            return .leastNormalMagnitude
        }

        switch context {
        case .main:
            return 70

        default:
            return .leastNormalMagnitude
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let context = reactor?.currentState.context else {
            return .leastNormalMagnitude
        }

        switch context {
        case .main:
            switch indexPath.section {
            case 0:
                return 200

            default:
                return 120
            }

        default:
            return 120
        }
    }
}

// MARK: - StoryboardView

extension ArtistsViewController: StoryboardView {
    func bind(reactor: ArtistsViewReactor) {
        rx.viewWillAppear.take(1)
            .map { _ in .prepare }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected(dataSource: dataSource)
            .map { ArtistViewController(with: $0.artist) }
            .bind(to: navigator.rx.push)
            .disposed(by: disposeBag)

        tableView.rx.isReachedBottom
            .map { .loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.title }
            .filterNil()
            .bind(to: rx.title)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isLoading }
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

extension ArtistsViewController: StoryboardInstantiatable {
    func inject(_ dependency: Context) {
        self.reactor = ArtistsViewReactor(context: dependency)
    }
}
