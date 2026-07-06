import SwiftUI

enum AgeBand: String, CaseIterable, Identifiable {
    case littleOnes
    case bigHelpers

    var id: String { rawValue }

    var label: String {
        switch self {
        case .littleOnes: return "Ages 2–3"
        case .bigHelpers: return "Ages 4–5"
        }
    }
}

final class SettingsStore: ObservableObject {
    @Published var narrationEnabled: Bool { didSet { save() } }
    @Published var soundEffectsEnabled: Bool { didSet { save() } }
    @Published var ageBand: AgeBand { didSet { save() } }
    @Published var meetingModeOn: Bool { didSet { save() } }

    private let defaults = UserDefaults.standard

    init() {
        narrationEnabled = defaults.object(forKey: "narrationEnabled") as? Bool ?? true
        soundEffectsEnabled = defaults.object(forKey: "soundEffectsEnabled") as? Bool ?? true
        ageBand = AgeBand(rawValue: defaults.string(forKey: "ageBand") ?? "") ?? .littleOnes
        meetingModeOn = defaults.bool(forKey: "meetingModeOn")
    }

    private func save() {
        defaults.set(narrationEnabled, forKey: "narrationEnabled")
        defaults.set(soundEffectsEnabled, forKey: "soundEffectsEnabled")
        defaults.set(ageBand.rawValue, forKey: "ageBand")
        defaults.set(meetingModeOn, forKey: "meetingModeOn")
    }
}
