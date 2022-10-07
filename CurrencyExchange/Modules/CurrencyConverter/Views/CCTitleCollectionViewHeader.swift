//
//  CCTitleCollectionViewHeader.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 05.10.22.
//

import UIKit
import SnapKit

final class CCTitleCollectionViewHeader: UICollectionReusableView {

    // MARK: - Exposed Properties
    static let identifier = "CCTitleCollectionViewHeader"

    // MARK: - Views
    private let titleLabel = UILabel(frame: .zero)

    // MARK: - View's lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureConstraintLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func configure() {
        addSubview(titleLabel)

        titleLabel.text = "MY BALANCES"
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .systemGray3
    }

    private func configureConstraintLayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.centerY.equalToSuperview()
        }
    }
}
