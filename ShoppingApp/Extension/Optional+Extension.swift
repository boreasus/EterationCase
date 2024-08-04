//
//  Optional+Extension.swift
//  ShoppingApp
//
//  Created by safa uslu on 2.08.2024.
//

import Foundation

postfix operator ~

extension Optional where Wrapped == Int {
    static postfix func ~ (lhs: Int?) -> Int {
        return lhs ?? 0
    }
}

extension Optional where Wrapped == String {
    static postfix func ~ (lhs: String?) -> String {
        return lhs ?? ""
    }
}

extension Optional where Wrapped == Double {
    static postfix func ~ (lhs: Double?) -> Double {
        return lhs ?? 0.0
    }
}
