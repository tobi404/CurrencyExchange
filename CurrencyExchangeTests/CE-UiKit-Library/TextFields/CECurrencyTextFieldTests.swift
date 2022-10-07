//
//  CECurrencyTextFieldTests.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 06.10.22.
//

import XCTest
@testable import CurrencyExchange

final class CECurrencyTextFieldTests: XCTestCase {

    var sut: CECurrencyTextField!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CECurrencyTextField()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func test_SettingValuePropertyChangesTextFieldText_12_42() {
        // given
        let valueToSet: Decimal = 12.42
        let textFieldValue = "12.42"

        // when
        sut.value = valueToSet

        // then
        XCTAssertEqual(textFieldValue, sut.text)
    }

    func test_SettingMoreThenMaximumValueWillSetMaximumValue() {
        // given
        sut.configure(minValue: nil, maxValue: 42.41)
        let valueToSet: Decimal = 100
        let textFieldValue = "42.41"

        // when
        sut.value = valueToSet

        // then
        XCTAssertEqual(textFieldValue, sut.text)
    }

    func test_SettingLessThenMinimumValueWillSetMinimumValue() {
        // given
        sut.configure(minValue: 21.53, maxValue: nil)
        let valueToSet: Decimal = 10
        let textFieldValue = "21.53"

        // when
        sut.value = valueToSet

        // then
        XCTAssertEqual(textFieldValue, sut.text)
    }

}
