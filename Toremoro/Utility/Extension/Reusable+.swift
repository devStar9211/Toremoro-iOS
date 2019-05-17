//
//  Reusable+.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/12/30.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import UIKit
import ReusableKit
import Instantiate

typealias Injectable = Instantiate.Injectable

extension UITableView {
    func dequeue<Cell: Injectable>(_ cell: ReusableCell<Cell>, for indexPath: IndexPath, with dependency: Cell.Dependency) -> Cell {
        let cell = dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath) as! Cell // swiftlint:disable:this force_cast
        cell.inject(dependency)
        return cell
    }

    func dequeue<Cell: Injectable>(_ cell: ReusableCell<Cell>, with dependency: Cell.Dependency) -> Cell {
        let cell = dequeueReusableCell(withIdentifier: cell.identifier) as! Cell // swiftlint:disable:this force_cast
        cell.inject(dependency)
        return cell
    }
}

extension UICollectionView {
    func dequeue<Cell: Injectable>(_ cell: ReusableCell<Cell>, for indexPath: IndexPath, with dependency: Cell.Dependency) -> Cell {
        let cell = dequeueReusableCell(withReuseIdentifier: cell.identifier, for: indexPath) as! Cell // swiftlint:disable:this force_cast
        cell.inject(dependency)
        return cell
    }
}
