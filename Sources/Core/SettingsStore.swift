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

/// Picks which child artwork represents the player in the games.
enum ChildGender: String, CaseIterable, Identifiable {
    case boy
    case girl

    var id: String { rawValue }

    var label: String {
        switch self {
        case .boy: return "Boy"
        case .girl: return "Girl"
        }
    }
}

final class SettingsStore: ObservableObject {
    @Published var narrationEnabled: Bool { didSet { save() } }
    @Published var soundEffectsEnabled: Bool { didSet { save() } }
    @Published var ageBand: AgeBand { didSet { save() } }
    @Published var meetingModeOn: Bool { didSet { save() } }
    @Published var childName: String { didSet { save() } }
    @Published var childGender: ChildGender { didSet { save() } }

    private let defaults = UserDefaults.standard

    /// The child's name, cleaned for narration ("Great job, Scarlet!").
    /// Empty when no name has been set.
    var cheerName: String {
        childName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    init() {
        narrationEnabled = defaults.object(forKey: "narrationEnabled") as? Bool ?? true
        soundEffectsEnabled = defaults.object(forKey: "soundEffectsEnabled") as? Bool ?? true
        ageBand = AgeBand(rawValue: defaults.string(forKey: "ageBand") ?? "") ?? .littleOnes
        meetingModeOn = defaults.bool(forKey: "meetingModeOn")
        childName = defaults.string(forKey: "childName") ?? ""
        childGender = ChildGender(rawValue: defaults.string(forKey: "childGender") ?? "") ?? .boy
    }

    private func save() {
        defaults.set(narrationEnabled, forKey: "narrationEnabled")
        defaults.set(soundEffectsEnabled, forKey: "soundEffectsEnabled")
        defaults.set(ageBand.rawValue, forKey: "ageBand")
        defaults.set(meetingModeOn, forKey: "meetingModeOn")
        defaults.set(childName, forKey: "childName")
        defaults.set(childGender.rawValue, forKey: "childGender")
    }
}
