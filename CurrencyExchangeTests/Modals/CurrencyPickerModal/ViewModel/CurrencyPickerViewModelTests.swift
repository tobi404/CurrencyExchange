//
//  CurrencyPickerViewModelTests.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 06.10.22.
//

import XCTest
@testable import CurrencyExchange

@MainActor
final class CurrencyPickerViewModelTests: XCTestCase {

    var sut: CurrencyPickerViewModel!

    override func setUp() {
        super.setUp()
        sut = CurrencyPickerViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_ConformsToTableViewDelegateProtocol() {
        XCTAssert(sut.conforms(to: UITableViewDelegate.self))
    }

    func test_CanConfigureTableViewsDataSource() {
        // given
        let tableView = UITableView(frame: .zero, style: .plain)

        // when
        sut.configureDataSource(tableView: tableView)

        // then
        XCTAssertNotNil(tableView.dataSource)
    }
    
}
