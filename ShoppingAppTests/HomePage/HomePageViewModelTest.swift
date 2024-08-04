//
//  HomePageViewControllerTest.swift
//  ShoppingAppTests
//
//  Created by safa uslu on 4.08.2024.
//

import XCTest
@testable import ShoppingApp
import CoreData

class HomePageViewModelTests: XCTestCase {

    var viewModel: HomePageViewModel!
    var mockAPIClient: MockProductAPIClient!
    var mockCoreDataManager: MockCoreDataManager!
    var mockContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        mockAPIClient = MockProductAPIClient()
        mockContext = setUpInMemoryManagedObjectContext()
        mockCoreDataManager = MockCoreDataManager(mockContext: mockContext)
        viewModel = HomePageViewModel(apiClient: mockAPIClient)
    }

    override func tearDown() {
        viewModel = nil
        mockAPIClient = nil
        mockContext = nil
        mockCoreDataManager = nil
        super.tearDown()
    }

    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            fatalError("Adding in-memory persistent store failed")
        }
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }

    func testFetchProductSuccess() {
        let expectation = self.expectation(description: "Fetch products")
        let productDtos = [
            ProductDto(id: "1", createdAt: "2024-08-02", name: "Product 1", image: "http://example.com/image1.png", price: "100.0", description: "Description 1", model: "Model 1", brand: "Brand 1", isFavorited: false),
            ProductDto(id: "2", createdAt: "2024-08-03", name: "Product 2", image: "http://example.com/image2.png", price: "200.0", description: "Description 2", model: "Model 2", brand: "Brand 2", isFavorited: false)
        ]
        mockAPIClient.result = .success(productDtos)

        viewModel.fetchProduct {
            XCTAssertEqual(self.viewModel.products?.count, 2)
            XCTAssertEqual(self.viewModel.products?.first?.name, "Product 1")
            XCTAssertEqual(self.viewModel.products?.last?.name, "Product 2")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }


    func testApplyFilters() {
        let productDtos = [
            ProductDto(id: "1", createdAt: "2024-08-02", name: "Product 1", image: "http://example.com/image1.png", price: "100.0", description: "Description 1", model: "Model 1", brand: "Brand 1", isFavorited: false),
            ProductDto(id: "2", createdAt: "2024-08-03", name: "Product 2", image: "http://example.com/image2.png", price: "200.0", description: "Description 2", model: "Model 2", brand: "Brand 2", isFavorited: false)
        ]
        viewModel.products = productDtos
        viewModel.selectedBrands = ["Brand 1"]
        viewModel.applyFilters()
        XCTAssertEqual(viewModel.filteredProductes?.count, 1)
        XCTAssertEqual(viewModel.filteredProductes?.first?.brand, "Brand 1")

        viewModel.selectedModels = ["Model 2"]
        viewModel.applyFilters()
        XCTAssertEqual(viewModel.filteredProductes?.count, 0)
    }

    func testUpdateFavoriteState() {
        let productDtos = [
            ProductDto(id: "1", createdAt: "2024-08-02", name: "Product 1", image: "http://example.com/image1.png", price: "100.0", description: "Description 1", model: "Model 1", brand: "Brand 1", isFavorited: false),
            ProductDto(id: "2", createdAt: "2024-08-03", name: "Product 2", image: "http://example.com/image2.png", price: "200.0", description: "Description 2", model: "Model 2", brand: "Brand 2", isFavorited: false)
        ]
        viewModel.products = productDtos
        viewModel.filteredProductes = productDtos

        viewModel.updateFavoriteState(index: 0)
        XCTAssertTrue(viewModel.products?[0].isFavorited == true)
        XCTAssertTrue(viewModel.filteredProductes?[0].isFavorited == true)

        viewModel.updateFavoriteState(for: productDtos[1])
        XCTAssertTrue(viewModel.products?[1].isFavorited == true)
        XCTAssertTrue(viewModel.filteredProductes?[1].isFavorited == true)
    }

    func testHandleEmptyState() {
        viewModel.filteredProductes = []
        XCTAssertFalse(viewModel.handleEmptyState())

        viewModel.filteredProductes = [ProductDto(id: "1", createdAt: "2024-08-02", name: "Product 1", image: "http://example.com/image1.png", price: "100.0", description: "Description 1", model: "Model 1", brand: "Brand 1", isFavorited: false)]
        XCTAssertTrue(viewModel.handleEmptyState())
    }

    func testGetAllBrandsAsSearchEntities() {
        let productDtos = [
            ProductDto(id: "1", createdAt: "2024-08-02", name: "Product 1", image: "http://example.com/image1.png", price: "100.0", description: "Description 1", model: "Model 1", brand: "Brand 1", isFavorited: false),
            ProductDto(id: "2", createdAt: "2024-08-03", name: "Product 2", image: "http://example.com/image2.png", price: "200.0", description: "Description 2", model: "Model 2", brand: "Brand 2", isFavorited: false)
        ]
        viewModel.products = productDtos
        let brands = viewModel.getAllBrandsAsSearchEntities()
        XCTAssertEqual(brands.count, 2)
        XCTAssertTrue(brands.contains { $0.title == "Brand 1" })
        XCTAssertTrue(brands.contains { $0.title == "Brand 2" })
    }

    func testGetAllModelsAsSearchEntities() {
        let productDtos = [
            ProductDto(id: "1", createdAt: "2024-08-02", name: "Product 1", image: "http://example.com/image1.png", price: "100.0", description: "Description 1", model: "Model 1", brand: "Brand 1", isFavorited: false),
            ProductDto(id: "2", createdAt: "2024-08-03", name: "Product 2", image: "http://example.com/image2.png", price: "200.0", description: "Description 2", model: "Model 2", brand: "Brand 2", isFavorited: false)
        ]
        viewModel.products = productDtos
        let models = viewModel.getAllModelsAsSearchEntities()
        XCTAssertEqual(models.count, 2)
        XCTAssertTrue(models.contains { $0.title == "Model 1" })
        XCTAssertTrue(models.contains { $0.title == "Model 2" })
    }

    func testSortProducts() {
        let productDtos = [
            ProductDto(id: "1", createdAt: "2024-08-02", name: "Product 1", image: "http://example.com/image1.png", price: "100.0", description: "Description 1", model: "Model 1", brand: "Brand 1", isFavorited: false),
            ProductDto(id: "2", createdAt: "2024-08-03", name: "Product 2", image: "http://example.com/image2.png", price: "200.0", description: "Description 2", model: "Model 2", brand: "Brand 2", isFavorited: false)
        ]
        viewModel.products = productDtos
        viewModel.filteredProductes = productDtos

        viewModel.sortProducts(by: .priceAscending)
        XCTAssertEqual(viewModel.filteredProductes?.first?.price, "100.0")
        XCTAssertEqual(viewModel.filteredProductes?.last?.price, "200.0")

        viewModel.sortProducts(by: .priceDescending)
        XCTAssertEqual(viewModel.filteredProductes?.first?.price, "200.0")
        XCTAssertEqual(viewModel.filteredProductes?.last?.price, "100.0")
    }
}
