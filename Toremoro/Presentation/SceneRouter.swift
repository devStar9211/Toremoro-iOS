//
//  SceneRouter.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/06.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit

final class SceneRouter {

    enum Scene {
        case splash, tutorial, main

        var viewController: UIViewController {
            switch self {
            case .splash: return SplashViewController(with: ())
            case .tutorial: return TutorialViewController(with: ())
            case .main: return MainViewController(with: ())
            }
        }
    }

    // MARK: - Static

    static let shared = SceneRouter()

    // MARK: - Property

    weak var rootViewController: RootViewController!

    // MARK: - Initializer

    private init() {}

    // MARK: - Public

    func route(to scene: Scene, animated: Bool) {
        rootViewController.route(scene.viewController, animated: animated)
    }
}
