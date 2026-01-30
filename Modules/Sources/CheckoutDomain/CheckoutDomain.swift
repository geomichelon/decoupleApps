// Author: George Michelon
import Foundation
import SharedContracts

public struct Cart: Equatable {
    public let items: [CheckoutLineItemDTO]

    public init(items: [CheckoutLineItemDTO]) {
        self.items = items
    }

    public var total: Decimal {
        items.reduce(0) { $0 + ($1.price * Decimal($1.quantity)) }
    }
}

public protocol CheckoutUseCase {
    func placeOrder(cart: Cart) -> Bool
}

public struct DefaultCheckoutUseCase: CheckoutUseCase {
    public init() {}

    public func placeOrder(cart: Cart) -> Bool {
        !cart.items.isEmpty
    }
}
