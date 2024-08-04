//
//  BasketPageViewModel.swift
//  ShoppingApp
//
//  Created by safa uslu on 4.08.2024.
//

import Foundation

class BasketPageViewModel: BaseViewModel {
    var products: [BasketEntity] = []
    var totalPrice: Double = 0
    
    override init(coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        super.init(coreDataManager: coreDataManager)
        configureBasket()
    }
    
    func mapProductsToBasketEntities(products: [ProductDto]) -> [BasketEntity] {
        let groupedProducts = Dictionary(grouping: products, by: { $0.name ?? "" })
        
        let sortedKeys = groupedProducts.keys.sorted(by: { $0 < $1 })
        
        let basketEntities = sortedKeys.compactMap { key -> BasketEntity? in
            guard let values = groupedProducts[key], let firstProduct = values.first else { return nil }
            let productCount = values.count
            return BasketEntity(product: firstProduct, productCount: productCount)
        }
        
        return basketEntities
    }
    
    func configureBasket() {
        products = mapProductsToBasketEntities(products: fetchLocalProducts())
    }
    
    func addSameProductToBasket(index: Int) {
        saveProduct(dto: products[index].product)
    }
    
    func deleteProductFromBasket(index: Int) {
        deleteProductById(id: products[index].product.id~)
    }
    
    func calculateTotalPrice() {
        totalPrice = 0
        fetchLocalProducts().forEach { product in
            totalPrice += Double(product.price~)~
        }
    }
}
