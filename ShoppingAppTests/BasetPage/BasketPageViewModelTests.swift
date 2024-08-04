//
//  BasketPageViewModelTests.swift
//  ShoppingAppTests
//
//  Created by safa uslu on 4.08.2024.
//

import XCTest
@testable import ShoppingApp

class BasketPageViewModelTests: XCTestCase {

    var viewModel: BasketPageViewModel!

    override func setUp() {
        super.setUp()
        viewModel = BasketPageViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testMapProductsToBasketEntities() {
        let productDtos = [
            ProductDto(id: "1", createdAt: "2024-08-02", name: "Product 1", image: "http://example.com/image1.png", price: "100.0", description: "Test Description", model: "Test Model", brand: "Test Brand", isFavorited: false),
            ProductDto(id: "2", createdAt: "2024-08-02", name: "Product 1", image: "http://example.com/image1.png", price: "100.0", description: "Test Description", model: "Test Model", brand: "Test Brand", isFavorited: false),
            ProductDto(id: "3", createdAt: "2024-08-02", name: "Product 2", image: "http://example.com/image2.png", price: "200.0", description: "Test Description", model: "Test Model", brand: "Test Brand", isFavorited: false)
        ]

        let basketEntities = viewModel.mapProductsToBasketEntities(products: productDtos)

        XCTAssertEqual(basketEntities.count, 2)
        XCTAssertEqual(basketEntities[0].product.name, "Product 1")
        XCTAssertEqual(basketEntities[0].productCount, 2)
        XCTAssertEqual(basketEntities[1].product.name, "Product 2")
        XCTAssertEqual(basketEntities[1].productCount, 1)
    }

}
