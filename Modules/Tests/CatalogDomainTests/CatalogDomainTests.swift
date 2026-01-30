// Author: George Michelon
import XCTest
@testable import CatalogDomain

final class CatalogDomainTests: XCTestCase {
    func testDefaultUseCaseReturnsItems() {
        let useCase = DefaultCatalogUseCase()
        let items = useCase.fetchItems()
        XCTAssertFalse(items.isEmpty)
    }

    func testCatalogItemsHaveStableTitles() {
        let items = CatalogItem.sampleData
        XCTAssertTrue(items.allSatisfy { !$0.title.isEmpty })
    }
}
