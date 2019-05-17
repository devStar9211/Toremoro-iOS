//
//  ArtistProfileViewCell.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/10/17.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit
import ActiveLabel
import SafariServices

final class ArtistProfileViewCell: UITableViewCell {

    // MARK: - Outlet

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var favoriteButton: AnimatedFavoriteButton!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var subscribersLabel: UILabel!
    @IBOutlet private weak var readMoreButton: UIButton!
    @IBOutlet private weak var descriptionLabel: ActiveLabel! {
        didSet {
            descriptionLabel.enabledTypes = [.url]
            descriptionLabel.URLColor = #colorLiteral(red: 0, green: 0.4310425818, blue: 0.8352131248, alpha: 1)
            descriptionLabel.handleURLTap {
                let viewController = SFSafariViewController(url: $0)
                self.navigator.present(viewController)
            }
        }
    }

    // MARK: - Property

    private var refreshHandler: (() -> Void)?
    var disposeBag = DisposeBag()
}

// MARK: - View

extension  ArtistProfileViewCell: View {
    func bind(reactor: ArtistProfileViewCellReactor) {
        favoriteButton.rx.tapGesture()
            .when(.recognized)
            .do(onNext: { [unowned self] _ in
                (self.reactor?.currentState.isFavorited).map {
                    if $0 {
                        Tracker.shared.track(.unfavoriteArtist)
                    } else {
                        Tracker.shared.track(.favoriteArtist)
                    }
                }
            })
            .map { _ in .favorite }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .map { .back }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        readMoreButton.rx.tap
            .do(onNext: {
                Tracker.shared.track(.readMoreArtist)
            })
            .map { .readMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.artist.thumbnailUrl }
            .distinctUntilChanged()
            .filterNil()
            .bind(to: self.thumbnailImageView.rx.url)
            .disposed(by: disposeBag)

        reactor.state.map { $0.artist.name }
            .distinctUntilChanged()
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.artist.subscriberCount }
            .distinctUntilChanged()
            .map { "Subscribers \($0)" }
            .bind(to: self.subscribersLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.artist.description }
            .distinctUntilChanged()
            .bind(to: self.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isFavorited }
            .bind(to: favoriteButton.rx.isFavorite)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isBacked }
            .filterTrue()
            .bind(to: navigator.rx.pop)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isReadMore }
            .distinctUntilChanged()
            .map { $0 ? "隠す" : "続きを見る" }
            .bind(to: readMoreButton.rx.title())
            .disposed(by: disposeBag)

        reactor.state.map { $0.isReadMore }
            .distinctUntilChanged()
            .map { $0 ? 0 : 4 }
            .subscribe(onNext: {
                self.descriptionLabel.numberOfLines = $0
                self.refreshHandler?()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Injectable

extension ArtistProfileViewCell: Injectable {
    func inject(_ dependency: (reactor: ArtistProfileViewCellReactor, refreshHandler: (() -> Void)?)) {
        self.reactor = dependency.reactor
        self.refreshHandler = dependency.refreshHandler
    }
}
