//
//  CCReceiveAmountLabel.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 06.10.22.
//

import UIKit

final class CCReceiveAmountLabel: CERestrictedUpdateLabel {

    // MARK: - View's lifecycle
    override init() {
        super.init()
        configure(for: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Exposed Methods
    func configure(for amount: Decimal) {
        guard let amountString = Formatters.currencyFormatter.string(for: amount) else { return }

        let valueIsPositive = amount > 0
        textColor = valueIsPositive ? .systemGreen : .label

        let textForUpdate = valueIsPositive ? "+ \(amountString)" : amountString

        updateText(newValue: textForUpdate)
    }

}
