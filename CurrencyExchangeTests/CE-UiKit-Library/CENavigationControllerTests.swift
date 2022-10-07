//
//  CENavigationControllerTests.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 05.10.22.
//

import XCTest
@testable import CurrencyExchange

final class CENavigationControllerTests: XCTestCase {

    var sut: CENavigationController!

    override func setUp() {
        super.setUp()
        sut = CENavigationController(rootViewController: UIViewController())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_NavigationControllerHasTransparentNavBar() {
        // given
        let targetBarTintColor = UIColor.clear
        let isBarTranslucent = true

        // then
        XCTAssertEqual(targetBarTintColor, sut.navigationBar.barTintColor)
        XCTAssertEqual(isBarTranslucent, sut.navigationBar.isTranslucent)
        XCTAssertNotNil(sut.navigationBar.backgroundImage(for: .default))
        XCTAssertNotNil(sut.navigationBar.shadowImage)
    }

}
