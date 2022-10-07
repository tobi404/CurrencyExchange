//
//  CurrencyExchangeViewModel.swift
//  CurrencyConverter
//
//  Created by Beka Demuradze on 04.10.22.
//

import UIKit
import Factory
import CEDomain

@MainActor
final class CurrencyConverterViewModel {
    typealias BalanceDataSource = UICollectionViewDiffableDataSource<Int, BalanceEntity>

    // MARK: - Private Properties
    @Injected(Container.userBalance)
    private var userBalance: UserBalance
    @Injected(Container.currencyConverterUseCase)
    private var useCase: CurrencyConverterUseCaseInterface
    private var dataSource: BalanceDataSource?
    private let commissionCalculator = CommissionCalculator(processors: [
        FreeOfChargeCommissionProcessor(numberOfFreeConversions: 5),
        RegularCommissionProcessor(rate: 0.7)])
    private var cachedPossibleConvertationValue: Decimal = 0.0

    // MARK: - Private Methods
    private func showInsufficientAmountAlert(amount: Decimal, commissionAmount: Decimal, fromCurrencySymbol: String) {
        let maxPossibleValue = commissionCalculator.calculateMaxConvertableAmountWithCommission(amount: amount)
        let formattedAmount = Formatters.currencyFormatter.string(for: amount)!
        let formattedMaxPossibleValue = Formatters.currencyFormatter.string(for: maxPossibleValue)!
        let formattedComission = Formatters.currencyFormatter.string(for: commissionAmount)!

        Utilities.showAlert(title: "Insufficient amount", message: "Convertation of \(formattedAmount) \(fromCurrencySymbol) including commission of \(formattedComission) \(fromCurrencySymbol) exceeds balance. Maximum convertable value is \(formattedMaxPossibleValue) \(fromCurrencySymbol)")
    }

    private func showSuccessMessage(amount: Decimal, commission: Decimal, fromCurrencyName: String, toCurrencyName: String) {
        let formattedAmount = Formatters.currencyFormatter.string(for: amount)!
        let formattedComission = Formatters.currencyFormatter.string(for: commission)!

        Utilities.showAlert(title: "Currency Converted", message: "You have converted \(formattedAmount) \(fromCurrencyName) to \(cachedPossibleConvertationValue) \(toCurrencyName). Commission Fee - \(formattedComission) \(fromCurrencyName).")
    }

    // MARK: - Exposed Methods
    func configureDataSource(collectionView: UICollectionView) {
        dataSource = BalanceDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CCBalanceCollectionViewCell.identifier, for: indexPath) as? CCBalanceCollectionViewCell else {  fatalError("Cell should be registered properly") }
            cell.configure(with: itemIdentifier)
            return cell
        }

        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch kind {
            case "header":
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CCTitleCollectionViewHeader.identifier, for: indexPath)
            case "footer":
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CCExchangeOperationFooterView.identifier, for: indexPath)
            default:
                return nil
            }
        }
    }

    func loadData() {
        guard var snapshot = dataSource?.snapshot() else { return }
        let balances = userBalance.availableBalances
        snapshot.appendSections([0])
        snapshot.appendItems(balances, toSection: 0)

        dataSource?.apply(snapshot)
    }

    func getBalanceMaxAmount(for currency: any Currency) -> Decimal {
        userBalance.getBalanceAmount(for: currency)
    }

    func getAvailableCurrencies() async throws -> [CurrencyEntity] {
        try await useCase.getAvailableCurrencies()
    }

    func getExchangedValue(amount: Decimal, fromCurrency: CurrencyEntity, toCurrency: CurrencyEntity) async throws -> Decimal {

        guard let amountString = Formatters.currencyFormatter.string(from: amount as NSNumber) else {
            throw CEError(userMessage: "Amount input is incorrect", debugMessage: "User input cant be converted")
        }

        let response = try await useCase.getExchangedValue(amount: amountString, fromCurrency: fromCurrency, toCurrency: toCurrency)

        guard response.currency == toCurrency.name else {
            throw CEError(userMessage: "Invalid request", debugMessage: "Sent and received currencies doesn't match")
        }

        cachedPossibleConvertationValue = response.amount

        return response.amount
    }

    func initiateConvertation(for amount: Decimal, fromCurrency: any Currency, toCurrency: any Currency) {
        guard cachedPossibleConvertationValue > 0 else {
            Utilities.showAlert(title: "Can't exchange", message: "Converted value must be more then 0.0 \(toCurrency.symbol)")
            return
        }

        let commissionAmount = commissionCalculator.calculateComission(for: amount)

        guard commissionAmount + amount <= getBalanceMaxAmount(for: fromCurrency) else {
            showInsufficientAmountAlert(amount: amount, commissionAmount: commissionAmount, fromCurrencySymbol: fromCurrency.symbol)
            return
        }

        userBalance.deductFunds(amount: amount + commissionAmount, currency: fromCurrency)
        userBalance.topUpFunds(amount: cachedPossibleConvertationValue, currency: toCurrency)

        // Show success message
        showSuccessMessage(amount: amount, commission: commissionAmount, fromCurrencyName: fromCurrency.name, toCurrencyName: toCurrency.name)

        if var snapshot = dataSource?.snapshot() {
            snapshot.reloadItems(userBalance.availableBalances)
            dataSource?.apply(snapshot)
        }
    }

}

// MARK: - Collection view layout
extension CurrencyConverterViewModel {
    func collectionViewLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(120))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        group.edgeSpacing = .init(leading: .some(.fixed(24)), top: .none, trailing: .none, bottom: .none)

        // Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        header.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)

        // Footer
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: "footer", alignment: .bottom)

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header, footer]

        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Factory
extension Container {
    @MainActor static let currencyConverterVM = Factory(scope: .shared) { CurrencyConverterViewModel() }
}
