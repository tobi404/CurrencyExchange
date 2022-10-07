//
//  UIViewControllerExtension.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 05.10.22.
//

import UIKit

extension UIViewController {
    /// Shorthand extension method to easily wrappe any UIViewController into CENavigationController
    func wrappedInCENavigationController() -> UINavigationController {
        CENavigationController(rootViewController: self)
    }

    // MARK: - Tap to dismiss keyboard gesture
    internal func registerDismissTapGesture(cancelsTouchesInView: Bool = false) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = cancelsTouchesInView
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard(sender: UIGestureRecognizer) {
        sender.view?.endEditing(true)
    }
}
