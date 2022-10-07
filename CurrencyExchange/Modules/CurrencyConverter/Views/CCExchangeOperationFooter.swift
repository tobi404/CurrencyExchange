//
//  CCExchangeOperationFooterView.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 05.10.22.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay
import Factory
import ProgressHUD

final class CCExchangeOperationFooterView: UICollectionReusableView {

    // MARK: - Exposed Properties
    static let identifier = "CCExchangeOperationFooterView"

    // MARK: - Private Properties
    @WeakLazyInjected(Container.currencyConverterVM)
    private var viewModel: CurrencyConverterViewModel?
    private var lastAmountInput: Decimal = 0
    private var cachedAmountInputCurrency: CurrencyEntity?
    private let bag = DisposeBag()

    // MARK: - Views
    private let titleLabel = UILabel(frame: .zero)
    private let currencyTextField = CECurrencyTextField()
    private let amountInputView = CCExchangeOperationView()
    private let receiveAmountLabel = CCReceiveAmountLabel()
    private let exchangeValueView = CCExchangeOperationView()
    private let convertationButton = CEReactiveGradientButton(title: "SUBMIT")

    // MARK: - View's lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureConstraintLayout()
        configureBinding()
        getData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func configure() {
        titleLabel.text = "CURRENCY EXCHANGE"
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .systemGray3

        let arrowUpIcon = UIImage(systemName: "arrow.up", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20, weight: .medium)))!
        amountInputView.reConfigure(icon: arrowUpIcon, iconBackgroundColor: .systemRed, title: "Sell", operationView: currencyTextField)

        let arrowDownIcon = UIImage(systemName: "arrow.down", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20, weight: .medium)))!
        exchangeValueView.reConfigure(icon: arrowDownIcon, iconBackgroundColor: .systemGreen, title: "Receive", operationView: receiveAmountLabel)

        convertationButton.addTarget(self, action: #selector(convertationButtonDidTapped), for: .touchUpInside)

        addSubviews(titleLabel, amountInputView, exchangeValueView, convertationButton)
    }

    private func configureConstraintLayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.right.equalToSuperview()
        }

        amountInputView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
        }

        exchangeValueView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(amountInputView.snp.bottom).offset(16)
        }

        convertationButton.snp.makeConstraints { make in
            make.top.equalTo(exchangeValueView.snp.bottom).offset(32)
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(32)
        }
    }

    private func configureBinding() {
        amountInputView.currencyPR
            .bind { [weak self] currency in
                guard let self else { return }
                self.amountInputCurrencyHasChanged(currency: currency)
                self.requestExchangedValue(for: self.lastAmountInput)
            }
            .disposed(by: bag)

        exchangeValueView.currencyPR
            .bind { [weak self] currency in
                guard let self else { return }
                self.requestExchangedValue(for: self.lastAmountInput)
            }
            .disposed(by: bag)

        currencyTextField.valueRS
            .bind { [weak self] amount in
                guard let self,
                      self.lastAmountInput != amount
                else { return }

                self.lastAmountInput = amount
                self.requestExchangedValue(for: amount)
            }
            .disposed(by: bag)

        currencyTextField.rx.controlEvent([.editingDidBegin])
            .map({"CHECK"})
            .bind(to: convertationButton.rx.title())
            .disposed(by: bag)

        currencyTextField.rx.controlEvent([.editingDidEnd])
            .map({"SUBMIT"})
            .bind(to: convertationButton.rx.title())
            .disposed(by: bag)
    }

    private func getData() {
        Task {
            do {
                let currencies = try await viewModel?.getAvailableCurrencies()

                guard let currencies,
                      currencies.count >= 2
                else { return }

                let fromCurrency = currencies[0]
                let toCurrency = currencies[1]

                amountInputView.setCurrency(currency: fromCurrency)
                cachedAmountInputCurrency = fromCurrency
                limitAmountInputBasedOnUsersBalance(currency: fromCurrency)
                exchangeValueView.excludeCurrency(currency: fromCurrency)
                exchangeValueView.setCurrency(currency: toCurrency)
            } catch let error as CEError {
                print(error.debugMessage)
            }
        }
    }

    private func amountInputCurrencyHasChanged(currency: CurrencyEntity) {
        defer { cachedAmountInputCurrency = currency }

        exchangeValueView.excludeCurrency(currency: currency)
        limitAmountInputBasedOnUsersBalance(currency: currency)

        guard let toCurrency = exchangeValueView.getCurrency(),
              currency == toCurrency,
              let cachedAmountInputCurrency
        else { return }

        exchangeValueView.setCurrency(currency: cachedAmountInputCurrency)
    }

    private func limitAmountInputBasedOnUsersBalance(currency: CurrencyEntity) {
        let balanceAmount = viewModel?.getBalanceMaxAmount(for: currency)
        currencyTextField.configure(minValue: 0, maxValue: balanceAmount)
    }

    private func requestExchangedValue(for amount: Decimal) {
        guard let fromCurrency = amountInputView.getCurrency(),
              let toCurrency = exchangeValueView.getCurrency()
        else { return }

        Task {
            ProgressHUD.show()

            do {
                guard let response = try await viewModel?.getExchangedValue(amount: amount, fromCurrency: fromCurrency, toCurrency: toCurrency) else { return }

                receiveAmountLabel.configure(for: response)
            } catch let error as CEError {
                print(error.debugMessage)
            }

            ProgressHUD.dismiss()
        }
    }

    // MARK: - Objc Methods
    @objc private func convertationButtonDidTapped() {
        guard let fromCurrency = amountInputView.getCurrency(),
              let toCurrency = exchangeValueView.getCurrency()
        else { return }

        viewModel?.initiateConvertation(for: lastAmountInput, fromCurrency: fromCurrency, toCurrency: toCurrency)

        limitAmountInputBasedOnUsersBalance(currency: fromCurrency)
    }
}
