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
enum ChildGender: String, CaseIterable, Identifiable, Codable {
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

/// One child in the family. Each profile has its own progress and sticker
/// collection (stored per-profile by ProgressStore).
struct ChildProfile: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var gender: ChildGender
}

final class SettingsStore: ObservableObject {
    @Published var narrationEnabled: Bool { didSet { save() } }
    @Published var soundEffectsEnabled: Bool { didSet { save() } }
    @Published var ageBand: AgeBand { didSet { save() } }
    @Published var meetingModeOn: Bool { didSet { save() } }
    @Published var profiles: [ChildProfile] { didSet { save() } }
    @Published var activeProfileID: UUID? { didSet { save() } }

    private let defaults = UserDefaults.standard

    var activeProfile: ChildProfile? {
        profiles.first { $0.id == activeProfileID } ?? profiles.first
    }

    /// The active child's name, cleaned for narration ("Great job, Scarlet!").
    /// Empty when no profile exists.
    var cheerName: String {
        (activeProfile?.name ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// The active child's look in the games.
    var childGender: ChildGender {
        activeProfile?.gender ?? .boy
    }

    init() {
        narrationEnabled = defaults.object(forKey: "narrationEnabled") as? Bool ?? true
        soundEffectsEnabled = defaults.object(forKey: "soundEffectsEnabled") as? Bool ?? true
        ageBand = AgeBand(rawValue: defaults.string(forKey: "ageBand") ?? "") ?? .littleOnes
        meetingModeOn = defaults.bool(forKey: "meetingModeOn")

        if let data = defaults.data(forKey: "profiles"),
           let decoded = try? JSONDecoder().decode([ChildProfile].self, from: data) {
            profiles = decoded
        } else {
            profiles = []
        }
        if let raw = defaults.string(forKey: "activeProfileID"), let id = UUID(uuidString: raw) {
            activeProfileID = id
        } else {
            activeProfileID = nil
        }

        // Migrate the original single-child settings into the first profile.
        let legacyName = (defaults.string(forKey: "childName") ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if profiles.isEmpty && !legacyName.isEmpty {
            let gender = ChildGender(rawValue: defaults.string(forKey: "childGender") ?? "") ?? .boy
            let migrated = ChildProfile(name: legacyName, gender: gender)
            profiles = [migrated]
            activeProfileID = migrated.id
        }
        if activeProfileID == nil {
            activeProfileID = profiles.first?.id
        }
    }

    @discardableResult
    func addProfile(name: String, gender: ChildGender) -> ChildProfile {
        let profile = ChildProfile(name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                                   gender: gender)
        profiles.append(profile)
        activeProfileID = profile.id
        return profile
    }

    func removeProfile(_ id: UUID) {
        profiles.removeAll { $0.id == id }
        if activeProfileID == id {
            activeProfileID = profiles.first?.id
        }
    }

    private func save() {
        defaults.set(narrationEnabled, forKey: "narrationEnabled")
        defaults.set(soundEffectsEnabled, forKey: "soundEffectsEnabled")
        defaults.set(ageBand.rawValue, forKey: "ageBand")
        defaults.set(meetingModeOn, forKey: "meetingModeOn")
        if let data = try? JSONEncoder().encode(profiles) {
            defaults.set(data, forKey: "profiles")
        }
        defaults.set(activeProfileID?.uuidString, forKey: "activeProfileID")
    }
}
