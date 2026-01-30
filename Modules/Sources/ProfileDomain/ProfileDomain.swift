// Author: George Michelon
import Foundation
import SharedContracts

public struct UserProfile: Equatable, Sendable {
    public let id: String
    public let displayName: String

    public init(id: String, displayName: String) {
        self.id = id
        self.displayName = displayName
    }
}

public protocol ProfileUseCase {
    func currentProfile(from snapshot: AuthSnapshotDTO) -> UserProfile?
}

public struct DefaultProfileUseCase: ProfileUseCase {
    public init() {}

    public func currentProfile(from snapshot: AuthSnapshotDTO) -> UserProfile? {
        guard snapshot.isAuthenticated, let userID = snapshot.userID, !userID.isEmpty else {
            return nil
        }
        return UserProfile(id: userID, displayName: "User \(userID)")
    }
}
