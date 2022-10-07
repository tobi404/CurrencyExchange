//
//  CurrencyConverterViewModelTests.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 06.10.22.
//

import XCTest
import Factory
@testable import CEDomain
@testable import CurrencyExchange

@MainActor
final class CurrencyConverterViewModelTests: XCTestCase {

    fileprivate struct UseCaseMock: CurrencyConverterUseCaseInterface {
        func getExchangedValue(amount: String, fromCurrency: CEDomain.CurrencyEntity, toCurrency: CEDomain.CurrencyEntity) async throws -> CEDomain.CurrencyExchangeResultEntity {
            CurrencyExchangeResultEntity(amount: "123.45", currency: toCurrency.name)
        }

        func getAvailableCurrencies() async throws -> [CEDomain.CurrencyEntity] {
            [CurrencyEntity.eurEntity, CurrencyEntity.usdEntity, CurrencyEntity.jpyEntity]
        }
    }

    var sut: CurrencyConverterViewModel!

    override func setUp() {
        super.setUp()
        Container.Registrations.push()
        Container.currencyConverterUseCase.register(factory: { UseCaseMock() as CurrencyConverterUseCaseInterface })
        sut = CurrencyConverterViewModel()
    }

    override func tearDown() {
        super.tearDown()
        Container.Registrations.pop()
        sut = nil
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
        let expectation = expectation(description: "Exchange Value")

        // when
        Task {
            let response = try? await sut.getExchangedValue(amount: 0.0, fromCurrency: CurrencyEntity.jpyEntity, toCurrency: CurrencyEntity.eurEntity)

            expectation.fulfill()

            // then
            XCTAssertEqual(response, toBeReceived)
        }

        waitForExpectations(timeout: 5)
    }

    func test_GetAvailableCurrencies() {
        // given
        let currenciesToBeReceived = [CurrencyEntity.eurEntity, CurrencyEntity.usdEntity, CurrencyEntity.jpyEntity]
        let expectation = expectation(description: "Available currencies")

        // when
        Task {
            let currencies = try? await sut.getAvailableCurrencies()

            expectation.fulfill()
            // then
            XCTAssertEqual(currenciesToBeReceived, currencies)
        }

        waitForExpectations(timeout: 5)
    }
}
