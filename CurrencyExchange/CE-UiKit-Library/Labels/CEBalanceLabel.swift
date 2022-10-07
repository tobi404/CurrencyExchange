//
//  CEBalanceLabel.swift
//  CurrencyConverter
//
//  Created by Beka Demuradze on 04.10.22.
//

import UIKit

final class CEBalanceLabel: CERestrictedUpdateLabel {

    // MARK: - View's lifecycle
    override init() {
        super.init()
        initConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func initConfiguration() {
        font = .systemFont(ofSize: 20, weight: .medium)
    }

    // MARK: - Exposed Methods
    func configure(for amount: Decimal, currency: any Currency) {
        let amountString = Formatters.currencyFormatter.string(for: amount) ?? "0.00"
        let text = "\(amountString) \(currency.name)"
        updateText(newValue: text)
    }

    func configure(for balance: BalanceEntity) {
        let amountString = Formatters.currencyFormatter.string(for: balance.amount) ?? "0.00"
        let text = "\(amountString) \(balance.currency.name)"
        updateText(newValue: text)
    }

}

