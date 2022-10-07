//
//  UITableViewExtensions.swift
//  CurrencyExchange
//
//  Created by Beka Demuradze on 05.10.22.
//

import UIKit

extension UITableView {
    /// Set the tableHeaderView so that the required height can be determined automatically
    func setAndLayoutTableHeaderView(header: UIView) {
        self.tableHeaderView = header
        self.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
        header.setNeedsLayout()
        header.layoutIfNeeded()
        header.frame.size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.tableHeaderView = header
    }
}
