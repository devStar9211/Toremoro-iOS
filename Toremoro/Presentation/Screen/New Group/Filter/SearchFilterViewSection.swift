//
//  SearchFilterViewSection.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/29.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import RxDataSources

enum SearchFilterViewSection {
    case sort([Item])
    case duration([Item])
    case sex([Item])

    var name: String {
        switch self {
        case .sort: return "並び替え"
        case .duration: return "再生時間"
        case .sex: return "配信者"
        }
    }

    enum Item {
        case orderNew(Bool)
        case orderPopular(Bool)
        case durationAll(Bool)
        case durationUnder10min(Bool)
        case durationUnder20min(Bool)
        case durationOver20min(Bool)
        case sexAll(Bool)
        case sexMale(Bool)
        case sexFemale(Bool)
        case sexOther(Bool)

        var isSelected: Bool {
            switch self {
            case .orderNew(let isSelected): return isSelected
            case .orderPopular(let isSelected): return isSelected
            case .durationAll(let isSelected): return isSelected
            case .durationUnder10min(let isSelected): return isSelected
            case .durationUnder20min(let isSelected): return isSelected
            case .durationOver20min(let isSelected): return isSelected
            case .sexAll(let isSelected): return isSelected
            case .sexMale(let isSelected): return isSelected
            case .sexFemale(let isSelected): return isSelected
            case .sexOther(let isSelected): return isSelected
            }
        }

        var name: String {
            switch self {
            case .orderNew: return "新着順"
            case .orderPopular: return "人気順"
            case .durationAll: return "すべて"
            case .durationUnder10min: return "10分以内"
            case .durationUnder20min: return "20分以内"
            case .durationOver20min: return "20分以上"
            case .sexAll: return "すべて"
            case .sexMale: return "Male"
            case .sexFemale: return "Female"
            case .sexOther: return "Other"
            }
        }
    }
}

// MARK: - SectionModelType

extension SearchFilterViewSection: SectionModelType {
    var items: [SearchFilterViewSection.Item] {
        switch self {
        case .sort(let items): return items
        case .duration(let items): return items
        case .sex(let items): return items
        }
    }

    init(original: SearchFilterViewSection, items: [SearchFilterViewSection.Item]) {
        switch original {
        case .sort: self = .sort(items)
        case .duration: self = .duration(items)
        case .sex: self = .sex(items)
        }
    }
}

extension SearchFilterViewSection {
    static let `default`: [SearchFilterViewSection] = {
        return [
            .sort([
                Item.orderNew(true),
                Item.orderPopular(false)
            ]),
            .duration([
                Item.durationAll(true),
                Item.durationUnder10min(false),
                Item.durationUnder20min(false),
                Item.durationOver20min(false)
            ]),
            .sex([
                Item.sexAll(true),
                Item.sexFemale(false),
                Item.sexMale(false),
                Item.sexOther(false)
            ])
        ]
    }()
}
