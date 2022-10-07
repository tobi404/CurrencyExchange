//
//  Utilities.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 06.10.22.
//

import UIKit

@MainActor
final class Utilities {

    fileprivate static var window: UIWindow? = {
        UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    }()

    static func showAlert(title: String, message: String, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
        window?.rootViewController?.present(alert, animated: true)
    }

}
