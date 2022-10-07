//
//  CurrencyPickerViewModel.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 05.10.22.
//

import UIKit
import RxSwift
import RxRelay
import Factory

@MainActor
final class CurrencyPickerViewModel: NSObject {

    typealias CurrencyPickerTableViewDataSource = UITableViewDiffableDataSource<Int, CurrencyEntity>

    // MARK: - Exposed Properties
    let selectedCurrencyPR = PublishRelay<CurrencyEntity>()

    // MARK: - Private Properties
    @Injected(Container.currencyConverterUseCase)
    private var useCase: CurrencyConverterUseCaseInterface
    private var dataSource: CurrencyPickerTableViewDataSource?

    // MARK: - Exposed Methods
    func configureDataSource(tableView: UITableView) {
        dataSource = CurrencyPickerTableViewDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CPCurrencyCell.identifier, for: indexPath) as? CPCurrencyCell else { return nil }
            cell.configure(with: itemIdentifier)
            return cell
        }

        var snapshot = dataSource?.snapshot()
        snapshot?.appendSections([0])
        dataSource?.apply(snapshot!)
    }

    func getAvailableCurrencies() async throws -> [CurrencyEntity] {
        try await useCase.getAvailableCurrencies()
    }

    func updateWithPrefetchedCurrencies(currencies: [CurrencyEntity], excludedCurrencies: [CurrencyEntity]?) {
        guard var snapshot = dataSource?.snapshot() else { return }

        var mutableCurrencies = currencies

        if let excludedCurrencies {
            mutableCurrencies.removeAll(where: { excludedCurrencies.contains($0) })
        }

        snapshot.appendItems(mutableCurrencies)

        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func updateWithAvailableCurrencies(excludedCurrencies: [CurrencyEntity]?) async throws {
        guard var snapshot = dataSource?.snapshot() else { return }

        var currencies = try await getAvailableCurrencies()

        if let excludedCurrencies {
            currencies.removeAll(where: { excludedCurrencies.contains($0) })
        }

        snapshot.appendItems(currencies)
        
        await dataSource?.apply(snapshot)
    }
}

// MARK: - Table View Delegate
extension CurrencyPickerViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currency = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        selectedCurrencyPR.accept(currency)
    }
}

// MARK: - Factory
extension Container {
    @MainActor static let currencyPickerVM = Factory { CurrencyPickerViewModel() }
}
