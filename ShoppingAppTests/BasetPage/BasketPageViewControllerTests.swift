//
//  BasketPageViewControllerTests.swift
//  ShoppingAppTests
//
//  Created by safa uslu on 4.08.2024.
//

import Foundation

import XCTest
@testable import ShoppingApp

class BasketPageViewControllerTests: XCTestCase {

    var viewController: BasketPageViewController!
    var mockViewModel: MockBasketPageViewModel!

    override func setUp() {
        super.setUp()
        mockViewModel = MockBasketPageViewModel()
        viewController = BasketPageViewController()
        viewController.viewModel = mockViewModel
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        super.tearDown()
    }

    func testViewDidLoadConfiguresUI() {
        XCTAssertNotNil(viewController.productsCollectionView)
        XCTAssertNotNil(viewController.totalPriceActionsViewHolder)
        XCTAssertNotNil(viewController.emptyStateLabel)
    }

    func testViewWillAppearConfiguresViews() {
        viewController.viewWillAppear(false)
        XCTAssertTrue(mockViewModel.configureBasketCalled)
        XCTAssertEqual(viewController.totalPriceLabel.text, nil)
    }

    func testCollectionViewNumberOfItemsInSection() {
        let numberOfItems = viewController.collectionView(viewController.productsCollectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(numberOfItems, mockViewModel.products.count)
    }

    func testAddProductToBasket() {
        viewController.add(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertTrue(mockViewModel.addSameProductToBasketCalled)
        XCTAssertTrue(mockViewModel.configureBasketCalled)
    }

    func testDeleteProductFromBasket() {
        viewController.delete(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertTrue(mockViewModel.deleteProductFromBasketCalled)
        XCTAssertTrue(mockViewModel.configureBasketCalled)
    }
}

// Mock ViewModel
class MockBasketPageViewModel: BasketPageViewModel {
    var configureBasketCalled = false
    var calculateTotalPriceCalled = false
    var addSameProductToBasketCalled = false
    var deleteProductFromBasketCalled = false

    override func configureBasket() {
        configureBasketCalled = true
    }

    override func calculateTotalPrice() {
        calculateTotalPriceCalled = true
    }

    override func addSameProductToBasket(index: Int) {
        addSameProductToBasketCalled = true
    }

    override func deleteProductFromBasket(index: Int) {
        deleteProductFromBasketCalled = true
    }
}
