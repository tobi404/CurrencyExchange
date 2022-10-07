//
//  FreeUntilAmountCommissionProcessor.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 04.10.22.
//

import Foundation

final class FreeUntilAmountCommissionProcessor: CommissionProcessor {

    // MARK: - Private Properties
    var weight: Int { 0 }

    private var freeUntilAmount: Decimal = 0

    // MARK: - Lifecycle
    init(freeUntilAmount: Decimal) {
        self.freeUntilAmount = freeUntilAmount
    }

    // MARK: - Exposed Methods
    func calculateComission(amount: Decimal) -> (continueCalculation: Bool, commission: Decimal?) {
        (amount > freeUntilAmount, nil)
    }

    func calculateMaxConvertableAmount(for amount: Decimal) -> (continueCalculation: Bool, maxAmount: Decimal?) {
        (amount > freeUntilAmount, amount)
    }
}
