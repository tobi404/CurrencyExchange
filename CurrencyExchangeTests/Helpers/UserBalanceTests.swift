//
//  UserBalanceTests.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 04.10.22.
//

import XCTest
import Factory
@testable import CEDomain
@testable import CurrencyExchange

final class UserBalanceTests: XCTestCase {

    fileprivate struct UseCaseMock: UserBalanceUseCaseInterface {
        func getBalances() async throws -> [CEDomain.BalanceEntity] {
            [
                CEDomain.BalanceEntity(amount: 123.42, currency: CurrencyEntity.usdEntity)
            ]
        }
    }

    var sut: UserBalance!

    override func setUp() async throws {
        try await super.setUp()
        Container.Registrations.push()
        Container.userBalanceUseCase.register(factory: { UseCaseMock() as UserBalanceUseCaseInterface })
        sut = UserBalance()
    }

    override func tearDown() {
        super.tearDown()
        Container.Registrations.pop()
        sut = nil
    }

    func test_GetBalanceAmountForUSDCurrency() {
        // given
        let outputAmount: Decimal = 123.42

        // when
        let amount = sut.getBalanceAmount(for: CurrencyEntity.usdEntity)

        // then
        XCTAssertEqual(outputAmount, amount)
    }

    func test_TopUpBalanceAmountForUSDCurrency() {
        // given
        let outputAmount: Decimal = 133.42

        // when
        sut.topUpFunds(amount: 10, currency: CurrencyEntity.usdEntity)
        let amount = sut.getBalanceAmount(for: CurrencyEntity.usdEntity)

        // then
        XCTAssertEqual(outputAmount, amount, accuracy: 0.01)
    }

    func test_ReduceBalanceAmountForUSDCurrency() {
        // given
        let outputAmount: Decimal = 113.42

        // when
        sut.deductFunds(amount: 10, currency: CurrencyEntity.usdEntity)
        let amount = sut.getBalanceAmount(for: CurrencyEntity.usdEntity)

        // then
        XCTAssertEqual(outputAmount, amount, accuracy: 0.01)
    }
}
