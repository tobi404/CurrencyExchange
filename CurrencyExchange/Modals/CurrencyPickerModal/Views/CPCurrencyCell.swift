//
//  CPCurrencyCell.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 05.10.22.
//

import UIKit
import SnapKit
import CEDomain

final class CPCurrencyCell: UITableViewCell {

    // MARK: - Exposed Properties
    static let identifier = "CPCurrencyCell"

    // MARK: - Views
    private let currencyLabel = UILabel(frame: .zero)

    // MARK: - Cell's lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureConstraintLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func configure() {
        currencyLabel.textAlignment = .center
        currencyLabel.font = .systemFont(ofSize: 24, weight: .bold)

        addSubview(currencyLabel)
    }

    private func configureConstraintLayout() {
        currencyLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(with currency: CurrencyEntity) {
        currencyLabel.text = "\(currency.name) - \(currency.symbol)"
    }
}
