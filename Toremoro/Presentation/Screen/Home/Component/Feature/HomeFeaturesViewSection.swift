//
//  HomeFeaturesViewSection.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/09/24.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxDataSources

struct HomeFeaturesViewSection: SectionModelType {

    // MARK: - Property

    var items: [Feature]

    // MARK: - Initializer

    init(features: [Feature]) {
        self.items = features
    }

    init(original: HomeFeaturesViewSection, items: [Feature]) {
        self = original
        self.items = items
    }
}
