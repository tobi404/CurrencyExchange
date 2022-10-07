//
//  CurrencyPickerDelegate.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 05.10.22.
//

import Foundation

protocol CurrencyPickerDelegate: AnyObject {
    func didFinishSelectingCurrency(picker: CurrencyPickerModalController, currency: CurrencyEntity)
    func excludedCurrencies() -> [CurrencyEntity]?
    func prefetchedCurrencies() -> [CurrencyEntity]
}

extension CurrencyPickerDelegate {
    func excludedCurrencies() -> [CurrencyEntity]? { nil }
}
