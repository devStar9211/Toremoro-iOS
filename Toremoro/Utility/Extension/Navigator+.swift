//
//  Navigator+.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/10/18.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import UIKit
import URLNavigator

extension Navigator {
    func popViewController(animated: Bool) {
        guard let navigationController = UIViewController.topMost?.navigationController else { return }
        navigationController.popViewController(animated: animated)
    }
}
