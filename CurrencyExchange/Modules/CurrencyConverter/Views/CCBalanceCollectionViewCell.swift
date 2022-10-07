//
//  CCBalanceCollectionViewCell.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 05.10.22.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay
import CEDomain

final class CCBalanceCollectionViewCell: UICollectionViewCell {

    // MARK: - Exposed Properties
    static let identifier = "CCBalanceCollectionViewCell"

    // MARK: - Private Properties
    private var balanceEntity: BalanceEntity?
    private var bag = DisposeBag()

    // MARK: - Views
    private let balanceLabel = CEBalanceLabel()

    // MARK: - Cell's lifecycle
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
        contentView.addSubview(balanceLabel)
    }

    private func configureConstraintLayout() {
        balanceLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(with balance: BalanceEntity) {
        self.balanceEntity = balance
        balanceLabel.configure(for: balance)
    }
}
