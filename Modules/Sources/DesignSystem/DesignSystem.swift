import SwiftUI

public enum DS {
    public static let spacing: CGFloat = 12
    public static let cornerRadius: CGFloat = 12
    public static let primaryColor: Color = .blue
}

public struct PrimaryButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(DS.primaryColor.opacity(configuration.isPressed ? 0.7 : 1.0))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: DS.cornerRadius))
    }
}

public struct Card<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .padding(DS.spacing)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: DS.cornerRadius))
    }
}
