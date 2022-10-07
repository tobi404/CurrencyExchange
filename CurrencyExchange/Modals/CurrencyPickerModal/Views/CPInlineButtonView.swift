//
//  CPInlineButtonView.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 05.10.22.
//

import UIKit
import SnapKit
import Factory
import RxSwift
import RxRelay
import PanModal

final class CPInlineButtonView: UIView {

    // MARK: - Exposed Properties
    let pickedCurrencyPR = PublishRelay<CurrencyEntity>()

    // MARK: - Private Properties
    @Injected(Container.currencyPickerVM)
    private var viewModel: CurrencyPickerViewModel
    private var currentCurrency: CurrencyEntity?
    private var currenciesToExclude: [CurrencyEntity]?
    private var cachedCurrencies = [CurrencyEntity]()

    // MARK: - Views
    private let currencyNameLabel = UILabel(frame: .zero)
    private let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)))

    // MARK: - View's lifecycle
    init(currency: CurrencyEntity? = nil) {
        super.init(frame: .zero)
        configure(currency)
        configureConstraintLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func configure(_ currency: CurrencyEntity?) {
        self.currentCurrency = currency

        if let currency {
            updateLabel(currency: currency)
        }

        chevronImageView.tintColor = .label

        onTap(target: self, #selector(buttonDidTapped))

        addSubviews(currencyNameLabel, chevronImageView)
    }

    private func configureConstraintLayout() {
        currencyNameLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(chevronImageView.snp.left).offset(-4)
        }

        chevronImageView.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
    }

    private func updateLabel(currency: CurrencyEntity) {
        currencyNameLabel.text = currency.name
    }

    // MARK: - Exposed Methods
    func configure(with currency: CurrencyEntity) {
        self.currentCurrency = currency
        updateLabel(currency: currency)
    }

    func excludeCurrencyFromPicker(_ currency: [CurrencyEntity]?) {
        self.currenciesToExclude = currency
    }

    func getCurrentCurrency() -> CurrencyEntity? {
        currentCurrency
    }

    // MARK: - @objc Methods
    @objc private func buttonDidTapped() {
        Task {
            do {
                if cachedCurrencies.isEmpty {
                    cachedCurrencies = try await viewModel.getAvailableCurrencies()
                }

                let destination = CurrencyPickerModalController(delegate: self)
                parentViewController?.presentPanModal(destination)
            } catch let error as CEError {
                Utilities.showAlert(title: "Unidentified Error", message: error.userMessage)
            }
        }
    }

}

// MARK: - CurrencyPicker Delegate
extension CPInlineButtonView: CurrencyPickerDelegate {
    func didFinishSelectingCurrency(picker: CurrencyPickerModalController, currency: CurrencyEntity) {
        picker.dismiss(animated: true)
        
        guard currentCurrency != currency else { return }

        self.currentCurrency = currency
        updateLabel(currency: currency)
        pickedCurrencyPR.accept(currency)
    }

    func excludedCurrencies() -> [CurrencyEntity]? {
        currenciesToExclude
    }

    func prefetchedCurrencies() -> [CurrencyEntity] {
        cachedCurrencies
    }
}

