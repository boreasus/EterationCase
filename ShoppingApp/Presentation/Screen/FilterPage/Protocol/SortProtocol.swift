//
//  SortProtocol.swift
//  ShoppingApp
//
//  Created by safa uslu on 4.08.2024.
//

import Foundation

protocol FilterProtocol: AnyObject {
    func sort(type: SortType?)
    func filterBrand(brands: [SearchEntity]?)
    func filterModel(models: [SearchEntity]?)
}
