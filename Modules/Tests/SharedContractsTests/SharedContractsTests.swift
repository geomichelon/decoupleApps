// Author: George Michelon
import XCTest
@testable import SharedContracts

final class SharedContractsTests: XCTestCase {
    func testCheckoutContextIsHashable() {
        let item = CheckoutLineItemDTO(id: UUID(), name: "Item", price: 9.99, quantity: 1)
        let context = CheckoutContextDTO(items: [item], source: "catalog")
        let set: Set<CheckoutContextDTO> = [context]
        XCTAssertEqual(set.count, 1)
    }

    func testAuthSnapshotSignedOut() {
        XCTAssertFalse(AuthSnapshotDTO.signedOut.isAuthenticated)
        XCTAssertNil(AuthSnapshotDTO.signedOut.userID)
    }

    func testAuthEventHashable() {
        let events: Set<AuthEvent> = [.signedOut, .signedIn(userID: "user-1")]
        XCTAssertEqual(events.count, 2)
    }
}
