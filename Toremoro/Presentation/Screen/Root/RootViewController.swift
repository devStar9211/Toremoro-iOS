//
//  RootViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/06.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {

    // MARK: - Property

    private(set) var currentViewController: UIViewController?

    // MARK: - Public

    func route(_ viewController: UIViewController, animated: Bool) {
        guard let currentViewController = currentViewController else {
            addChildViewController(viewController)
            view.addSubview(viewController.view)
            viewController.didMove(toParentViewController: self)
            self.currentViewController = viewController

            return
        }

        transition(from: currentViewController, to: viewController, animated: animated)
        self.currentViewController = viewController
    }

    // MARK: - Private

    private func transition(from fromViewController: UIViewController, to toViewController: UIViewController, animated: Bool) {
        fromViewController.willMove(toParentViewController: nil)
        addChildViewController(toViewController)
        toViewController.view.alpha = 0

        let duration = animated ? 0.2 : 0

        transition(from: fromViewController, to: toViewController, duration: duration, options: [], animations: {
            toViewController.view.alpha = 1
        }, completion: { _ in
            fromViewController.removeFromParentViewController()
            toViewController.didMove(toParentViewController: self)
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
}

// MARK: - StoryboardInstantiatable

extension RootViewController: StoryboardInstantiatable {}
