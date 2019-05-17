//
//  UITableView+Rx.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/14.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

extension Reactive where Base: UITableView {
    func itemSelected<S>(dataSource: TableViewSectionedDataSource<S>) -> ControlEvent<S.Item> {
        let source = self.itemSelected.map { indexPath in
            dataSource[indexPath]
        }
        return ControlEvent(events: source)
    }
}
