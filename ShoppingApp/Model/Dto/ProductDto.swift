//
//  ProductDto.swift
//  ShoppingApp
//
//  Created by safa uslu on 2.08.2024.
//

import Foundation

struct ProductDto: Codable {
    let id: String?
    let createdAt: String?
    let name: String?
    let image: String?
    let price: String?
    let description: String?
    let model: String?
    let brand: String?
    var isFavorited: Bool? = false
}
