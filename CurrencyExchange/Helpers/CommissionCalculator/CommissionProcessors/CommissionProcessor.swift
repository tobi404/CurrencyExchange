//
//  CommissionProcessor.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 04.10.22.
//

import Foundation

/// CommissionProcessor protocol should be adopted by an object, which will be a part of commission calculation process
/// Each processor will be placed within an array and sorted as per their weight.
/// Processor that must be considered earlier than others should have lower weight value.
/// Processor can calculate commission, and calculate maximum amount that can be converted including the commission.
protocol CommissionProcessor {
    var weight: Int { get }

    /// This method will be called every time commission calculation takes place.
    /// Method can be used with custom logic that determines if commission calculation should continue or not, or it can be used to calculate commission value solely.
    /// - Parameter amount: value to calculate commission for
    /// - Returns: If method was responsible on commission calculation, return commission value, otherwise return nil. If calculation process can be continued after this method, return true otherwise false.
    func calculateComission(amount: Decimal) -> (continueCalculation: Bool, commission: Decimal?)


    /// This method is used to calculate maximum value that can be converted, including the commission value.
    /// - Parameter amount: desired amount to convert
    /// - Returns: If processor is responsible for commission calculation, return the maximum amount which includes commission as well. Return true if calculation should be continued, otherwise false.
    func calculateMaxConvertableAmount(for amount: Decimal) -> (continueCalculation: Bool, maxAmount: Decimal?)
}
