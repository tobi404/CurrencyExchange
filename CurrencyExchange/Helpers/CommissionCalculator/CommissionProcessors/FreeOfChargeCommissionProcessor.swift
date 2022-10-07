//
//  FreeOfChargeCommissionProcessor.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 04.10.22.
//

import Foundation

final class FreeOfChargeCommissionProcessor: CommissionProcessor {

    // MARK: - Properties
    var weight: Int { 10 }

    private var numberOfFreeConversions = 0

    // MARK: - Lifecycle
    init(numberOfFreeConversions: Int) {
        self.numberOfFreeConversions = numberOfFreeConversions
    }

    // MARK: - Exposed Methods
    func calculateComission(amount: Decimal) -> (continueCalculation: Bool, commission: Decimal?) {
        guard numberOfFreeConversions > 0 else { return (true, nil) }

        numberOfFreeConversions -= 1
        return (false, nil)
    }

    func calculateMaxConvertableAmount(for amount: Decimal) -> (continueCalculation: Bool, maxAmount: Decimal?) {
        (numberOfFreeConversions == 0, amount)
    }

}
