//
//  SleepTimerViewSection.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/02/10.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import RxDataSources

struct SleepTimerViewSection: SectionModelType {

    enum Item {
        case _15min
        case _30min
        case _45min
        case _1h
        case _2h
        case end
        case custom
    }

    // MARK: - Property

    var items: [Item]

    // MARK: - Initializer

    init(_ items: [Item]) {
        self.items = items
    }

    init(original: SleepTimerViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}

extension SleepTimerViewSection.Item {
    var name: String {
        switch self {
        case ._15min: return "15min"
        case ._30min: return "30min"
        case ._45min: return "45min"
        case ._1h: return "1h"
        case ._2h: return "2h"
        case .end: return "動画終了時"
        case .custom: return "カスタム"
        }
    }

    var sleepTimerState: SleepTimer.State? {
        switch self {
        case ._15min: return .time(start: Date(), limit: 60 * 15)
        case ._30min: return .time(start: Date(), limit: 60 * 30)
        case ._45min: return .time(start: Date(), limit: 60 * 45)
        case ._1h: return .time(start: Date(), limit: 60 * 60)
        case ._2h: return .time(start: Date(), limit: 60 * 60 * 2)
        case .end: return .untilTheEnd
        case .custom: return nil
        }
    }
}

extension SleepTimerViewSection {
    static let `default`: [SleepTimerViewSection] = {
        let items: [Item] = [._15min, ._30min, ._45min, ._1h, ._2h, .end, .custom].reversed()
        return [
            SleepTimerViewSection(items)
        ]
    }()
}
