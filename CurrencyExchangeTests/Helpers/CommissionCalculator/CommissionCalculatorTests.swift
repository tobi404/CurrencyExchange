//
//  CommissionCalculatorTests.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 04.10.22.
//

import XCTest
@testable import CurrencyExchange

final class CommissionCalculatorTests: XCTestCase {

    var sut: CommissionCalculator!

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func test_CommissionCalculatorSortsProcessorsByWeight() {
        // given
        let processors: [CommissionProcessor] = [
            RegularCommissionProcessor(rate: 0.4),
            FreeOfChargeCommissionProcessor(numberOfFreeConversions: 2),
            FreeUntilAmountCommissionProcessor(freeUntilAmount: 100)
        ]
        sut = CommissionCalculator(processors: processors)
        let expectedOutput = processors.sorted(by: {$0.weight < $1.weight})

        // when
        let calculatorProcessors = sut.getProcessors()

        // then
        for i in 0..<calculatorProcessors.count {
            XCTAssertEqual(calculatorProcessors[i].weight, expectedOutput[i].weight)
        }
    }

    func test_AppendingNewProcessorToCommissionCalculator() {
        // given
        let newProcessor = FreeUntilAmountCommissionProcessor(freeUntilAmount: 100)
        var processors: [CommissionProcessor] = [
            RegularCommissionProcessor(rate: 0.4),
            FreeOfChargeCommissionProcessor(numberOfFreeConversions: 2)
        ]
        sut = CommissionCalculator(processors: processors)
        sut.appendProcessor(newProcessor: newProcessor)
        processors.append(newProcessor)
        let expectedOutput = processors.sorted(by: {$0.weight < $1.weight})

        // when
        let calculatorProcessors = sut.getProcessors()

        // then
        for i in 0..<calculatorProcessors.count {
            XCTAssertEqual(calculatorProcessors[i].weight, expectedOutput[i].weight)
        }
    }

    func test_CommissionCalculationWithNumberOfTries() {
        // given
        let amount: Decimal = 100
        let numberOfTries = 3
        sut = CommissionCalculator(processors: [
            FreeOfChargeCommissionProcessor(numberOfFreeConversions: numberOfTries),
            RegularCommissionProcessor(rate: 0.4)
        ])
        let expectedCommissionOutput: Decimal = 0.4

        // when
        for _ in 0..<numberOfTries {
            let commission = sut.calculateComission(for: amount)
            print(commission)
            XCTAssertEqual(commission, 0)
        }

        let chargedCommission = sut.calculateComission(for: amount)

        // then
        XCTAssertEqual(chargedCommission, expectedCommissionOutput)
    }

}
