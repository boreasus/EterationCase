//
//  BaseViewModel.swift
//  ShoppingApp
//
//  Created by safa uslu on 2.08.2024.
//

import Foundation
import CoreData

class BaseViewModel {
    let padding: CGFloat = 16
    let contentPadding: CGFloat = 14
    let appBarHeight: CGFloat = 49
    let appBarFontSize: CGFloat = 24
    var coreDataManager: CoreDataManagerProtocol

    
    init(coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
          self.coreDataManager = coreDataManager
      }

    
    func saveProduct(dto: ProductDto) {
        let context = CoreDataManager.shared.context
        let _ = Product(dto: dto, context: context)
        CoreDataManager.shared.saveContext()
        fetchLocalProducts().forEach { product in
            debugPrint(product)
        }
        postBasketUpdateNotification()
    }
    
    func fetchLocalProducts() -> [ProductDto] {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()

        do {
            let products = try context.fetch(fetchRequest)
            return products.map { $0.toDto() }
        } catch {
            debugPrint("Failed: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteProductById(id: String) {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let products = try context.fetch(fetchRequest)
            if let productToDelete = products.first {
                context.delete(productToDelete)
                CoreDataManager.shared.saveContext()
            }
        } catch {
            debugPrint("Fail: \(error.localizedDescription)")
        }
        postBasketUpdateNotification()
    }
    
    func postBasketUpdateNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(NotificationCenterStrings.basketUpdated), object: nil)
    }
}
