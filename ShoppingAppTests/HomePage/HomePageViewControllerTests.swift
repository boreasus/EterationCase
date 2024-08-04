//
//  HomePageViewControllerTests.swift
//  ShoppingAppTests
//
//  Created by safa uslu on 4.08.2024.
//

import XCTest
@testable import ShoppingApp

class HomePageViewControllerTests: XCTestCase {

    var viewController: HomePageViewController!
    var mockViewModel: MockHomePageViewModel!

    override func setUp() {
        super.setUp()
        mockViewModel = MockHomePageViewModel()
        viewController = HomePageViewController()
        viewController.viewModel = mockViewModel
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        super.tearDown()
    }

    func testViewDidLoadFetchesData() {
        XCTAssertTrue(mockViewModel.fetchProductCalled)
    }

    func testTextFieldDidChangeUpdatesProducts() {
        viewController.searchField.text = "Test"
        viewController.textFieldDidChange(viewController.searchField)

        XCTAssertTrue(mockViewModel.filterProductsCalled)
        XCTAssertEqual(mockViewModel.filterProductsSearchText, "Test")
        XCTAssertTrue(viewController.productsCollectionView.numberOfItems(inSection: 0) == mockViewModel.filteredProductes?.count)
    }

    func testHandleEmptyState() {
        mockViewModel.filteredProductes = []
        viewController.handleEmptyState()
        XCTAssertFalse(viewController.emptyStateLabel.isHidden)

        mockViewModel.filteredProductes = [ProductDto(id: "1", createdAt: "2024-08-02", name: "Product 1", image: "http://example.com/image1.png", price: "100.0", description: "Test Description", model: "Test Model", brand: "Test Brand", isFavorited: false)]
        viewController.handleEmptyState()
        XCTAssertTrue(viewController.emptyStateLabel.isHidden)
    }
}

// Mock ViewModel
class MockHomePageViewModel: HomePageViewModel {
    var fetchProductCalled = false
    var filterProductsCalled = false
    var filterProductsSearchText: String?
    
    override func fetchProduct(completion: @escaping () -> Void) {
        fetchProductCalled = true
        completion()
    }
    
    override func filterProducts(searchText: String) {
        filterProductsCalled = true
        filterProductsSearchText = searchText
    }
}
