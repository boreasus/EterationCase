//
//  FilterPageViewModelTests.swift
//  ShoppingAppTests
//
//  Created by safa uslu on 4.08.2024.
//

import XCTest
@testable import ShoppingApp

class FilterPageViewModelTests: XCTestCase {

    var viewModel: FilterPageViewModel!
    var brands: [SearchEntity]!
    var models: [SearchEntity]!

    override func setUp() {
        super.setUp()
        brands = [
            SearchEntity(title: "Brand A", isSelected: false),
            SearchEntity(title: "Brand B", isSelected: false),
            SearchEntity(title: "Brand C", isSelected: false)
        ]
        models = [
            SearchEntity(title: "Model X", isSelected: false),
            SearchEntity(title: "Model Y", isSelected: false),
            SearchEntity(title: "Model Z", isSelected: false)
        ]
        viewModel = FilterPageViewModel(brands: brands, models: models)
    }

    override func tearDown() {
        viewModel = nil
        brands = nil
        models = nil
        super.tearDown()
    }

    func testFilterBrandsEmptySearchText() {
        viewModel.filterBrands(searchText: "")
        XCTAssertEqual(viewModel.filteredBrands?.count, 3)
    }

    func testFilterBrandsWithSearchText() {
        viewModel.filterBrands(searchText: "Brand A")
        XCTAssertEqual(viewModel.filteredBrands?.count, 1)
        XCTAssertEqual(viewModel.filteredBrands?.first?.title, "Brand A")
    }

    func testFilterModelsEmptySearchText() {
        viewModel.filterModels(searchText: "")
        XCTAssertEqual(viewModel.filteredModels?.count, 3)
    }

    func testFilterModelsWithSearchText() {
        viewModel.filterModels(searchText: "Model X")
        XCTAssertEqual(viewModel.filteredModels?.count, 1)
        XCTAssertEqual(viewModel.filteredModels?.first?.title, "Model X")
    }

    func testUpdateBrandSelectionState() {
        viewModel.updateBrandSelectionState(index: 0)
        XCTAssertTrue(viewModel.filteredBrands?[0].isSelected == true)
        XCTAssertTrue(viewModel.brands?[0].isSelected == true)

        viewModel.updateBrandSelectionState(index: 0)
        XCTAssertFalse(viewModel.filteredBrands?[0].isSelected == true)
        XCTAssertFalse(viewModel.brands?[0].isSelected == true)
    }

    func testUpdateModelSelectionState() {
        viewModel.updateModelSelectionState(index: 0)
        XCTAssertTrue(viewModel.filteredModels?[0].isSelected == true)
        XCTAssertTrue(viewModel.models?[0].isSelected == true)

        viewModel.updateModelSelectionState(index: 0)
        XCTAssertFalse(viewModel.filteredModels?[0].isSelected == true)
        XCTAssertFalse(viewModel.models?[0].isSelected == true)
    }

    func testGetSelectedBrands() {
        viewModel.updateBrandSelectionState(index: 0)
        let selectedBrands = viewModel.getSelectedBrands()
        XCTAssertEqual(selectedBrands?.count, 1)
        XCTAssertEqual(selectedBrands?.first?.title, "Brand A")
    }

    func testGetSelectedModels() {
        viewModel.updateModelSelectionState(index: 0)
        let selectedModels = viewModel.getSelectedModels()
        XCTAssertEqual(selectedModels?.count, 1)
        XCTAssertEqual(selectedModels?.first?.title, "Model X")
    }
}
