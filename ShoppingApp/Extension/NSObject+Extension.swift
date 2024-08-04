//
//  NSObject+Extension.swift
//  ShoppingApp
//
//  Created by safa uslu on 2.08.2024.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
