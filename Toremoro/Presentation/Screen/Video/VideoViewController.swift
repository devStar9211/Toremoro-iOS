//
//  VideoViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/18.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import ReusableKit
import ReactorKit
import MediaPlayer

final class VideoViewController: UIViewController, PopupPresentable {

    enum Reusable {
        static let detailCell = ReusableCell<VideoDetailViewCell>(identifier: "detailCell")
        static let relatedHeader = ReusableCell<UITableViewCell>(identifier: "relatedHaeder")
        static let videoCell = ReusableCell<VideoViewCell>(nibName: "VideoViewCell")
    }

    typealias DataSource = RxTableViewSectionedReloadDataSource<VideoViewSection>

    // MARK: - Outlet

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Pattern"))
            tableView.register(Reusable.videoCell)
        }
    }

    @IBOutlet private weak var closeButton: UIButton!

    // MARK: - Property

    var disposeBag = DisposeBag()
    private weak var videoPlayer: VideoPlayer!

    private lazy var dataSource: DataSource = { [weak self] in
        DataSource(configureCell: { [weak self] _, tableView, indexPath, item -> UITableViewCell in
            switch item {
            case .detail(let reactor):
                let sleepTimerHandler: (() -> Void)? = { [weak self] in
                    let viewController = SleepTimerViewController(with: ())
                    self?.navigationController?.present(viewController, animated: true)
                }
                let refreshHandler: (() -> Void)? = { [weak self] in
                    self?.tableView.beginUpdates()
                    self?.tableView.endUpdates()
                }
                let dependency = (reactor: reactor, sleepTimerHandler: sleepTimerHandler, refreshHandler: refreshHandler)
                let cell = tableView.dequeue(Reusable.detailCell, for: indexPath, with: dependency)
                return cell
            case .related(let video):
                let cell = tableView.dequeue(Reusable.videoCell, for: indexPath, with: video)
                return cell
            }
        })
    }()

    private var videoPlayerViewConstraints: [NSLayoutConstraint]?

    // MARK: - Lifecycle

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? VideoPlayer {
            self.videoPlayer = viewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.isLockAutoRotation = false
        (reactor?.currentState.video).map { Tracker.shared.track(.video($0)) }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.isLockAutoRotation = true
    }

    // MARK: - Orientation

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.updateLayout(for: newCollection)
            self?.view.layoutIfNeeded()
        })
    }

    // MARK: - Private

    private func updateLayout(for collection: UITraitCollection) {
        guard videoPlayer != nil else { return }

        if videoPlayerViewConstraints == nil {
            videoPlayerViewConstraints = [
                videoPlayer.view.topAnchor.constraint(equalTo: view.topAnchor),
                videoPlayer.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                videoPlayer.view.leftAnchor.constraint(equalTo: view.leftAnchor),
                videoPlayer.view.rightAnchor.constraint(equalTo: view.rightAnchor)
            ]
            videoPlayerViewConstraints?.forEach { $0.priority = .required }
        }

        videoPlayerViewConstraints?.forEach { $0.isActive = collection.verticalSizeClass == .compact }
        videoPlayer.view.setNeedsUpdateConstraints()
    }
}

// MARK: - UITableViewDelegate

extension VideoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            return tableView.dequeue(Reusable.relatedHeader)?.contentView
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
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
        case 1:
            return 100
        default:
            return UITableViewAutomaticDimension
        }
    }
}

// MARK: - StoryboardView

extension VideoViewController: StoryboardView {
    func bind(reactor: VideoViewReactor) {
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

        closeButton.rx.tap
            .do(onNext: {
                Tracker.shared.track(.closePlayer)
            })
            .bind(to: rx.close)
            .disposed(by: disposeBag)

        reactor.state.map { $0.video }
            .bind(to: videoPlayer.rx.video)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: rx.loading)
            .disposed(by: disposeBag)

        reactor.state.map { $0.video.title }
            .bind(to: MPNowPlayingInfoCenter.default().rx.nowPlayingTitle)
            .disposed(by: disposeBag)

        reactor.state.map { $0.artist }
            .filterNil()
            .map { $0.name }
            .bind(to: MPNowPlayingInfoCenter.default().rx.nowPlayingArtist)
            .disposed(by: disposeBag)

        reactor.state.map { $0.nextVideo }
            .filterNil()
            .bind(to: videoPlayer.rx.nextVideo)
            .disposed(by: disposeBag)

        reactor.state.map { $0.sections }
            .distinctUntilChanged()
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

extension VideoViewController: StoryboardInstantiatable {
    func inject(_ dependency: Video) {
        self.reactor = VideoViewReactor(video: dependency)
    }
}
