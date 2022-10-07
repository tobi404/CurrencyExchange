//
//  CEReactiveGradientButton.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 06.10.22.
//

import UIKit

final class CEReactiveGradientButton: UIButton {

    // MARK: - Button's lifecycle
    init(title: String) {
        super.init(frame: .zero)
        configure(title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        configureGradient()
    }

    // MARK: - Private Methods
    private func configure(_ title: String) {
        setTitle(title)
        setTitleColor(.white)
        clipsToBounds = true
    }

    private func configureGradient() {
        configureGradientBackground(colors: [UIColor(hex: "0885c6"), UIColor(hex: "019cde")], locations: [0.0, 1.0])
    }

}
