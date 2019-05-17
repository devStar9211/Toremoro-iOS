//
//  SearchViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/03/06.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

final class SearchViewController: UIViewController {

    enum ContainerViewState {
        case top
        case popular
        case result
    }

    // MARK: - Outlet

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tapGesture: UITapGestureRecognizer!

    // MARK: - Property

    private weak var currentContainerViewController: UIViewController? {
        willSet {
            if let viewController = currentContainerViewController {
                viewController.willMove(toParentViewController: self)
                viewController.view.removeFromSuperview()
                viewController.removeFromParentViewController()
            }
        }
        didSet {
            if let viewController = currentContainerViewController {
                self.addChildViewController(viewController)
                viewController.view.frame = containerView.bounds
                containerView.addSubview(viewController.view)
                viewController.didMove(toParentViewController: self)
            }
        }
    }

    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.dimsBackgroundDuringPresentation = false
        search.searchBar.tintColor = .white
        search.searchBar.setImage(#imageLiteral(resourceName: "Search(expanded)"), for: .search, state: .normal)
        search.searchBar.placeholder = "アーティスト、ジャンルなど"
        search.searchBar.textField?.tintColor = .white
        search.searchBar.textField?.textColor = .white
        search.searchBar.textField?.backgroundView?.backgroundColor = .white
        search.searchBar.textField?.backgroundView?.alpha = 0.1
        search.searchBar.textField?.backgroundView?.layer.cornerRadius = 10
        search.searchBar.textField?.backgroundView?.clipsToBounds = true
        let textAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = textAttributes
        return search
    }()

    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.zPosition = 99999
        button.setTitle(" フィルター", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.backgroundColor = #colorLiteral(red: 0.2303106487, green: 0.2709953189, blue: 0.3020718694, alpha: 1)
        return button
    }()

    var disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Tracker.shared.track(.genres)
        Tracker.shared.track(.search)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.addSubview(filterButton)
        filterButton.topAnchor.constraint(equalTo: searchController.searchBar.topAnchor).isActive = true
        filterButton.bottomAnchor.constraint(equalTo: searchController.searchBar.bottomAnchor, constant: -8).isActive = true
        filterButton.rightAnchor.constraint(equalTo: searchController.searchBar.rightAnchor, constant: -16).isActive = true
    }
}

// MARK: - StoryboardView

extension SearchViewController: StoryboardView {
    func bind(reactor: SearchViewReactor) {
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.window?.endEditing(true)
            })
            .disposed(by: disposeBag)

        filterButton.rx.tap
            .map { [unowned self] in self.currentContainerViewController as? SearchResultViewController }
            .filterNil()
            .map { $0.reactor?.currentState.filter }
            .filterNil()
            .map { SearchFilterViewController(with: $0) }
            .bind(to: rx.presentPanModal)
            .disposed(by: disposeBag)

        searchController.searchBar.rx.text
            .filterNil()
            .map { .input($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchController.searchBar.rx.textDidBeginEditing
            .do(onNext: {
                Tracker.shared.track(.inputSearch)
            })
            .map { .beginEditing }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchController.searchBar.rx.textDidEndEditing
            .map { .endEditing }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchController.searchBar.rx.searchButtonClicked
            .do(onNext: {
                Tracker.shared.track(.doneSearch)
            })
            .map { .search }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchController.searchBar.rx.cancelButtonClicked
            .do(onNext: {
                Tracker.shared.track(.cancelSearch)
            })
            .map { .cancel }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.containerViewState }
            .distinctUntilChanged()
            .map { [unowned self] in
                switch $0 {
                case .top:
                    let viewController = SearchTopViewController(with: ())
                    return viewController
                case .popular:
                    let viewController = SearchPopularViewController(with: ())
                    viewController.didSelectSearchQuery
                        .do(onNext: { [weak self] in
                            self?.searchController.searchBar.text = $0
                        })
                        .map { .input($0) }
                        .bind(to: reactor.action)
                        .disposed(by: viewController.disposeBag)
                    return viewController
                case .result:
                    let query = reactor.currentState.query
                    let viewController = SearchResultViewController(with: query)
                    return viewController
                }
            }
            .subscribe(onNext: { [weak self] in
                self?.currentContainerViewController = $0
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.containerViewState }
            .map {
                switch $0 {
                case .top: return true
                case .popular: return true
                case .result: return false
                }
            }
            .do(onNext: { [unowned self] _ in
                self.searchController.searchBar.bringSubview(toFront: self.filterButton)
            })
            .bind(to: filterButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

// MARK: - StoryboardInstantiatable

extension SearchViewController: StoryboardInstantiatable {
    func inject(_ dependency: ()) {
        self.reactor = SearchViewReactor()
    }
}
