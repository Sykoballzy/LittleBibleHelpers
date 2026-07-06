import Foundation

struct ProgressData: Codable {
    var completedActivityIDs: Set<String> = []
    var collectibleIDs: Set<String> = []
}

/// Local-only progress persistence. No accounts, no network.
final class ProgressStore: ObservableObject {
    @Published private(set) var data = ProgressData()

    private static var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("progress.json")
    }

    init() {
        load()
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
        guard let raw = try? Data(contentsOf: Self.fileURL),
              let decoded = try? JSONDecoder().decode(ProgressData.self, from: raw) else { return }
        data = decoded
    }

    private func save() {
        guard let raw = try? JSONEncoder().encode(data) else { return }
        try? raw.write(to: Self.fileURL, options: .atomic)
    }
}
