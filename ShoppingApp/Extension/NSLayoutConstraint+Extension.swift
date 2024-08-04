//
//  NSLayoutConstraint.swift
//  ShoppingApp
//
//  Created by safa uslu on 2.08.2024.
//

import UIKit

extension NSLayoutConstraint {
    func setPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

extension UILayoutPriority {
    
    static var mainlyrequired: UILayoutPriority {
        return UILayoutPriority(rawValue: 999)
    }
}
