import UIKit

/// Gentle, silent feedback — safe even in Meeting Mode.
enum Haptics {
    static func soft() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }

    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func gentleError() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}
