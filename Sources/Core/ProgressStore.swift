import Foundation

struct ProgressData: Codable {
    var completedActivityIDs: Set<String> = []
    var collectibleIDs: Set<String> = []
}

/// Local-only progress persistence — one file PER CHILD PROFILE, so every
/// child has their own sticker collection. No accounts, no network.
final class ProgressStore: ObservableObject {
    @Published private(set) var data = ProgressData()

    private var profileID: UUID?

    private static var documents: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private var fileURL: URL {
        if let profileID {
            return Self.documents.appendingPathComponent("progress-\(profileID.uuidString).json")
        }
        return Self.documents.appendingPathComponent("progress.json")
    }

    init() {
        load()
    }

    /// Point the store at a child's file (called when the active profile
    /// changes). The very first profile inherits any pre-profile progress.
    func switchProfile(_ id: UUID?) {
        guard id != profileID else { return }
        profileID = id
        data = ProgressData()

        // One-time adoption: the first profile ever created takes over the
        // legacy single-child progress file.
        if let id {
            let target = Self.documents.appendingPathComponent("progress-\(id.uuidString).json")
            let legacy = Self.documents.appendingPathComponent("progress.json")
            if !FileManager.default.fileExists(atPath: target.path),
               FileManager.default.fileExists(atPath: legacy.path) {
                try? FileManager.default.copyItem(at: legacy, to: target)
                let backup = Self.documents.appendingPathComponent("progress-premigration.bak")
                try? FileManager.default.removeItem(at: backup)
                try? FileManager.default.moveItem(at: legacy, to: backup)
            }
        }
        load()
    }

    /// Removes a deleted child's saved progress.
    func deleteProfileData(_ id: UUID) {
        let url = Self.documents.appendingPathComponent("progress-\(id.uuidString).json")
        try? FileManager.default.removeItem(at: url)
    }

    func isCompleted(_ activityID: String) -> Bool {
        data.completedActivityIDs.contains(activityID)
    }

    func isUnlocked(_ collectibleID: String) -> Bool {
        data.collectibleIDs.contains(collectibleID)
    }

    func completedCount(in world: BibleWorld) -> Int {
        world.activities.filter { isCompleted($0.id) }.count
    }

    func complete(_ activity: Activity, in world: BibleWorld) {
        data.completedActivityIDs.insert(activity.id)
        data.collectibleIDs.insert(activity.reward.id)
        // Finishing every activity in a world unlocks its bonus character.
        if let bonus = world.bonusReward,
           world.activities.allSatisfy({ data.completedActivityIDs.contains($0.id) }) {
            data.collectibleIDs.insert(bonus.id)
        }
        save()
    }

    func resetAll() {
        data = ProgressData()
        save()
    }

    private func load() {
        guard let raw = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode(ProgressData.self, from: raw) else { return }
        data = decoded
    }

    private func save() {
        guard let raw = try? JSONEncoder().encode(data) else { return }
        try? raw.write(to: fileURL, options: .atomic)
    }
}
