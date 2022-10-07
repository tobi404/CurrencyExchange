//
//  CurrencyPickerModalController.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 05.10.22.
//

import UIKit
import SnapKit
import Factory
import RxSwift
import PanModal
import ProgressHUD

final class CurrencyPickerModalController: CEViewController {

    // MARK: - Exposed Properties
    var isShortFormEnabled = true

    // MARK: - Private Properties
    @Injected(Container.currencyPickerVM)
    private var viewModel: CurrencyPickerViewModel
    private weak var delegate: CurrencyPickerDelegate!
    private let bag = DisposeBag()

    // MARK: - Views
    private let headerView = CPHeaderView()
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .insetGrouped)
        tw.showsVerticalScrollIndicator = false
        tw.register(CPCurrencyCell.self, forCellReuseIdentifier: CPCurrencyCell.identifier)
        tw.delegate = viewModel
        return tw
    }()

    // MARK: - VC's lifecycle
    init(delegate: CurrencyPickerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureConstraintLayout()
        configureBinding()
        configureData()
    }

    // MARK: - Methods
    private func configure() {
        view.addSubview(tableView)

        viewModel.configureDataSource(tableView: tableView)
    }

    private func configureConstraintLayout() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        tableView.setAndLayoutTableHeaderView(header: headerView)
    }

    private func configureBinding() {
        viewModel.selectedCurrencyPR
            .subscribe { [weak self] currency in
                guard let self else { return }

                self.delegate.didFinishSelectingCurrency(picker: self, currency: currency)
            }
            .disposed(by: bag)
    }

    private func configureData() {
        let prefetchedCurrencies = delegate.prefetchedCurrencies()

        if prefetchedCurrencies.isEmpty {
            getData()
        } else {
            viewModel.updateWithPrefetchedCurrencies(currencies: prefetchedCurrencies, excludedCurrencies: delegate.excludedCurrencies())
        }
    }

    private func getData() {
        Task {
            ProgressHUD.show()
            
            do {
                try await viewModel.updateWithAvailableCurrencies(excludedCurrencies: delegate.excludedCurrencies())
                
                panModalTransition(to: .longForm)
            } catch let error as CEError {
                print(error.debugMessage)
            }

            ProgressHUD.dismiss()
        }
    }
}

// MARK: - Pan Modal Presentable
extension CurrencyPickerModalController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        tableView
    }

    var shortFormHeight: PanModalHeight {
        isShortFormEnabled ? .contentHeight(300) : longFormHeight
    }

    var anchorModalToLongForm: Bool {
        false
    }

    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        let location = panModalGestureRecognizer.location(in: view)
        return headerView.frame.contains(location)
    }

    func willTransition(to state: PanModalPresentationController.PresentationState) {
        guard isShortFormEnabled,
              case .longForm = state
        else { return }

        isShortFormEnabled = false
        panModalSetNeedsLayoutUpdate()
    }
}
