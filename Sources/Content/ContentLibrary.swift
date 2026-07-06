import SwiftUI

/// Version 1 content. Future packs append worlds (or add activities to
/// existing worlds) here; nothing else in the app needs to change.
enum ContentLibrary {
    static let worlds: [BibleWorld] = [
        noahsArk,
        comingSoon(id: "creation", title: "Creation",
                   tagline: "The whole world is a gift!", icon: .sun, accent: Theme.sunny),
        comingSoon(id: "david", title: "David & the Sheep",
                   tagline: "Count and care for the flock.", icon: .sheep, accent: Theme.leaf),
        comingSoon(id: "daniel", title: "Daniel & the Lions",
                   tagline: "Be brave like Daniel.", icon: .lion, accent: Theme.coral),
        comingSoon(id: "jonah", title: "Jonah & the Big Fish",
                   tagline: "A big fish and a big lesson.", icon: .fish, accent: Theme.sky),
        comingSoon(id: "jesus", title: "Jesus & His Friends",
                   tagline: "Learn to be kind and loving.", icon: .heart, accent: Theme.berry),
        comingSoon(id: "meetings", title: "Meetings & Conventions",
                   tagline: "Get ready for the meeting!", icon: .hall, accent: Theme.wood),
        comingSoon(id: "qualities", title: "Christian Qualities",
                   tagline: "Grow good qualities every day.", icon: .star, accent: Theme.berry)
    ]

    static func world(_ id: String) -> BibleWorld? {
        worlds.first { $0.id == id }
    }

    static func lookup(worldID: String, activityID: String) -> (world: BibleWorld, activity: Activity)? {
        guard let world = world(worldID),
              let activity = world.activities.first(where: { $0.id == activityID }) else { return nil }
        return (world, activity)
    }

    static var allCollectibles: [Collectible] {
        worlds.flatMap { world in
            world.activities.map(\.reward) + (world.bonusReward.map { [$0] } ?? [])
        }
    }

    private static func comingSoon(id: String, title: String, tagline: String,
                                   icon: ArtKey, accent: Color) -> BibleWorld {
        BibleWorld(id: id, title: title, tagline: tagline, icon: icon, accent: accent,
                   welcomeLine: "", activities: [], bonusReward: nil)
    }

    // MARK: - Noah's Ark (first playable world)

    static let noahsArk = BibleWorld(
        id: "noah",
        title: "Noah's Ark",
        tagline: "Help Noah and the animals!",
        icon: .ark,
        accent: Theme.sky,
        welcomeLine: "Welcome to Noah's Ark! Which game would you like to play?",
        activities: [
            Activity(
                id: "noah-match",
                title: "Match the Animals",
                subtitle: "Find the matching pairs!",
                introLine: "The animals come two by two! Can you find the matching pairs?",
                completionLine: "You matched all the animals!",
                icon: .lion,
                spec: .matchPairs(pool: [.lion, .giraffe, .elephant, .dove]),
                reward: Collectible(id: "c-lion", name: "Lion", art: .lion, kind: .animal)
            ),
            Activity(
                id: "noah-board",
                title: "All Aboard!",
                subtitle: "Bring each animal onto the ark.",
                introLine: "The rain is coming! Can you help the animals onto the ark?",
                completionLine: "All the animals are safe on the ark!",
                icon: .elephant,
                spec: .boardTheArk(animals: [.elephant, .giraffe, .lion, .sheep]),
                reward: Collectible(id: "c-elephant", name: "Elephant", art: .elephant, kind: .animal)
            ),
            Activity(
                id: "noah-count",
                title: "Count the Doves",
                subtitle: "Tap each dove to count!",
                introLine: "Noah sent out a dove. How many doves can you count?",
                completionLine: "You counted every dove!",
                icon: .dove,
                spec: .count(item: .dove, littleTarget: 4, bigTarget: 6),
                reward: Collectible(id: "c-dove", name: "Dove", art: .dove, kind: .animal)
            ),
            Activity(
                id: "noah-order",
                title: "What Happened First?",
                subtitle: "Put the story in order.",
                introLine: "Let's tell the story! What happened first?",
                completionLine: "You told the whole story!",
                icon: .rainbow,
                spec: .sequence(steps: [
                    SequenceStep(art: .ark, caption: "Noah builds the ark"),
                    SequenceStep(art: .stormCloud, caption: "The rain comes down"),
                    SequenceStep(art: .rainbow, caption: "A rainbow appears")
                ]),
                reward: Collectible(id: "c-rainbow", name: "Rainbow", art: .rainbow, kind: .badge)
            )
        ],
        bonusReward: Collectible(id: "c-noah", name: "Noah", art: .noah, kind: .character)
    )
}
