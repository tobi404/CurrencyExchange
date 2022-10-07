//
//  FormattersTests.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 06.10.22.
//

import XCTest
@testable import CurrencyExchange

final class FormattersTests: XCTestCase {

    var sut: NumberFormatter!

    override func setUp() {
        super.setUp()
        sut = Formatters.currencyFormatter
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_FromDecimalToStringFormatting() {
        // given
        let number: Decimal = 123.52334
        let output = "123.52"

        // when
        let numberString = sut.string(for: number)

        // then
        XCTAssertNotNil(numberString)
        XCTAssertEqual(output, numberString!)
    }

    func test_FromStringToDecimalFormating() {
        // given
        let numberString = "421.26"
        let output: NSNumber = 421.26

        // when
        let number = sut.number(from: numberString)

        // then
        XCTAssertNotNil(number)
        XCTAssertEqual(output, number)
    }
}
