//
//  MyPageViewSection.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/07/24.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import RxDataSources

struct MyPageViewSection: SectionModelType {

    enum Item {
        case favoriteVideos
        case favoriteArtists
        case terms
        case feedback
        case version
    }

    // MARK: - Proeprty

    var items: [Item]

    // MARK: - Initializer

    init(_ items: [Item]) {
        self.items = items
    }

    init(original: MyPageViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}

extension MyPageViewSection.Item {
    var title: String {
        switch self {
        case .favoriteVideos: return "FAVORITE VIDEOS"
        case .favoriteArtists: return "FAVORITE ARTISTS"
        case .terms: return "利用規約"
        case .feedback: return "お問い合わせ & リクエスト"
        case .version: return "バージョン"
        }
    }

    var detail: String? {
        switch self {
        case .version:
            return AppInfo.version
        default:
            return nil
        }
    }

    var destination: UIViewController? {
        switch self {
        case .favoriteVideos: return VideosViewController(with: .favorites)
        case .favoriteArtists: return ArtistsViewController(with: .favorite)
        case .terms: return WebViewController(with: (title: "利用規約", url: URL(string: "https://toremoro.app/terms")!))
        case .feedback: return FeedbackViewController(with: ())
        case .version: return nil
        }
    }

    var icon: UIImage? {
        switch self {
        case .favoriteVideos: return #imageLiteral(resourceName: "FavoriteVideos")
        case .favoriteArtists: return #imageLiteral(resourceName: "FavoriteArtists")
        default: return nil
        }
    }
}

extension MyPageViewSection {
    static let `default`: [MyPageViewSection] = [
        MyPageViewSection([.favoriteVideos, .favoriteArtists]),
        MyPageViewSection([.terms, .feedback, .version])
    ]
}
