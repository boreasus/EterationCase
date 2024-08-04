//
//  MockCoreDataManager.swift
//  ShoppingAppTests
//
//  Created by safa uslu on 4.08.2024.
//

import XCTest
import CoreData
@testable import ShoppingApp


class MockCoreDataManager: CoreDataManagerProtocol {
    var mockContext: NSManagedObjectContext
    var saveProductCalled: (() -> Void)?
    var deleteProductByIdCalled: (() -> Void)?

    var context: NSManagedObjectContext {
        return mockContext
    }

    init(mockContext: NSManagedObjectContext) {
        self.mockContext = mockContext
    }

    func saveContext() {
        if mockContext.hasChanges {
            do {
                try mockContext.save()
                saveProductCalled?()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func saveProduct(dto: ProductDto) {
        // Simüle edilen saveProduct işlevi
        saveProductCalled?()
    }

    func deleteProductById(id: String) {
        // Simüle edilen deleteProductById işlevi
        deleteProductByIdCalled?()
    }
}
