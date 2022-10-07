//
//  CurrencyEntityExtension.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 04.10.22.
//

@testable import CEDomain

extension CurrencyEntity {
    static var usdEntity: CurrencyEntity {
        CurrencyEntity(name: "USD", symbol: "$")
    }

    static var eurEntity: CurrencyEntity {
        CurrencyEntity(name: "EUR", symbol: "€")
    }

    static var jpyEntity: CurrencyEntity {
        CurrencyEntity(name: "JPY", symbol: "¥")
    }
}
