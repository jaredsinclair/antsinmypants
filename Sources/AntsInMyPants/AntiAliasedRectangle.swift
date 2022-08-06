import SwiftUI

public struct AntiAliasedRectangle<Content: View>: View {
    public var cornerRadius: CGFloat
    public var rectangleAspectRatio: CGFloat
    public let content: () -> Content

    public init(
        cornerRadius: CGFloat = 0,
        rectangleAspectRatio: CGFloat = 1,
        content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.rectangleAspectRatio = rectangleAspectRatio
        self.content = content
    }

    public var body: some View {
        AspectRatioedRectangle {
            AspectRatioedRectangle(
                cornerRadius: cornerRadius,
                rectangleAspectRatio: rectangleAspectRatio,
                content: content
            )
            .padding(1)
        }
        .padding(-1)
    }
}

struct AspectRatioedRectangle<Content: View>: View {
    var cornerRadius: CGFloat = 0
    var rectangleAspectRatio: CGFloat = 1
    let content: () -> Content

    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .aspectRatio(rectangleAspectRatio, contentMode: .fit)
            .overlay(content: content)
            .cornerRadius(cornerRadius)
    }
}
