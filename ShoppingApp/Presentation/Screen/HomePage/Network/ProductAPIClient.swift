//
//  ProductAPIClient.swift
//  ShoppingApp
//
//  Created by safa uslu on 2.08.2024.
//

import Foundation

class ProductAPIClient {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchProducts(completion: @escaping (Result<[ProductDto], Error>) -> Void) {
        let url = Configurations.products

        networkService.fetch(url: url) { (result: Result<[ProductDto], Error>) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
