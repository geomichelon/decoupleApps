// Author: George Michelon
import SwiftUI
import CheckoutFeature
import SharedContracts

@main
struct CheckoutApp: App {
    var body: some Scene {
        WindowGroup {
            CheckoutAppRootView()
        }
    }
}

private struct CheckoutAppRootView: View {
    @State private var showProfileAlert = false

    var body: some View {
        NavigationStack {
            let context = CheckoutContextDTO(
                items: [CheckoutLineItemDTO(id: UUID(), name: "Starter Pack", price: 19.90, quantity: 1)],
                source: "checkout"
            )
            CheckoutFeatureView(context: context)
                .toolbar {
                    Button("Profile") {
                        AlertProfileEntryPoint { showProfileAlert = true }.showProfile()
                    }
                }
                .alert("Profile unavailable", isPresented: $showProfileAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("This app does not include Profile.")
                }
        }
    }
}

private struct AlertProfileEntryPoint: ProfileEntryPoint {
    let onTrigger: () -> Void

    func showProfile() {
        onTrigger()
    }
}
