//
//  Product+Extension.swift
//  ShoppingApp
//
//  Created by safa uslu on 4.08.2024.
//

import CoreData

extension Product {
    convenience init(dto: ProductDto, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = dto.id
        self.createdAt = dto.createdAt
        self.name = dto.name
        self.image = dto.image
        self.price = dto.price
        self.pdescription = dto.description
        self.model = dto.model
        self.brand = dto.brand
        self.isFavorited = dto.isFavorited ?? false
    }

    func toDto() -> ProductDto {
        return ProductDto(id: id,
                          createdAt: createdAt,
                          name: name,
                          image: image,
                          price: price,
                          description: pdescription,
                          model: model,
                          brand: brand,
                          isFavorited: isFavorited)
    }
}
