//
//  CommissionProcessorTests.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 04.10.22.
//

import XCTest
@testable import CurrencyExchange

final class CommissionProcessorTests: XCTestCase {

    var sut: CommissionProcessor!

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_FreeOfChargeCommissionProcessor_InteruptsFlowAndCommissionIsNil() {
        // given
        let amount: Decimal = 1000
        let numberOfFreeConversions = 5
        sut = FreeOfChargeCommissionProcessor(numberOfFreeConversions: numberOfFreeConversions)

        // when
        let (shouldContinue, commission) = sut.calculateComission(amount: amount)

        // then
        XCTAssert(shouldContinue == false)
        XCTAssertNil(commission)
    }

    func test_FreeOfChargeCommissionProcessor_NotInteruptsFlowAndCommissionIsNil() {
        // given
        let amount: Decimal = 1000
        let numberOfFreeConversions = 0
        sut = FreeOfChargeCommissionProcessor(numberOfFreeConversions: numberOfFreeConversions)

        // when
        let (shouldContinue, commission) = sut.calculateComission(amount: amount)

        // then
        XCTAssert(shouldContinue == true)
        XCTAssertNil(commission)
    }


    func test_FreeUntilAmountCommissionProcessor_InteruptsFlowAndCommissionIsNil() {
        // given
        let amount: Decimal = 100
        let freeUntilAmount: Decimal = 200
        sut = FreeUntilAmountCommissionProcessor(freeUntilAmount: freeUntilAmount)

        // when
        let (shouldContinue, commission) = sut.calculateComission(amount: amount)

        // then
        XCTAssert(shouldContinue == false)
        XCTAssertNil(commission)
    }

    func test_FreeUntilAmountCommissionProcessorNotInteruptsFlowAndCommissionIsNil() {
        // given
        let amount: Decimal = 300
        let freeUntilAmount: Decimal = 200
        sut = FreeUntilAmountCommissionProcessor(freeUntilAmount: freeUntilAmount)

        // when
        let (shouldContinue, commission) = sut.calculateComission(amount: amount)

        // then
        XCTAssert(shouldContinue == true)
        XCTAssertNil(commission)
    }


    func test_RegularCommissionProcessorCalculationAndNotInterupt_WithCommissionResult0_07() {
        // given
        let amount: Decimal = 100
        let rate: Decimal = 0.7
        sut = RegularCommissionProcessor(rate: rate)
        let expectedOutput: Decimal = 0.7

        // when
        let (shouldContinue, commission) = sut.calculateComission(amount: amount)

        // then
        XCTAssert(shouldContinue == true)
        XCTAssertEqual(expectedOutput, commission)
    }

    func test_RegularCommissionProcessorMaxConvertableValueCalculationAndNotInterupt() {
        // given
        let amount: Decimal = 100
        let rate: Decimal = 0.7
        sut = RegularCommissionProcessor(rate: rate)
        let expectedOutput: Decimal = ((amount * 100) / (100 + rate))

        // when
        let (shouldContinue, maxAmount) = sut.calculateMaxConvertableAmount(for: amount)

        // then
        XCTAssert(shouldContinue == true)
        XCTAssertEqual(expectedOutput, maxAmount)
    }
}
