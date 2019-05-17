//
//  StoryboardInstantiatable.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/06.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import Instantiate

typealias StoryboardInstantiatable = Instantiate.StoryboardInstantiatable

extension StoryboardInstantiatable where Self: UIViewController {
    static var storyboardName: StoryboardName {
        return className.replacingOccurrences(of: "ViewController", with: "")
    }
}
