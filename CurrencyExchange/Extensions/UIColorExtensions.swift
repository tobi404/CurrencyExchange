//
//  UIColorExtensions.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 05.10.22.
//

import UIKit

extension UIColor {
    convenience init(hex string: String, alpha: CGFloat = 1.0) {
        var hex = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }

        if hex.count < 3 {
            hex = "\(hex)\(hex)\(hex)"
        }

        if hex.range(of: "(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .regularExpression) != nil {
            if hex.count == 3 {

                let startIndex = hex.index(hex.startIndex, offsetBy: 1)
                let endIndex = hex.index(hex.startIndex, offsetBy: 2)

                let redHex = String(hex[..<startIndex])
                let greenHex = String(hex[startIndex..<endIndex])
                let blueHex = String(hex[endIndex...])

                hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
            }

            let startIndex = hex.index(hex.startIndex, offsetBy: 2)
            let endIndex = hex.index(hex.startIndex, offsetBy: 4)
            let redHex = String(hex[..<startIndex])
            let greenHex = String(hex[startIndex..<endIndex])
            let blueHex = String(hex[endIndex...])

            var redInt: CUnsignedLongLong = 0
            var greenInt: CUnsignedLongLong = 0
            var blueInt: CUnsignedLongLong = 0

            Scanner(string: redHex).scanHexInt64(&redInt)
            Scanner(string: greenHex).scanHexInt64(&greenInt)
            Scanner(string: blueHex).scanHexInt64(&blueInt)

            self.init(red: CGFloat(redInt) / 255.0,
                      green: CGFloat(greenInt) / 255.0,
                      blue: CGFloat(blueInt) / 255.0,
                      alpha: CGFloat(alpha))
        }
        else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }
}
