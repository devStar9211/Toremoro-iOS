//
//  SleepTimerViewController.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2019/02/10.
//  Copyright © 2019 toremoro, inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxAlertController
import ReusableKit
import ReactorKit

final class SleepTimerViewController: UIViewController {

    enum Reusable {
        static let selectionCell = ReusableCell<SleepTimerViewSelectionCell>(identifier: "selectionCell")
    }

    typealias DataSource = RxTableViewSectionedReloadDataSource<SleepTimerViewSection>

    // MARK: - Outlet

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
        }
    }

    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
        }
    }

    @IBOutlet private weak var cancelButton: UIButton!

    // MARK: - Property

    var disposeBag = DisposeBag()

    private lazy var dataSource: DataSource = {
        DataSource(configureCell: { _, tableView, indexPath, item -> UITableViewCell in
           let cell = tableView.dequeue(Reusable.selectionCell, for: indexPath, with: item)
            cell.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
            return cell
        })
    }()

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Tracker.shared.track(.sleepTimer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.frame
        view.insertSubview(visualEffectView, at: 0)
    }
}

// MARK: - UITableViewDelegate

extension SleepTimerViewController: UITableViewDelegate {}

// MARK: - StoryboardView

extension SleepTimerViewController: StoryboardView {
    func bind(reactor: SleepTimerViewReactor) {
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected(dataSource: dataSource)
            .do(onNext: {
                switch $0 {
                case ._15min: Tracker.shared.track(.sleepTimer15min)
                case ._30min: Tracker.shared.track(.sleepTimer30min)
                case ._45min: Tracker.shared.track(.sleepTimer45min)
                case ._1h: Tracker.shared.track(.sleepTimer1h)
                case ._2h: Tracker.shared.track(.sleepTimer2h)
                case .end: Tracker.shared.track(.sleepTimerUntilTheEnd)
                case .custom: Tracker.shared.track(.sleepTimerCustom)
                }
            })
            .flatMap { item -> Observable<SleepTimer.State> in
                if let state = item.sleepTimerState {
                    return .just(state)
                } else {
                    return UIAlertController.rx.show(
                        in: self,
                        title: "タイマー時間",
                        message: "分数を入力してください。",
                        buttons: [.cancel("キャンセル"), .default("決定")],
                        textFields: [ { (textfield: UITextField) -> Void in textfield.keyboardType = .numberPad } ]
                    )
                    .asObservable()
                    .filter { $0.0 == 1 }
                    .map { $0.1.first }
                    .filterNil()
                    .map { TimeInterval($0) }
                    .filterNil()
                    .filter { $0 > 0 && $0 < 9999 }
                    .map { SleepTimer.State(minutes: $0) }
                }
            }
            .do(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .bind(to: SleepTimer.shared.rx.set)
            .disposed(by: disposeBag)

        cancelButton.rx.tap
            .bind(to: rx.dismiss)
            .disposed(by: disposeBag)

        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - StoryboardInstantiatable

extension SleepTimerViewController: StoryboardInstantiatable {
    func inject(_ dependency: ()) {
        self.reactor = SleepTimerViewReactor()
    }
}
