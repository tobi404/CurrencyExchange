//
//  CPHeaderView.swift
//  CurrencyExchangeTests
//
//  Created by Beka Demuradze on 06.10.22.
//

import UIKit
import SnapKit

final class CPHeaderView: UIView {

    // MARK: - Properties

    // MARK: - Views
    private let titleLabel = UILabel(frame: .zero)

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
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 24, weight: .medium)
        titleLabel.text = "Pick a currency"

        addSubview(titleLabel)
    }

    private func configureConstraintLayout() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(24)
        }
    }

}

