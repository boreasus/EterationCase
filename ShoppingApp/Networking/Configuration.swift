//
//  Configuration.swift
//  ShoppingApp
//
//  Created by safa uslu on 2.08.2024.
//

import Foundation

struct Configurations {
    static let baseURL = "https://5fc9346b2af77700165ae514.mockapi.io"

    static var products: URL {
        return URL(string: "\(baseURL)/products/")!
    }
}
