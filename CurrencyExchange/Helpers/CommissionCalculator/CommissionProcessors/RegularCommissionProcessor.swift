//
//  RegularCommissionProcessor.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 04.10.22.
//

import Foundation

final class RegularCommissionProcessor: CommissionProcessor {

    // MARK: - Private Properties
    var weight: Int { 100 }

    private let rate: Decimal

    // MARK: - Lifecycle
    init(rate: Decimal) {
        self.rate = rate
    }

    // MARK: - Exposed Methods
    func calculateComission(amount: Decimal) -> (continueCalculation: Bool, commission: Decimal?) {
        let commission = (amount * rate) / 100

        return (true, commission)
    }

    func calculateMaxConvertableAmount(for amount: Decimal) -> (continueCalculation: Bool, maxAmount: Decimal?) {
        (true, ((amount * 100) / (100 + rate)))
    }

}
