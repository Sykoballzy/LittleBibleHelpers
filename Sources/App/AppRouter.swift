import SwiftUI

enum Screen: Hashable {
    case home
    case worldMap
    case storyHub(worldID: String)
    case game(worldID: String, activityID: String)
    case celebration(worldID: String, activityID: String)
    case collection
    case parentArea
}

/// What the parent gate unlocks when answered correctly.
enum GateIntent: Hashable {
    case openParentArea
    case exitMeetingMode
}

final class AppRouter: ObservableObject {
    @Published var screen: Screen = .home
    @Published var gateIntent: GateIntent?

    func go(_ destination: Screen) {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            screen = destination
        }
    }

    func requestGate(_ intent: GateIntent) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            gateIntent = intent
        }
    }

    func dismissGate() {
        withAnimation(.easeOut(duration: 0.2)) {
            gateIntent = nil
        }
    }
}
