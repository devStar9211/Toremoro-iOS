//
//  SearchResultViewController.swift
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

final class SearchResultViewController: UIViewController, PopupPresentable {

    enum Reusable {
        static let artistsCell = ReusableCell<SearchResultArtistsViewCell>(identifier: "artistsCell")
        static let videoCell = ReusableCell<VideoViewCell>(nibName: "VideoViewCell")
    }

    typealias DataSource = RxTableViewSectionedReloadDataSource<SearchResultViewSection>

    // MARK: - Outlet

    @IBOutlet private(set) weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Pattern"))
            tableView.register(Reusable.videoCell)
        }
    }

    @IBOutlet private weak var artistsHeaderView: UIView!
    @IBOutlet private weak var videosHeaderView: UIView!

    @IBOutlet private weak var emptyView: SearchResultEmptyView! {
        didSet {
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            emptyView.isHidden = true
        }
    }

    // MARK: - Property

    var disposeBag = DisposeBag()

    private lazy var dataSource: DataSource = { [unowned self] in
        DataSource(configureCell: { _, tableView, indexPath, item -> UITableViewCell in
            switch item {
            case .artists(let artists):
                let cell = tableView.dequeue(Reusable.artistsCell, for: indexPath, with: artists)
                cell.didSelectArtist
                    .map { ArtistViewController(with: $0) }
                    .subscribe(onNext: { viewController in
                        self.navigationController?.pushViewController(viewController, animated: true)
                    })
                    .disposed(by: cell.disposeBag)
                return cell
            case .video(let video):
                let cell = tableView.dequeue(Reusable.videoCell, for: indexPath, with: video)
                return cell
            }
        })
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(emptyView)
        emptyView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        emptyView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        emptyView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

// MARK: - UITableViewDelegate

extension SearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let videos = reactor?.currentState.sections[section].videos else {
            return nil
        }

        if videos.isEmpty {
            return artistsHeaderView
        } else {
            return videosHeaderView
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let videos = reactor?.currentState.sections[indexPath.section].videos else {
            return .leastNormalMagnitude
        }

        if videos.isEmpty {
            return 120
        } else {
            return 100
        }
    }
}

// MARK: - StoryboardView

extension SearchResultViewController: StoryboardView {
    func bind(reactor: SearchResultViewReactor) {
        rx.viewWillAppear.take(1)
            .map { _ in .prepare }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected(dataSource: dataSource)
            .map { item -> Video? in
                if case let .video(video) = item {
                    return video
                } else {
                    return nil
                }
            }
            .filterNil()
            .bind(to: rx.play)
            .disposed(by: disposeBag)

        tableView.rx.isReachedBottom
            .map { .loadMore }
            .bind(to: reactor.action)
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

        reactor.state.map { $0.query }
            .bind(to: emptyView.rx.query)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isEmpty }
            .toggle()
            .bind(to: emptyView.rx.isHidden)
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

extension SearchResultViewController: StoryboardInstantiatable {
    func inject(_ dependency: SearchQuery) {
        self.reactor = SearchResultViewReactor(query: dependency)
    }
}
