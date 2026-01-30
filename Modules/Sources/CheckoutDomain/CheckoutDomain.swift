// Author: George Michelon
import Foundation
import SharedContracts

public struct CartItem: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let name: String
    public let price: Decimal
    public let quantity: Int

    public init(id: UUID, name: String, price: Decimal, quantity: Int) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}

public enum CartError: Error, Equatable {
    case invalidQuantity
    case itemNotFound
}

public struct Cart: Equatable, Sendable {
    public private(set) var items: [CartItem]

    public init(items: [CartItem] = []) {
        self.items = items
    }

    public mutating func add(_ item: CartItem) throws {
        guard item.quantity > 0 else { throw CartError.invalidQuantity }
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            let existing = items[index]
            let updated = CartItem(
                id: existing.id,
                name: existing.name,
                price: existing.price,
                quantity: existing.quantity + item.quantity
            )
            items[index] = updated
        } else {
            items.append(item)
        }
    }

    public mutating func remove(id: UUID) throws {
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            throw CartError.itemNotFound
        }
        items.remove(at: index)
    }

    public mutating func updateQuantity(id: UUID, quantity: Int) throws {
        guard quantity > 0 else { throw CartError.invalidQuantity }
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            throw CartError.itemNotFound
        }
        let existing = items[index]
        items[index] = CartItem(id: existing.id, name: existing.name, price: existing.price, quantity: quantity)
    }

    public var subtotal: Decimal {
        items.reduce(0) { $0 + ($1.price * Decimal($1.quantity)) }
    }

    public var total: Decimal {
        subtotal
    }
}

public extension Cart {
    init(context: CheckoutContextDTO) throws {
        let mapped: [CartItem] = context.items.map { dto in
            CartItem(id: dto.id, name: dto.name, price: dto.price, quantity: dto.quantity)
        }
        self.init(items: mapped)
        for item in mapped where item.quantity <= 0 {
            throw CartError.invalidQuantity
        }
    }
}
