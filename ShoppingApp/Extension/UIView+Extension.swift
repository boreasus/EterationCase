//
//  UIView+Extension.swift
//  ShoppingApp
//
//  Created by safa uslu on 2.08.2024.
//

import UIKit

extension UIView {
    func centerInParent() {
        
        guard let superview = self.superview else {
            return
        }
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
}
