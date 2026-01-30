import Foundation

public struct CheckoutLineItemDTO: Hashable, Sendable {
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

public struct CheckoutContextDTO: Hashable, Sendable {
    public let items: [CheckoutLineItemDTO]
    public let source: String

    public init(items: [CheckoutLineItemDTO], source: String) {
        self.items = items
        self.source = source
    }
}

public protocol CheckoutRouting {
    func startCheckout(with context: CheckoutContextDTO)
}

public enum AuthEvent: Equatable, Sendable {
    case signedIn(userID: String)
    case signedOut
}

public struct AuthSnapshotDTO: Equatable, Sendable {
    public let isAuthenticated: Bool
    public let userID: String?

    public init(isAuthenticated: Bool, userID: String?) {
        self.isAuthenticated = isAuthenticated
        self.userID = userID
    }

    public static let signedOut = AuthSnapshotDTO(isAuthenticated: false, userID: nil)
}

public protocol AuthEventPublishing {
    func publish(_ event: AuthEvent)
}

public protocol AuthEventObserving {
    func observe(_ handler: @escaping (AuthEvent) -> Void)
}

public protocol AuthStateProviding {
    var current: AuthSnapshotDTO { get }
}
