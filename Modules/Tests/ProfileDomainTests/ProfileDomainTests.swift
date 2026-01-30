// Author: George Michelon
import XCTest
@testable import ProfileDomain
import SharedContracts

final class ProfileDomainTests: XCTestCase {
    func testSignedOutReturnsNilProfile() {
        let useCase = DefaultProfileUseCase()
        let profile = useCase.currentProfile(from: .signedOut)
        XCTAssertNil(profile)
    }

    func testSignedInReturnsProfile() {
        let useCase = DefaultProfileUseCase()
        let snapshot = AuthSnapshotDTO(isAuthenticated: true, userID: "user-123")
        let profile = useCase.currentProfile(from: snapshot)
        XCTAssertEqual(profile?.id, "user-123")
    }

    func testEmptyUserIDReturnsNil() {
        let useCase = DefaultProfileUseCase()
        let snapshot = AuthSnapshotDTO(isAuthenticated: true, userID: "")
        let profile = useCase.currentProfile(from: snapshot)
        XCTAssertNil(profile)
    }
}
