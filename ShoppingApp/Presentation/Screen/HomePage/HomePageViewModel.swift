//
//  HomePageViewModel.swift
//  ShoppingApp
//
//  Created by safa uslu on 2.08.2024.
//

import Foundation
import CoreData

class HomePageViewModel: BaseViewModel {
    private let apiClient: ProductAPIClient
    lazy var products: [ProductDto]? = []
    lazy var filteredProductes: [ProductDto]? = []
    lazy var error: Error? = nil
    var selectedBrands: [String] = []
    var selectedModels: [String] = []
    var selectedSoryType: SortType? = nil
    var searchText: String = ""

    init(apiClient: ProductAPIClient = ProductAPIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchProduct(completion: @escaping () -> Void) {
        apiClient.fetchProducts { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let dto):
                self.products?.append(contentsOf: dto.map({
                    ProductDto(id: $0.id,
                               createdAt: $0.createdAt,
                               name: $0.name,
                               image: $0.image,
                               price: $0.price,
                               description: $0.description,
                               model: $0.model,
                               brand: $0.brand,
                               isFavorited: false)
                }))
                self.filteredProductes = self.products
                completion()
            case .failure(let failure):
                error = failure
            }
        }
    }
    
    func applyFilters() {
           filteredProductes = products

           if !selectedBrands.isEmpty {
               filteredProductes = filteredProductes?.filter { product in
                   selectedBrands.contains(product.brand~)
               }
           }

           if !selectedModels.isEmpty {
               filteredProductes = filteredProductes?.filter { product in
                   selectedModels.contains(product.model~)
               }
           }

           if !searchText.isEmpty {
               filteredProductes = filteredProductes?.filter { product in
                   guard let name = product.name else { return false }
                   return name.lowercased().contains(searchText.lowercased())
               }
           }
       }

       func filterProducts(searchText: String) {
           self.searchText = searchText
           applyFilters()
       }

       func filterProductsByBrands(byBrands brands: [SearchEntity]?) {
           self.selectedBrands = brands?.map { $0.title } ?? []
           applyFilters()
       }

       func filterProductsByModels(byModels models: [SearchEntity]?) {
           self.selectedModels = models?.map { $0.title } ?? []
           applyFilters()
       }


    
    func updateFavoriteState(index: Int) {
        guard let filteredProduct = filteredProductes?[index],
            let productId = filteredProduct.id else { return }
        filteredProductes?[index].isFavorited?.toggle()
        if let mainIndex = products?.firstIndex(where: { $0.id == productId }) {
            products?[mainIndex].isFavorited = filteredProductes?[index].isFavorited
        }
    }
    
    func updateFavoriteState(for product: ProductDto) {
        guard let productId = product.id else { return }

        if let filteredIndex = filteredProductes?.firstIndex(where: { $0.id == productId }) {
            filteredProductes?[filteredIndex].isFavorited?.toggle()
        }

        if let mainIndex = products?.firstIndex(where: { $0.id == productId }) {
            products?[mainIndex].isFavorited = products?[mainIndex].isFavorited == true ? false : true
        }
    }
    
    func handleEmptyState() -> Bool {
        if let filteredProductes {
            return !filteredProductes.isEmpty
        }
        return false
    }
    
    func getAllBrandsAsSearchEntities() -> [SearchEntity] {
        guard let products = products else { return [] }
        var brandSet = Set<String>()
        for product in products {
            if let brand = product.brand {
                brandSet.insert(brand)
            }
        }

        let sortedBrands = brandSet.sorted()
        let searchEntities = sortedBrands.map { brand in
            SearchEntity(title: brand, isSelected: selectedBrands.contains(brand))
        }

        return searchEntities
    }

    func getAllModelsAsSearchEntities() -> [SearchEntity] {
        guard let products = products else { return [] }
        var modelSet = Set<String>()
        for product in products {
            if let model = product.model {
                modelSet.insert(model)
            }
        }

        let sortedModels = modelSet.sorted()
        let searchEntities = sortedModels.map { model in
            SearchEntity(title: model, isSelected: selectedModels.contains(model))
        }

        return searchEntities
    }

    
    func sortProducts(by sortType: SortType?) {
        selectedSoryType = sortType
        guard let sortType else { return }
        switch sortType {
        case .oldToNew:
            filteredProductes?.sort { ($0.createdAt~) < ($1.createdAt~) }
        case .newToOld:
            filteredProductes?.sort { ($0.createdAt~) > ($1.createdAt~) }
        case .priceAscending:
            filteredProductes?.sort { (Double($0.price~)~) < (Double($1.price~)~) }
        case .priceDescending:
            filteredProductes?.sort { (Double($0.price~)~) > (Double($1.price~)~) }
        }
    }
}
