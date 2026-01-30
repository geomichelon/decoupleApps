// Author: George Michelon
import Foundation
import SharedContracts

public struct UserProfile: Equatable {
    public let id: UUID
    public let name: String

    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

public protocol ProfileUseCase {
    func currentProfile() -> UserProfile?
    func authSnapshot() -> AuthSnapshotDTO
}

public struct DefaultProfileUseCase: ProfileUseCase {
    private let snapshot: AuthSnapshotDTO

    public init(snapshot: AuthSnapshotDTO = .signedOut) {
        self.snapshot = snapshot
    }

    public func currentProfile() -> UserProfile? {
        snapshot.isAuthenticated ? UserProfile(id: UUID(), name: "User") : nil
    }

    public func authSnapshot() -> AuthSnapshotDTO {
        snapshot
    }
}
