//
//  UIImageView+.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/08/17.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit
import Nuke

private enum Key {
    static var url = "UIImageView.url"
}

extension UIImageView: ExtensionProperty {
    var url: URL? {
        get {
            return getProperty(key: &Key.url)
        }
        set {
            setProperty(key: &Key.url, newValue: newValue)
            let contentModes = ImageLoadingOptions.ContentModes(success: .scaleAspectFill, failure: .scaleAspectFill, placeholder: .scaleAspectFill)
            let options = ImageLoadingOptions(contentModes: contentModes)
            _ = newValue.map { Nuke.loadImage(with: $0, options: options, into: self) }
        }
    }
}
