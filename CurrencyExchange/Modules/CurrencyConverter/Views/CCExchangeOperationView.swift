//
//  CCExchangeOperationView.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 05.10.22.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

class CCExchangeOperationView: UIView {

    // MARK: - Properties
    let currencyPR = PublishRelay<CurrencyEntity>()

    // MARK: - Private Properties
    private let bag = DisposeBag()

    // MARK: - Views
    private let iconImageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let operationContainerView = UIView(frame: .zero)
    private let dividerView = CEDiviederView()
    private let currencyPickerButton = CPInlineButtonView()

    // MARK: - View's lifecycle
    init() {
        super.init(frame: .zero)
        configure()
        configureConstraintLayout()
        configureBinding()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
    }

    // MARK: - Private Methods
    private func configure() {
        iconImageView.tintColor = .white
        iconImageView.contentMode = .center

        addSubviews(iconImageView, titleLabel, operationContainerView, dividerView, currencyPickerButton)
    }

    private func configureConstraintLayout() {
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(1)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(16)
            make.right.lessThanOrEqualTo(operationContainerView.snp.left).offset(-16)
            make.centerY.equalTo(iconImageView)
        }

        operationContainerView.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.right.equalTo(currencyPickerButton.snp.left).offset(-24)
        }

        dividerView.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.left.equalTo(titleLabel)
        }

        currencyPickerButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.centerY.equalTo(iconImageView)
        }

        snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }

    private func configureBinding() {
        currencyPickerButton.pickedCurrencyPR
            .bind(to: currencyPR)
            .disposed(by: bag)
    }

    private func addOperationContainerSubView(view: UIView) {
        let containerAlreadyHasSubView = operationContainerView.subviews.count > 1

        if containerAlreadyHasSubView {
            operationContainerView.subviews.forEach({$0.removeFromSuperview()})
        }

        operationContainerView.addSubview(view)

        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Exposed Methods
    func reConfigure(icon: UIImage, iconBackgroundColor: UIColor, title: String, operationView: UIView) {
        iconImageView.image = icon
        iconImageView.backgroundColor = iconBackgroundColor
        titleLabel.text = title
        addOperationContainerSubView(view: operationView)
    }

    func excludeCurrency(currency: CurrencyEntity) {
        currencyPickerButton.excludeCurrencyFromPicker([currency])
    }

    func setCurrency(currency: CurrencyEntity) {
        currencyPickerButton.configure(with: currency)
    }

    func getCurrency() -> CurrencyEntity? {
        currencyPickerButton.getCurrentCurrency()
    }

}

