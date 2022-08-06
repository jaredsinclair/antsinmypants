import SwiftUI

public struct ContentSizeObserver: View {
    @Binding public var size: CGSize?

    public var body: some View {
        GeometryReader { proxy in
            Color.clear.onAppear {
                update(proxy.size)
            }
        }
    }

    private func update(_ newSize: CGSize) {
        guard newSize != size else { return }
        size = newSize
    }
}
