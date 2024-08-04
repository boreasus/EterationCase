//
//  BasketCellProtocol.swift
//  ShoppingApp
//
//  Created by safa uslu on 4.08.2024.
//

import Foundation

protocol BasketCellProtocol: AnyObject {
    func add(indexPath: IndexPath)
    func delete(indexPath: IndexPath)
}
