//
//  CEBalanceLabelTests.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 04.10.22.
//

import XCTest
@testable import CurrencyExchange

final class CEBalanceLabelTests: XCTestCase {

    var sut: CEBalanceLabel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CEBalanceLabel()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_InitialFontOfLabel_systemMedium24() {
        // given
        let targetFont = UIFont.systemFont(ofSize: 20, weight: .medium)

        // then
        XCTAssertEqual(targetFont, sut.font)
    }

    func test_ConfigureLabelsTextWithAmountAndCurrency_1224USD() {
        // given
        let balance: Decimal = 1224
        let formattedBalance = Formatters.currencyFormatter.string(for: balance) ?? "0.00"
        let currency = CurrencyEntity.usdEntity
        let output = "\(formattedBalance) \(currency.name)"

        // when
        sut.configure(for: balance, currency: currency)

        // then
        XCTAssertNotNil(sut.text)
        XCTAssertEqual(sut.text, output)
    }

    func test_ConfigureLabelsTextWithBalanceEntity_432_25EUR() {
        // given
        let currency = CurrencyEntity.eurEntity
        let balanceEntity = BalanceEntity(amount: 432.25, currency: currency)
        let output = "\(balanceEntity.amount) \(balanceEntity.currency.name)"

        // when
        sut.configure(for: balanceEntity)

        // then
        XCTAssertNotNil(sut.text)
        XCTAssertEqual(sut.text, output)
    }

}
