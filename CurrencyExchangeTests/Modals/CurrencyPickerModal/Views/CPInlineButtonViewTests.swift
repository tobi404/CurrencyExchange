//
//  CPInlineButtonViewTests.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 06.10.22.
//

import XCTest
@testable import CEDomain
@testable import CurrencyExchange

final class CPInlineButtonViewTests: XCTestCase {

    var sut: CPInlineButtonView!

    override func setUp() {
        super.setUp()
        sut = CPInlineButtonView()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func test_ButtonWillExcludeCurrency() {
        // given
        weak var delegate: CurrencyPickerDelegate? = sut
        let currency = CurrencyEntity.eurEntity

        // when
        sut.excludeCurrencyFromPicker([currency])
        let excludedCurrencies = delegate?.excludedCurrencies()

        // then
        XCTAssertEqual([currency], excludedCurrencies)
    }

    func test_UpdateCurrencyMethodWillSetNewCurrency() {
        // given
        let currency = CurrencyEntity.jpyEntity

        // when
        sut.configure(with: currency)
        let currencyFromButton = sut.getCurrentCurrency()

        // then
        XCTAssertEqual(currency, currencyFromButton)
    }

}
