//
//  Product+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by safa uslu on 4.08.2024.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var id: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var name: String?
    @NSManaged public var image: String?
    @NSManaged public var price: String?
    @NSManaged public var model: String?
    @NSManaged public var pdescription: String?
    @NSManaged public var brand: String?
    @NSManaged public var isFavorited: Bool

}

extension Product : Identifiable {

}
