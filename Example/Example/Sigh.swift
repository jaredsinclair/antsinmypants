import SwiftUI
import Combine

struct ReadableContentContainer<Content: View>: View {
    var emsPerLine: Int = 50
    let content: (_ readableContentWidth: CGFloat) -> Content
    @StateObject private var fontReference = FontReference()

    var body: some View {
        GeometryReader { proxy in
            let width = readableContentWidth(in: proxy)
            ZStack {
                content(width).frame(width: width)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    func readableContentWidth(in proxy: GeometryProxy) -> CGFloat {
        let recommended = fontReference.bodyPointSize.rounded() * CGFloat(emsPerLine)
        return min(recommended, proxy.size.width - 40)
    }
}

class FontReference: ObservableObject {
    @Published var bodyPointSize = UIFont.preferredFont(forTextStyle: .body).pointSize
    private var subscription: AnyCancellable?

    init() {
        subscription = NotificationCenter.default
            .publisher(for: UIContentSizeCategory.didChangeNotification)
            .sink { [weak self] _ in
                self?.bodyPointSize = UIFont.preferredFont(forTextStyle: .body).pointSize
            }
    }
}
