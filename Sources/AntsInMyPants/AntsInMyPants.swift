import SwiftUI

extension View {

    public func antsInMyPants(
        isWiggling: Binding<Bool> = .constant(true),
        wiggleExaggeration: Binding<CGFloat> = .constant(1.0),
        iterationsPerSecond: Binding<CFTimeInterval> = .constant(1.0),
        perspectiveExaggeration: Binding<CGFloat> = .constant(1.0)
    ) -> some View {
        AntsInMyPants(
            isWiggling: isWiggling,
            wiggleExaggeration: wiggleExaggeration,
            iterationsPerSecond: iterationsPerSecond,
            perspectiveExaggeration: perspectiveExaggeration,
            content: { self }
        )
    }

}

public struct AntsInMyPants<Content: View>: View {

    @Binding public var isWiggling: Bool
    @Binding public var wiggleExaggeration: CGFloat
    @Binding public var iterationsPerSecond: CFTimeInterval
    @Binding public var perspectiveExaggeration: CGFloat
    public let content: () -> Content

    @StateObject private var timer = RotationTimer()
    @State private var contentSize: CGSize?

    public var body: some View {
        content()
            .overlay {
                ContentSizeObserver(size: $contentSize)
            }
            .projectionEffect(transform)
            .task(id: isWiggling) {
                isWiggling ? timer.start() : timer.stop()
            }
            .task(id: iterationsPerSecond) {
                timer.iterationsPerSecond = iterationsPerSecond
            }
    }

    private var transform: ProjectionTransform {

        guard let contentSize = contentSize else {
            return ProjectionTransform(.identity)
        }

        let width = contentSize.width
        let height = contentSize.height

        var transform3d = CATransform3DIdentity

        // Set the perspective as a "feels nice" value according to the area.

        transform3d.m34 = (-1 / (width + height)) * perspectiveExaggeration

        // Do some math, the results of which will be used below.

        let baseAngle = 3.radians * wiggleExaggeration
        let baseShift = width * height * 0.00005 * wiggleExaggeration
        let yAngle, xAngle, yShift, xShift: CGFloat
        if width > height {
            yAngle = baseAngle * height/width
            yShift = -baseShift * height/width
            xAngle = baseAngle
            xShift = baseShift
        } else {
            yAngle = baseAngle
            yShift = -baseShift
            xAngle = baseAngle * width/height
            xShift = baseShift * width/height
        }

        // These next two transforms point the "face" at the desired focal point
        // behind the user's head, like it's watching a ellipse being drawn on a
        // chalkboard across a room, or a dog waiting impatiently for dinner.
        // The X and Y values are not changed identically. First of all, the X
        // curve (as seen in the RotationTimer) is deliberately out of phase
        // with the Y curve, which is what yields the "look left, look up, look
        // right, look down" effect. Second of all, the effect feels less bouncy
        // and more organic if the angles are in proportion to the aspect ratio
        // of the view being animated.

        transform3d = CATransform3DRotate(transform3d, yAngle * timer.elapsedTimeY, 1, 0, 0)
        transform3d = CATransform3DRotate(transform3d, xAngle * timer.elapsedTimeX, 0, 1, 0)

        // This transform makes the effect feel more natural by applying a bit
        // horizontal and vertical translation in the direction that the view is
        // facing, the way a human face moves when its head turns, or like a
        // flower following the sun.

        transform3d = CATransform3DTranslate(transform3d, xShift * timer.elapsedTimeX, yShift * timer.elapsedTimeY, 0)

        // These next two lines correct for SwiftUI's rather unfortunate choice
        // to use (0,0) as the anchor point for projection transforms. The only
        // other alternative is to introspect the UIKit hierarchy and modify a
        // layer's anchor point, which would be.........bad.

        transform3d = CATransform3DTranslate(transform3d, -width/2, -height/2, 0)
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: width/2, y: height/2))

        // Voila.

        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }

    private class RotationTimer: ObservableObject {

        var elapsedTimeX: CGFloat {
            sin(2 * .pi * (absoluteTime + 0.25)) // <---- 25% out-of-phase with the Y time
        }

        var elapsedTimeY: CGFloat {
            sin(2 * .pi * absoluteTime)
        }

        var iterationsPerSecond: CFTimeInterval = 1

        @Published private var absoluteTime: CGFloat = 0

        private let link = DisplayLink()

        deinit {
            stop()
        }

        func start() {
            link.start { [weak self] framesPerSecond in
                guard let self = self else { return }
                self.absoluteTime -= 1.0 / (framesPerSecond / self.iterationsPerSecond)
            }
        }

        func stop() {
            link.stop()
        }
    }

}
