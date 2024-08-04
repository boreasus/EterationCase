//
//  CellFavoriteProtocol.swift
//  ShoppingApp
//
//  Created by safa uslu on 2.08.2024.
//

import Foundation

protocol ProductCellProtocol: AnyObject {
    func addFavorite(indexPath: IndexPath)
    func addBasket(indexPath: IndexPath)
}

