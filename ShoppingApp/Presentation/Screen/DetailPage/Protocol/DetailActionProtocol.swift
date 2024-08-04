//
//  DetailActionProtocol.swift
//  ShoppingApp
//
//  Created by safa uslu on 4.08.2024.
//

import Foundation

protocol DetailActionProtocol: AnyObject {
    func addToBasket(product: ProductDto)
    func addToFavorite(product: ProductDto)
}
