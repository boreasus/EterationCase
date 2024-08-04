//
//  FilterPageViewModel.swift
//  ShoppingApp
//
//  Created by safa uslu on 4.08.2024.
//

import Foundation

class FilterPageViewModel: BaseViewModel {
    var selectedSortType: SortType? 
    var brands: [SearchEntity]?
    var filteredBrands: [SearchEntity]?
    
    var models: [SearchEntity]?
    var filteredModels: [SearchEntity]?

    init(selectedSortType: SortType? = nil,
         brands: [SearchEntity]? = nil,
         models: [SearchEntity]? = nil) {
        self.selectedSortType = selectedSortType
        self.brands = brands
        filteredBrands = brands
        self.models = models
        filteredModels = models
    }
    
    func filterBrands(searchText: String) {
        guard let brands = brands else { return }
        if searchText.isEmpty {
            filteredBrands = brands
        } else {
            filteredBrands = brands.filter { brand in
                return brand.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func filterModels(searchText: String) {
        guard let models = models else { return }
        if searchText.isEmpty {
            filteredModels = models
        } else {
            filteredModels = models.filter { model in
                return model.title.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func updateBrandSelectionState(index: Int) {
        guard var filteredBrand = filteredBrands?[index] else { return }
        filteredBrand.isSelected.toggle()
        filteredBrands?[index] = filteredBrand
        if let mainIndex = brands?.firstIndex(where: { $0.id == filteredBrand.id }) {
            brands?[mainIndex].isSelected = filteredBrand.isSelected
        }
    }
    
    func updateModelSelectionState(index: Int) {
        guard var filteredModel = filteredModels?[index] else { return }
        filteredModel.isSelected.toggle()
        filteredModels?[index] = filteredModel
        if let mainIndex = models?.firstIndex(where: { $0.id == filteredModel.id }) {
            models?[mainIndex].isSelected = filteredModel.isSelected
        }
    }
    
    func getSelectedBrands() -> [SearchEntity]? {
        return brands?.filter { $0.isSelected }
    }
    
    func getSelectedModels() -> [SearchEntity]? {
        return models?.filter { $0.isSelected }
    }
}
