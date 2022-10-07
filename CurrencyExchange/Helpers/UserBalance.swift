//
//  UserBalance.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 04.10.22.
//

import Factory
import Foundation

final class UserBalance {

    // MARK: - Exposed Properties
    private(set) var availableBalances = [BalanceEntity]()

    // MARK: - Private Properties
    @Injected(Container.userBalanceUseCase)
    private var useCase: UserBalanceUseCaseInterface

    // MARK: - Lifecycle
    init() {
        getBalances()
    }

    // MARK: - Private Methods
    private func getBalances() {
        Task {
            do {
                self.availableBalances = try await useCase.getBalances()
            } catch let error as CEError {
                await Utilities.showAlert(title: "Service Unavailable", message: error.userMessage)
                print(error.debugMessage)
            }
        }
    }

    private func getBalanceForCurrency(currency: any Currency) -> BalanceEntity? {
        guard let firstIndex = availableBalances.firstIndex(where: {$0.currency.name == currency.name}) else { return nil }

        return availableBalances[firstIndex]
    }

    // MARK: - Exposed Methods
    func reloadData() {
        getBalances()
    }

    func getMaximumBalanceAmount(for currency: any Currency) -> Decimal {
        guard let balance = getBalanceForCurrency(currency: currency) else { return 0 }

        return balance.amount
    }

    func deductFunds(amount: Decimal, currency: any Currency) {
        guard let balance = getBalanceForCurrency(currency: currency) else { return }

        balance.updateAmount(balance.amount - amount)
    }

    func topUpFunds(amount: Decimal, currency: any Currency) {
        guard let balance = getBalanceForCurrency(currency: currency) else { return }

        balance.updateAmount(balance.amount + amount)
    }

}

// MARK: - Factory
extension Container {
    static let userBalance = Factory(scope: .cached) { UserBalance() }
}
