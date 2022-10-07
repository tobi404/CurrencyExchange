//
//  CERestrictedUpdateLabel.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 06.10.22.
//

import UIKit

class CERestrictedUpdateLabel: UILabel {

    // MARK: - Properties
    override var text: String? {
        willSet {
            guard let newValue,
                  newValue == lastSetTextFromMethod
            else {
                fatalError("text property can't be set from outside, use  appropriate method:")
            }
        }
    }

    // MARK: - Private Properties
    private var lastSetTextFromMethod: String = ""

    // MARK: - View's lifecycle
    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods
    internal func updateText(newValue: String) {
        lastSetTextFromMethod = newValue
        text = newValue
    }

}
