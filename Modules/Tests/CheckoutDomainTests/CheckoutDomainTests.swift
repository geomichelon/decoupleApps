// Author: George Michelon
import XCTest
@testable import CheckoutDomain
import SharedContracts

final class CheckoutDomainTests: XCTestCase {
    func testAddItemIncreasesCount() throws {
        var cart = Cart()
        let item = CartItem(id: UUID(), name: "Item", price: 10, quantity: 1)
        try cart.add(item)
        XCTAssertEqual(cart.items.count, 1)
    }

    func testAddSameItemAggregatesQuantity() throws {
        let id = UUID()
        var cart = Cart()
        try cart.add(CartItem(id: id, name: "Item", price: 10, quantity: 1))
        try cart.add(CartItem(id: id, name: "Item", price: 10, quantity: 2))
        XCTAssertEqual(cart.items.first?.quantity, 3)
    }

    func testUpdateQuantityValidates() {
        let id = UUID()
        var cart = Cart(items: [CartItem(id: id, name: "Item", price: 10, quantity: 1)])
        XCTAssertThrowsError(try cart.updateQuantity(id: id, quantity: 0))
    }

    func testRemoveItem() throws {
        let id = UUID()
        var cart = Cart(items: [CartItem(id: id, name: "Item", price: 10, quantity: 1)])
        try cart.remove(id: id)
        XCTAssertTrue(cart.items.isEmpty)
    }

    func testSubtotalAndTotal() throws {
        let id = UUID()
        var cart = Cart()
        try cart.add(CartItem(id: id, name: "Item", price: 10, quantity: 2))
        XCTAssertEqual(cart.subtotal, 20)
        XCTAssertEqual(cart.total, 20)
    }

    func testInitFromContextValidatesQuantity() {
        let dto = CheckoutLineItemDTO(id: UUID(), name: "Item", price: 10, quantity: 0)
        let context = CheckoutContextDTO(items: [dto], source: "catalog")
        XCTAssertThrowsError(try Cart(context: context))
    }
}
