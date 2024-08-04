//
//  DetailPageViewModelTests.swift
//  ShoppingAppTests
//
//  Created by safa uslu on 4.08.2024.
//

import XCTest
@testable import ShoppingApp

class DetailPageViewModelTests: XCTestCase {

    var viewModel: DetailPageViewModel!
    var productDto: ProductDto!

    override func setUp() {
        super.setUp()
        productDto = ProductDto(id: "1", createdAt: "2024-08-02", name: "Test Product", image: "http://example.com/image.png", price: "100.0", description: "Test Description", model: "Test Model", brand: "Test Brand", isFavorited: false)
        viewModel = DetailPageViewModel(product: productDto)
    }

    override func tearDown() {
        viewModel = nil
        productDto = nil
        super.tearDown()
    }

    func testInitialization() {
        XCTAssertNotNil(viewModel.product)
    }
}
