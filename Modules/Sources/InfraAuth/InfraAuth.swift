// Author: George Michelon
import Combine
import Foundation
import SharedContracts

public final class AuthStore: ObservableObject, AuthStateProviding, AuthEventPublishing, AuthEventObserving {
    @Published public private(set) var current: AuthSnapshotDTO

    private var observers: [UUID: (AuthEvent) -> Void] = [:]

    public init(initial: AuthSnapshotDTO = .signedOut) {
        self.current = initial
    }

    public func publish(_ event: AuthEvent) {
        switch event {
        case .signedIn(let userID):
            current = AuthSnapshotDTO(isAuthenticated: true, userID: userID)
        case .signedOut:
            current = .signedOut
        }
        observers.values.forEach { $0(event) }
    }

    public func observe(_ handler: @escaping (AuthEvent) -> Void) {
        let id = UUID()
        observers[id] = handler
        handler(current.isAuthenticated ? .signedIn(userID: current.userID ?? "") : .signedOut)
    }
}
