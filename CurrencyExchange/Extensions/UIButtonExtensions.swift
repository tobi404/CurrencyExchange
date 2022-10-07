//
//  UIButtonExtensions.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 06.10.22.
//

import UIKit

extension UIButton {
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
        setTitle(title, for: .highlighted)
        setTitle(title, for: .disabled)
    }

    func setTitleColor(_ color: UIColor) {
        setTitleColor(color, for: .normal)
        setTitleColor(color, for: .highlighted)
        setTitleColor(color, for: .disabled)
    }
}
