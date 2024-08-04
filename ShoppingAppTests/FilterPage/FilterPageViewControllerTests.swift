//
//  FilterPageViewControllerTests.swift
//  ShoppingAppTests
//
//  Created by safa uslu on 4.08.2024.
//

import XCTest
@testable import ShoppingApp

class FilterPageViewControllerTests: XCTestCase {

    var viewController: FilterPageViewController!
    var mockDelegate: MockFilterProtocol!

    override func setUp() {
        super.setUp()
        let viewModel = FilterPageViewModel()
        mockDelegate = MockFilterProtocol()
        viewController = FilterPageViewController(viewModel: viewModel)
        viewController.delegate = mockDelegate
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        mockDelegate = nil
        super.tearDown()
    }

    func testDidTapLeadingIconDismissesViewController() {
        viewController.didTapLeadingIcon()
    }

    func testRadioButtonSelection() {
        viewController.didTapRadioButtonOldToNew()
        XCTAssertEqual(viewController.viewModel.selectedSortType, .oldToNew)

        viewController.didTapRadioButtonNewToOld()
        XCTAssertEqual(viewController.viewModel.selectedSortType, .newToOld)

        viewController.didTapRadioButtonAscending()
        XCTAssertEqual(viewController.viewModel.selectedSortType, .priceAscending)

        viewController.didTapRadioButtonDescending()
        XCTAssertEqual(viewController.viewModel.selectedSortType, .priceDescending)
    }

    func testBrandTextFieldDidChange() {
        let textField = UITextField()
        textField.text = "New Brand"
        viewController.brandTextFieldDidChange(textField)
    }

    func testModelTextFieldDidChange() {
        let textField = UITextField()
        textField.text = "New Model"
        viewController.modelTextFieldDidChange(textField)
    }

    func testDidTapPrimaryButton() {
        viewController.didTapPrimaryButton()
        XCTAssertTrue(mockDelegate.filterBrandCalled)
        XCTAssertTrue(mockDelegate.filterModelCalled)
        XCTAssertTrue(mockDelegate.sortCalled)
    }
}

class MockFilterProtocol: FilterProtocol {
    var filterBrandCalled = false
    var filterModelCalled = false
    var sortCalled = false

    func filterBrand(brands: [SearchEntity]?) {
        filterBrandCalled = true
    }

    func filterModel(models: [SearchEntity]?) {
        filterModelCalled = true
    }

    func sort(type: SortType?) {
        sortCalled = true
    }
}
