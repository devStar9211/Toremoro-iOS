//
//  ActivityType.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/02/18.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import Foundation
import UIKit

enum ActivityType {
    case twitter
    case facebook
    case line
    case instagram
    case others(raw: String)
}

extension ActivityType {
    init(_ type: UIActivityType) {
        switch type.rawValue {
        case UIActivityType.postToTwitter.rawValue:
            self = .twitter
        case UIActivityType.postToFacebook.rawValue:
            self = .facebook
        case "jp.naver.line.Share":
            self = .line
        case "com.burbn.instagram.shareextension":
            self = .instagram
        default:
            self = .others(raw: type.rawValue)
        }
    }

    var name: String {
        switch self {
        case .twitter:
            return "twitter"
        case .facebook:
            return "facebook"
        case .line:
            return "line"
        case .instagram:
            return "instagram"
        case .others(let raw):
            return raw
        }
    }
}
