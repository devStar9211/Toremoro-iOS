//
//  ArtistViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/14.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import ReusableKit
import ReactorKit

final class ArtistViewController: UIViewController, PopupPresentable {

    enum Reusable {
        static let profileCell = ReusableCell<ArtistProfileViewCell>(identifier: "profileCell")
        static let videoCell = ReusableCell<VideoViewCell>(nibName: "VideoViewCell")
    }

    typealias DataSource = RxTableViewSectionedReloadDataSource<ArtistViewSection>

    // MARK: - Outlet

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Pattern"))
            tableView.register(Reusable.videoCell)
        }
    }

    @IBOutlet private weak var popularHeaderView: ArtistPopularHeaderView!
    @IBOutlet private weak var newHeaderView: ArtistNewHeaderView!

    // MARK: - Property

    var disposeBag = DisposeBag()

    private lazy var dataSource: DataSource = { [weak self] in
        DataSource(configureCell: { [weak self]  _, tableView, indexPath, item -> UITableViewCell in
            switch item {
            case .profile(let reactor):
                let refreshHandler: (() -> Void)? = { [weak self] in
                    self?.tableView.indexPathsForVisibleRows.map { [weak self] in
                        $0.first.map {
                            self?.tableView.reloadRows(at: [$0], with: .fade)
                        }
                    }
                }
                let dependency = (reactor: reactor, refreshHandler: refreshHandler)
                let cell = tableView.dequeue(Reusable.profileCell, for: indexPath, with: dependency)
                return cell
            case .popular(let video):
                let cell = tableView.dequeue(Reusable.videoCell, for: indexPath, with: video)
                return cell
            case .new(let video):
                let cell = tableView.dequeue(Reusable.videoCell, for: indexPath, with: video)
                return cell
            }
        })
    }()

    // MARK: - Lifecycle

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.hideNavigationBar(animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hideNavigationBar(animated: false)
        (reactor?.currentState.artist).map { Tracker.shared.track(.artist($0)) }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.restoreNavigationBar(animated: false)
    }
}

// MARK: - UITableViewDelegate

extension ArtistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let view = popularHeaderView
            view?.artist = reactor?.currentState.artist
            return view

        case 2:
            let view = newHeaderView
            view?.artist = reactor?.currentState.artist
            return view

        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1, 2:
            return 60
        default:
            return .leastNormalMagnitude
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1, 2:
            return 100
        default:
            return UITableViewAutomaticDimension
        }
    }
}

// MARK: - StoryboardView

extension ArtistViewController: StoryboardView {
    func bind(reactor: ArtistViewReactor) {
        rx.viewWillAppear.take(1)
            .map { _ in .prepare }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected(dataSource: dataSource)
            .map { $0.video }
            .filterNil()
            .distinctUntilChanged()
            .bind(to: rx.play)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: rx.loading)
            .disposed(by: disposeBag)

        reactor.state.map { $0.sections }
            .observeOn(MainScheduler.instance)
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

extension ArtistViewController: StoryboardInstantiatable {
    func inject(_ dependency: Artist) {
        self.reactor = ArtistViewReactor(artist: dependency)
    }
}
