//
//  UISearchBar.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/08.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import UIKit

extension UISearchBar {
    var textField: UITextField? {
        return value(forKey: "searchField") as? UITextField
    }
}
