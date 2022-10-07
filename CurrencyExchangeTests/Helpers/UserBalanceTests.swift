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

    var sut: UserBalance!

    override func setUp() {
        super.setUp()
        Container.Registrations.push()
        Container.configureMocks()
        sut = UserBalance()
    }

    override func tearDown() {
        sut = nil
        Container.Registrations.pop()
        super.tearDown()
    }

    func test_BalanceFetchingImplementation() {
        XCTAssert(sut.availableBalances.isEmpty == false)
    }

}
