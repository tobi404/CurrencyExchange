//
//  CENavigationController.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 05.10.22.
//

import UIKit
import SnapKit

final class CENavigationController: UINavigationController {

    // MARK: - Private Properties
    private let gradientView = UIView(frame: .zero)

    // MARK: - Controller's lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTransparentNavBar()
        configureConstraintLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureGradient()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - Private Properties
    private func configure() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = textAttributes

        view.addSubview(gradientView)
        view.bringSubviewToFront(navigationBar)
    }

    private func configureTransparentNavBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = .clear
        navigationBar.isTranslucent = true
    }

    private func configureGradient() {
        gradientView.configureGradientBackground(colors: [UIColor(hex: "0885c6"), UIColor(hex: "019cde")], locations: [0.0, 1.0])
    }

    private func configureConstraintLayout() {
        gradientView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(navigationBar)
        }
    }
}
