import SwiftUI

/// Version 1 content. Future packs append worlds (or add activities to
/// existing worlds) here; nothing else in the app needs to change.
enum ContentLibrary {
    static let worlds: [BibleWorld] = [
        creation,
        noahsArk,
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
                id: "noah-build",
                title: "Build the Ark",
                subtitle: "Use each tool to build!",
                introLine: "Noah needs to build a big ark. Can you help? Use each tool!",
                completionLine: "You built the ark!",
                icon: .arkFrame,
                spec: .actionSequence(start: .arkPlanks, steps: [
                    ActionStep(tool: .saw, prompt: "Saw the wood!", result: .arkFrame),
                    ActionStep(tool: .hammer, prompt: "Hammer the planks!", result: .arkHull),
                    ActionStep(tool: .brush, prompt: "Paint the ark!", result: .ark)
                ]),
                reward: Collectible(id: "c-ark", name: "Ark", art: .ark, kind: .badge)
            ),
            Activity(
                id: "noah-match",
                title: "Match the Animals",
                subtitle: "Find the matching pairs!",
                introLine: "The animals come two by two! Can you find the matching pairs?",
                completionLine: "You matched all the animals!",
                icon: .lion,
                spec: .matchPairs(pool: [.lion, .giraffe, .elephant, .dove, .sheep, .fish]),
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
                spec: .count(item: .dove, littleRange: 3...8, bigRange: 6...12),
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
            ),
            Activity(
                id: "noah-find",
                title: "Find the Tool",
                subtitle: "Help Noah find it!",
                introLine: "Noah needs his tools! Can you find the right one?",
                completionLine: "You found all the tools!",
                icon: .hammer,
                spec: .findIt(items: [.saw, .hammer, .brush]),
                reward: Collectible(id: "c-hammer", name: "Hammer", art: .hammer, kind: .badge)
            ),
            Activity(
                id: "noah-shadow",
                title: "Match the Shadows",
                subtitle: "Find each animal's shadow.",
                introLine: "Every animal has a shadow. Can you match them?",
                completionLine: "You matched every shadow!",
                icon: .elephant,
                spec: .shadowMatch(items: [.lion, .giraffe, .elephant]),
                reward: Collectible(id: "c-sheep", name: "Sheep", art: .sheep, kind: .animal)
            )
        ],
        bonusReward: Collectible(id: "c-noah", name: "Noah", art: .noah, kind: .character)
    )

    // MARK: - Creation (second world)

    static let creation = BibleWorld(
        id: "creation",
        title: "Creation",
        tagline: "The whole world is a gift!",
        icon: .earth,
        accent: Theme.leaf,
        welcomeLine: "God made a beautiful world! Let's explore it. Which game would you like to play?",
        activities: [
            Activity(
                id: "creation-sort",
                title: "Sort the World",
                subtitle: "Land, sea, or sky?",
                introLine: "God made animals for the land, the sea, and the sky! Can you help each one find its home?",
                completionLine: "You sorted them all!",
                icon: .fish,
                spec: .sortClassify(
                    categories: [
                        SortCategory(id: "land", title: "Land", color: Theme.leaf),
                        SortCategory(id: "sea", title: "Sea", color: Theme.sky),
                        SortCategory(id: "sky", title: "Sky", color: Theme.berry)
                    ],
                    items: [
                        SortItem(art: .lion, categoryID: "land"),
                        SortItem(art: .sheep, categoryID: "land"),
                        SortItem(art: .fish, categoryID: "sea"),
                        SortItem(art: .fish, categoryID: "sea"),
                        SortItem(art: .dove, categoryID: "sky"),
                        SortItem(art: .dove, categoryID: "sky")
                    ]
                ),
                reward: Collectible(id: "c-tree", name: "Tree", art: .tree, kind: .badge)
            ),
            Activity(
                id: "creation-count",
                title: "Count the Stars",
                subtitle: "Tap each star to count!",
                introLine: "God filled the night sky with stars. How many can you count?",
                completionLine: "You counted every star!",
                icon: .star,
                spec: .count(item: .star, littleRange: 3...8, bigRange: 6...12),
                reward: Collectible(id: "c-star", name: "Star", art: .star, kind: .badge)
            ),
            Activity(
                id: "creation-order",
                title: "What Came First?",
                subtitle: "Put creation in order.",
                introLine: "Let's remember the days of creation. What came first?",
                completionLine: "You remembered it all!",
                icon: .sun,
                spec: .sequence(steps: [
                    SequenceStep(art: .sun, caption: "God made the light"),
                    SequenceStep(art: .tree, caption: "God made the plants"),
                    SequenceStep(art: .lion, caption: "God made the animals")
                ]),
                reward: Collectible(id: "c-sun", name: "Sun", art: .sun, kind: .badge)
            ),
            Activity(
                id: "creation-match",
                title: "Match the Creations",
                subtitle: "Find the matching pairs!",
                introLine: "God made so many wonderful things! Can you find the matching pairs?",
                completionLine: "You matched them all!",
                icon: .moon,
                spec: .matchPairs(pool: [.sun, .moon, .star, .tree]),
                reward: Collectible(id: "c-moon", name: "Moon", art: .moon, kind: .badge)
            )
        ],
        bonusReward: Collectible(id: "c-earth", name: "World", art: .earth, kind: .character)
    )
}
