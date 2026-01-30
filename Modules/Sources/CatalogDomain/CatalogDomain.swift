// Author: George Michelon
import Foundation

public struct CatalogItem: Identifiable, Hashable, Sendable {
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
    private let items: [CatalogItem]

    public init(items: [CatalogItem] = CatalogItem.sampleData) {
        self.items = items
    }

    public func fetchItems() -> [CatalogItem] {
        items
    }
}

public extension CatalogItem {
    static let sampleData: [CatalogItem] = [
        CatalogItem(id: UUID(), title: "Starter Pack", price: 19.90),
        CatalogItem(id: UUID(), title: "Pro Pack", price: 49.90),
        CatalogItem(id: UUID(), title: "Enterprise Pack", price: 99.90)
    ]
}
