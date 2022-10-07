//
//  UIViewExtensions.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 05.10.22.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) { subviews.forEach { addSubview($0) } }

    /// Look up for responder chain and finds parent view controller
    /// Otherwise returns nil
    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }

    func configureGradientBackground(colors: [UIColor], locations: [CGFloat], startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint = CGPoint(x: 1.0, y: 0.0)) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = colors.map({$0.cgColor})
        gradient.locations = locations as [NSNumber]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = bounds

        if let previousGradientLayer = layer.sublayers?.first as? CAGradientLayer {
            previousGradientLayer.removeFromSuperlayer()
        }

        layer.insertSublayer(gradient, at: 0)
    }

    // MARK: - Tap Gesture
    /// Registers tap action via selector based syntax (closers are avoided intentionally).
    /// Method also returns view itself, so that action can be added within stack's result builders
    @discardableResult
    func onTap(target: Any, _ selector: Selector, cancelsTouches: Bool = false) -> Self {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target, action: selector)
        tap.cancelsTouchesInView = cancelsTouches
        addGestureRecognizer(tap)
        return self
    }

}
