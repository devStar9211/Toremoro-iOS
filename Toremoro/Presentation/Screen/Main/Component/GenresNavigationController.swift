//
//  SearchNavigationController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/15.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit

final class SearchNavigationController: UINavigationController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let viewController = SearchViewController(with: ())
        setViewControllers([viewController], animated: false)
    }
}
