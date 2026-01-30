// Author: George Michelon
import Foundation
import SharedContracts

public struct CatalogItem: Identifiable, Equatable {
    public let id: UUID
    public let title: String
    public let price: Decimal

    public init(id: UUID, title: String, price: Decimal) {
        self.id = id
        self.title = title
        self.price = price
    }
}

public protocol CatalogUseCase {
    func fetchItems() -> [CatalogItem]
}

public struct DefaultCatalogUseCase: CatalogUseCase {
    public init() {}

    public func fetchItems() -> [CatalogItem] {
        [
            CatalogItem(id: UUID(), title: "Starter Pack", price: 19.90),
            CatalogItem(id: UUID(), title: "Pro Pack", price: 49.90)
        ]
    }
}
