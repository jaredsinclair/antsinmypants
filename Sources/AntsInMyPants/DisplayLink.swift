import SwiftUI

public class DisplayLink: ObservableObject {
    private var tickHandler: (_ framesPerSecond: CFTimeInterval) -> Void = {_ in}
    private lazy var link = CADisplayLink(target: self, selector: #selector(tick))

    deinit {
        stop()
    }

    public func start(tickHandler: @escaping (_ framesPerSecond: CFTimeInterval) -> Void) {
        self.tickHandler = tickHandler
        link.add(to: .main, forMode: .common)
    }

    public func stop() {
        link.invalidate()
    }

    @objc private func tick() {
        let actualFramesPerSecond = 1 / (link.targetTimestamp - link.timestamp)
        tickHandler(actualFramesPerSecond)
    }
}
