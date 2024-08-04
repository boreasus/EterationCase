//
//  DetailPageViewModel.swift
//  ShoppingApp
//
//  Created by safa uslu on 4.08.2024.
//

import Foundation

class DetailPageViewModel: BaseViewModel {
    var product: ProductDto?
    
    init(product: ProductDto) {
        self.product = product
    }
}
