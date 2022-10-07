//
//  CommissionCalculator.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 04.10.22.
//

import Foundation

final class CommissionCalculator {

    // MARK: - Private Properties
    private var processors: [CommissionProcessor]

    // MARK: - Lifecycle
    init(processors: [CommissionProcessor]) {
        self.processors = processors.sorted(by: {$0.weight < $1.weight})
    }

    // MARK: - Exposed Methods
    /// The only accessor to get processors array. Useful at runtime to check calculator's behaviour
    /// - Returns: Processors Array
    func getProcessors() -> [CommissionProcessor] {
        processors
    }

    /// Add new processor at runtime
    /// For example: Checking user's account status (premium, gold etc), or it is applications anniversary day
    /// - Parameter newProcessor: Object that conforms to CommissionProcessor protocol
    func appendProcessor(newProcessor: any CommissionProcessor) {
        for i in 0..<processors.count {
            guard processors[i].weight > newProcessor.weight else { continue }

            processors.insert(newProcessor, at: i)
            break
        }
    }

    /// - Parameter amount: Amount of money to convert
    /// - Returns: Calculated commission rounded!
    func calculateComission(for amount: Decimal) -> Decimal {
        var overalCommission: Decimal = 0

        for processor in processors {
            let (shouldContinue, commission) = processor.calculateComission(amount: amount)

            guard shouldContinue else { break }

            if let commission {
                overalCommission += commission
            }
        }

        return overalCommission.rounded(2, .bankers)
    }

    /// - Parameter amount: desired amount to convert
    /// - Returns: maximum amount that can be converted, including the commission
    func calculateMaxConvertableAmountWithCommission(amount: Decimal) -> Decimal {
        var currentMaxAmount = amount

        for processor in processors {
            let (shouldContinue, maxAmount) = processor.calculateMaxConvertableAmount(for: currentMaxAmount)

            guard shouldContinue else { break }

            if let maxAmount {
                currentMaxAmount = maxAmount
            }
        }

        return currentMaxAmount
    }
}
