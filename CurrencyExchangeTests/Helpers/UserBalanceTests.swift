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

    override func setUp() {
        super.setUp()
        Container.Registrations.push()
        Container.userBalanceUseCase.register(factory: { UseCaseMock() as UserBalanceUseCaseInterface })
        sut = UserBalance()
    }

    override func tearDown() {
        super.tearDown()
        Container.Registrations.pop()
        sut = nil
    }

}
