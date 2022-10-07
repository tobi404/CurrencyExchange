//
//  CECurrencyTextField.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 05.10.22.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class CECurrencyTextField: UITextField {

    // MARK: - Properties
    let valueRS = ReplaySubject<Decimal>.create(bufferSize: 1)
    var value: Decimal = 0.00 {
        didSet {
            if value >= maximumValue {
                value = maximumValue
            } else {
                value = max(value, minimumValue)
            }

            valueRS.onNext(value)
        }
    }

    private var minimumValue: Decimal = 0.0
    private var maximumValue: Decimal = 9999.0
    private var localSeparator: Character = "."
    private let bag = DisposeBag()

    // MARK: - Views

    // MARK: - View's lifecycle
    init() {
        super.init(frame: .zero)
        configure()
        configureBinding()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func configure() {
        let locale = Locale.current

        if let separatorString = locale.decimalSeparator,
           let separatorChar = separatorString.first {
            localSeparator = separatorChar
        }

        textAlignment = .right
        keyboardType = .decimalPad
        placeholder = "0.00"
        delegate = self
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    private func configureBinding() {
        valueRS.map({ [weak self] value in
            guard let self = self,
                  self.value > 0.0,
                  let string = Formatters.currencyFormatter.string(for: value) else { return ""}

            return string
        }).bind(to: rx.text)
            .disposed(by: bag)

        rx.controlEvent([.editingDidBegin])
            .bind(onNext: { [weak self] _ in
                self?.text = ""
                self?.placeholder = ""
            })
            .disposed(by: bag)

        rx.controlEvent([.editingDidEnd])
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }

                self.placeholder = "0.00"
                
                if self.text?.isEmpty == false,
                   let userInput = self.text,
                   let number = Decimal(string: userInput.replacingOccurrences(of: "\(self.localSeparator)", with: ".")) {
                    self.value = number
                } else {
                    let oldValue = self.value
                    self.value = oldValue
                }
            })
            .disposed(by: bag)
    }

    func configure(minValue: Decimal?, maxValue: Decimal?) {
        self.minimumValue = minValue ?? 0
        self.maximumValue = maxValue ?? 9999

        if let maxValue, value > maxValue {
            value = maxValue
        }
    }

    func clear() {
        text = ""
        minimumValue = 0.0
        maximumValue = 9999.0
        value = 0
    }
}

// MARK: - UITextFieldDelegate
extension CECurrencyTextField: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // Initial checks to work further
        guard let textFieldHasDot = textField.text?.contains(localSeparator), string.isEmpty == false else { return true }

        // Prevent decimal separator placement if textfield is empty
        if string.contains(localSeparator) && textField.text?.isEmpty ?? true {
            return false
        }

        // Prevent placing second deciamal separator if textfield has one already
        if string.contains(localSeparator) && textFieldHasDot {
            return false
        }

        // Prevent more than 2 numbers after decimal separator
        if textFieldHasDot {
            guard let separatedString = textField.text?.split(separator: localSeparator),
                  separatedString.count > 1 else { return true }

            if separatedString.last!.count >= 2 {
                return false
            }
        }

        return true
    }
}
