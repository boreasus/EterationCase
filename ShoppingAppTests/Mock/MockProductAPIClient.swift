//
//  MockProductAPIClient.swift
//  ShoppingAppTests
//
//  Created by safa uslu on 4.08.2024.
//

import Foundation
@testable import ShoppingApp

class MockProductAPIClient: ProductAPIClient {
    var result: Result<[ProductDto], Error>?
    
    override func fetchProducts(completion: @escaping (Result<[ProductDto], Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}
