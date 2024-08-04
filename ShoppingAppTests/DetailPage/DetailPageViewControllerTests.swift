//
//  DetailPageViewControllerTests.swift
//  ShoppingAppTests
//
//  Created by safa uslu on 4.08.2024.
//

import XCTest
@testable import ShoppingApp

class DetailPageViewControllerTests: XCTestCase {

    var viewController: DetailPageViewController!
    var mockDelegate: MockDetailActionProtocol!
    var viewModel: DetailPageViewModel!

    override func setUp() {
        super.setUp()
        
        let product = ProductDto(id: "1", createdAt: "2024-08-04", name: "Test Product", image: "http://example.com/image.png", price: "100.0", description: "Test Description", model: "Test Model", brand: "Test Brand", isFavorited: false)
        viewModel = DetailPageViewModel(product: product)
        mockDelegate = MockDetailActionProtocol()
        viewController = DetailPageViewController(viewModel: viewModel)
        viewController.delegate = mockDelegate
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        mockDelegate = nil
        viewModel = nil
        super.tearDown()
    }

    func testDidTapFavIcon() {
        viewController.didTapFavIcon()
        XCTAssertTrue(mockDelegate.addToFavoriteCalled)
        XCTAssertTrue(viewModel.product!.isFavorited!)
        XCTAssertEqual(viewModel.product!.isFavorited, true)
    }

    func testDidTapAddBasket() {
        viewController.didTapAddBasket()
        XCTAssertTrue(mockDelegate.addToBasketCalled)
    }

    func testFavIconColorConfiguration() {
        // Initially not favorited
        viewController.configureFavIcon(product: viewModel.product!)
        XCTAssertEqual(viewController.favoriteIcon.tintColor, UIColor.gray)

        // Toggle to favorited
        viewModel.product!.isFavorited = true
        viewController.configureFavIcon(product: viewModel.product!)
        XCTAssertEqual(viewController.favoriteIcon.tintColor, AppColors.appYellow)
    }

    func testProductDetailsAreDisplayed() {
        XCTAssertEqual(viewController.titleLabel.text, viewModel.product!.name)
        XCTAssertEqual(viewController.descriptionLabel.text, viewModel.product!.description)
        XCTAssertEqual(viewController.totalPriceLabel.text, "\(viewModel.product!.price!) ₺")
    }
}

class MockDetailActionProtocol: DetailActionProtocol {
    var addToFavoriteCalled = false
    var addToBasketCalled = false

    func addToFavorite(product: ProductDto) {
        addToFavoriteCalled = true
    }

    func addToBasket(product: ProductDto) {
        addToBasketCalled = true
    }
}
