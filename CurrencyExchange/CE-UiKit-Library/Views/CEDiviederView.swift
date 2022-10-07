//
//  CEDiviederView.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 05.10.22.
//

import UIKit
import SnapKit

final class CEDiviederView: UIView {

    // MARK: - Properties

    // MARK: - Views

    // MARK: - View's lifecycle
    init() {
        super.init(frame: .zero)
        configure()
        configureConstraintLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func configure() {
        backgroundColor = .systemGray5
    }

    private func configureConstraintLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }

}

