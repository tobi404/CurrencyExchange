//
//  CurrencyConverterViewModelTests.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 06.10.22.
//

import XCTest
import Factory
@testable import CurrencyExchange

@MainActor
final class CurrencyConverterViewModelTests: XCTestCase {

    var sut: CurrencyConverterViewModel!

    override func setUp() {
        super.setUp()
        Container.Registrations.push()
        Container.configureMocks()
        sut = CurrencyConverterViewModel()
    }

    override func tearDown() {
        sut = nil
        Container.Registrations.pop()
        super.tearDown()
    }

    func test_ViewModelCanConfigureDataSource() {
        // given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: sut.collectionViewLayout())

        // when
        sut.configureDataSource(collectionView: collectionView)

        // then
        XCTAssertNotNil(collectionView.dataSource)
    }

    func test_GetExchangeRateMethodReturnsCurrentFormattingValue() {
        // given
        let toBeReceived: Decimal = 123.45

        // when
        Task {
            let response = try? await sut.getExchangedValue(amount: 0.0, fromCurrency: CurrencyEntity.jpyEntity, toCurrency: CurrencyEntity.eurEntity)

            // then
            XCTAssertEqual(response, toBeReceived)
        }
    }

    func test_GetAvailableCurrencies() {
        // given
        let currenciesToBeReceived = [CurrencyEntity.eurEntity, CurrencyEntity.usdEntity, CurrencyEntity.jpyEntity]

        // when
        Task {
            let currencies = try? await sut.getAvailableCurrencies()

            // then
            XCTAssertEqual(currenciesToBeReceived, currencies)
        }
    }
}
