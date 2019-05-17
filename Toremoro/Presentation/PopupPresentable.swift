//
//  PopupPresentable.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/12/06.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import LNPopupController

struct PopupPresenter {

    // MARK: - Property

    private var mainViewController: MainViewController {
        guard let viewController = SceneRouter.shared.rootViewController.currentViewController as? MainViewController else {
            fatalError()
        }
        return viewController
    }

    // MARK: - Public

    func play(_ video: Video) {
        let videos = AppState.watchedVideos.value
        if videos.count > 1, videos[videos.count - 2] == video {
            AppState.watchedVideos.value.removeLast()
        } else {
            AppState.watchedVideos.value.append(video)
        }

        let playerViewController = PlayerViewController(with: video)
        playerViewController.preferredContentSize.height = 40
        mainViewController.popupBar.customBarViewController = playerViewController
        mainViewController.popupContentView.popupCloseButtonStyle = .none
        mainViewController.popupInteractionStyle = .drag

        let videoViewController = VideoViewController(with: video)
        let navigationController = UINavigationController(rootViewController: videoViewController)
        navigationController.navigationBar.isHidden = true
        mainViewController.presentPopupBar(withContentViewController: navigationController, openPopup: true, animated: true)
    }

    func open() {
        mainViewController.openPopup(animated: true)
    }

    func close() {
        mainViewController.closePopup(animated: true)
    }
}

protocol PopupPresentable: class {
    func play(_: Video)
    func open()
    func close()
}

private let presenter = PopupPresenter()

extension PopupPresentable {
    func play(_ video: Video) {
        presenter.play(video)
    }

    func open() {
        presenter.open()
    }

    func close() {
        presenter.close()
    }
}

// MARK: - Rx

extension Reactive where Base: PopupPresentable {
    var play: Binder<Video> {
        return Binder(self.base) { presenter, video in
            presenter.play(video)
        }
    }

    var open: Binder<Void> {
        return Binder(self.base) { presenter, _ in
            presenter.open()
        }
    }

    var close: Binder<Void> {
        return Binder(self.base) { presenter, _ in
            presenter.close()
        }
    }
}
