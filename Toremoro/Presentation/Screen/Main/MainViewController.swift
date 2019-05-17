//
//  MainViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/07.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import ReactorKit
import LNPopupController

final class MainViewController: UITabBarController {

    // MARK: - Property

    var disposeBag = DisposeBag()

    // MARK: - Private

    private func scrollView(for viewController: UIViewController) -> UIScrollView? {
        switch viewController {
        case let viewController as HomeNavigationController:
            let childViewController = viewController.childViewControllers.first as? HomeViewController
            return childViewController?.tableView

        case let viewController as ArtistsNavigationController:
            let childViewController = viewController.childViewControllers.first as? ArtistsViewController
            return childViewController?.tableView

        case let viewController as MyPageNavigationController:
            let childViewController = viewController.childViewControllers.first as? MyPageViewController
            return childViewController?.tableView

        default:
            return nil
        }
    }
}

// MARK: - StoryboardView

extension MainViewController: StoryboardView {
    func bind(reactor: MainViewReactor) {
        Observable.zip(rx.didSelect, rx.didSelect.skip(1))
            .filter { $0.0 == $0.1 }
            .map { [unowned self] in self.scrollView(for: $0.0) }
            .filterNil()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { $0.setContentOffset(.zero, animated: true) })
            .disposed(by: disposeBag)

        reactor.state.map { $0.selectedIndex }
            .filterNil()
            .observeOn(MainScheduler.instance)
            .bind(to: rx.selectedIndex)
            .disposed(by: disposeBag)
    }
}

// MARK: - StoryboardInstantiatable

extension MainViewController: StoryboardInstantiatable {
    func inject(_ dependency: ()) {
        self.reactor = MainViewReactor()
    }
}

// MARK: - Rx

extension Reactive where Base: MainViewController {
    var selectedIndex: Binder<Int> {
        return Binder(self.base) { mainViewController, selectedIndex in
            mainViewController.selectedIndex = selectedIndex
        }
    }
}
