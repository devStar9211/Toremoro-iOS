//
//  VideosViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/26.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import ReusableKit
import ReactorKit

final class VideosViewController: UIViewController, PopupPresentable {

    enum Context {
        case artist(Artist)
        case populars(Artist)
        case genre(Genre)
        case feature(Feature)
        case favorites
    }

    enum Reusable {
        static let cell = ReusableCell<VideoViewCell>(nibName: "VideoViewCell")
    }

    typealias DataSource = RxTableViewSectionedReloadDataSource<VideosViewSection>

    // MARK: - Outlet

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Pattern"))
            tableView.register(Reusable.cell)
        }
    }

    // MARK: - Property

    var disposeBag = DisposeBag()

    private lazy var dataSource: DataSource = {
        DataSource(configureCell: { _, tableView, indexPath, item -> UITableViewCell in
            let cell = tableView.dequeue(Reusable.cell, for: indexPath, with: item)
            return cell
        })
    }()

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.showNavigationBar(animated: true)
        (reactor?.currentState.context).map {
            switch $0 {
            case .artist(let artist): Tracker.shared.track(.artistVideos(artist))
            case .populars(let artist): Tracker.shared.track(.artistPopularVideos(artist))
            case .genre(let genre): Tracker.shared.track(.genreVideos(genre))
            case .feature(let feature): Tracker.shared.track(.featureVideos(feature))
            case .favorites: Tracker.shared.track(.favoriteVideos)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.restoreNavigationBar(animated: true)
    }
}

// MARK: - UITableViewDelegate

extension VideosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
}

// MARK: - StoryboardView

extension VideosViewController: StoryboardView {
    func bind(reactor: VideosViewReactor) {
        rx.viewWillAppear.take(1)
            .map { _ in .prepare }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected(dataSource: dataSource)
            .distinctUntilChanged()
            .bind(to: rx.play)
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

extension VideosViewController: StoryboardInstantiatable {
    func inject(_ dependency: Context) {
        self.reactor = VideosViewReactor(context: dependency)
    }
}
