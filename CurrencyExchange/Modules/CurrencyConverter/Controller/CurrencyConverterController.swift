//
//  CurrencyConverterController.swift
//  CurrencyConverter
//
//  Created by Beka Demuradze on 04.10.22.
//

import UIKit
import SnapKit
import Factory

final class CurrencyConverterController: CEViewController {

    // MARK: - Private Properties
    @Injected(Container.currencyConverterVM)
    private var viewModel: CurrencyConverterViewModel

    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let cw = UICollectionView(frame: .zero, collectionViewLayout: viewModel.collectionViewLayout())
        cw.translatesAutoresizingMaskIntoConstraints = false
        cw.showsVerticalScrollIndicator = false
        cw.contentInset.top = 20
        cw.register(CCBalanceCollectionViewCell.self, forCellWithReuseIdentifier: CCBalanceCollectionViewCell.identifier)
        cw.register(CCTitleCollectionViewHeader.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: CCTitleCollectionViewHeader.identifier)
        cw.register(CCExchangeOperationFooterView.self, forSupplementaryViewOfKind: "footer", withReuseIdentifier: CCExchangeOperationFooterView.identifier)
        return cw
    }()

    // MARK: - VC's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureConstraintLayout()
        loadData()
    }

    // MARK: - Private Methods
    private func configure() {
        title = "Currency converter"
        registerDismissTapGesture()

        view.addSubview(collectionView)

        viewModel.configureDataSource(collectionView: collectionView)
    }

    private func configureConstraintLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }

    private func loadData() {
        viewModel.loadData()
    }

}

