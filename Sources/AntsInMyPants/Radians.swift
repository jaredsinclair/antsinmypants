import SwiftUI

typealias Radians = CGFloat

extension Int {

    var radians: CGFloat {
        return CGFloat(self).radians
    }

    var radiansDouble: Double {
        return Double(self) * .pi / 180
    }

}

extension CGFloat {

    var radians: CGFloat {
        return self * .pi / 180
    }

}
