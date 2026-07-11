import SwiftUI

/// Version 1 content. Future packs append worlds (or add activities to
/// existing worlds) here; nothing else in the app needs to change.
enum ContentLibrary {
    /// Ordered as a journey through time: Creation → Noah → David → Jonah →
    /// Daniel → Jesus, then our life today — meetings, the ministry, home
    /// life, and the qualities we grow.
    static let worlds: [BibleWorld] = [
        creation,
        noahsArk,
        davidSheep,
        jonahBigFish,
        danielLions,
        jesusFriends,
        meetings,
        ministry,
        activities,
        qualities
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

    // MARK: - Noah's Ark (first playable world)

    static let noahsArk = BibleWorld(
        id: "noah",
        title: "Noah",
        tagline: "He built, he preached, he trusted Jehovah!",
        icon: .noah,
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
                    ActionStep(tool: .brush, prompt: "Coat the ark with tar!", result: .ark)
                ]),
                reward: Collectible(id: "c-ark", name: "Ark", art: .ark, kind: .badge),
                scripture: "Genesis 6:14-16"
            ),
            Activity(
                id: "noah-preach",
                title: "Noah Tells Everyone",
                subtitle: "Share the message with each person.",
                introLine: "Noah was a preacher of righteousness before the Flood. Can you help him share the message?",
                completionLine: "Noah preached righteousness! He was faithful to Jehovah.",
                icon: .scroll,
                spec: .deliver(item: .scroll, source: .noah,
                               targets: [.villagerA, .villagerB, .villagerC],
                               deliverLine: "Noah preached righteousness!"),
                reward: Collectible(id: "c-scroll", name: "Message", art: .scroll, kind: .badge),
                scripture: "2 Peter 2:5"
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
                completionLine: "All the animals on the ark are safe!",
                icon: .elephant,
                spec: .boardTheArk(animals: [.elephant, .giraffe, .lion, .sheep]),
                reward: Collectible(id: "c-elephant", name: "Elephant", art: .elephant, kind: .animal),
                scripture: "Genesis 7:8, 9"
            ),
            Activity(
                id: "noah-count",
                title: "Count the Animals",
                subtitle: "Tap each animal to count!",
                introLine: "So many animals are coming to the ark! How many can you count?",
                completionLine: "You counted all the animals!",
                icon: .giraffe,
                spec: .count(items: [.elephant, .giraffe, .lion, .sheep, .dove], center: nil, labels: nil,
                             littleRange: 3...8, bigRange: 6...12),
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
                    SequenceStep(art: .arkFrame, caption: "Noah builds the ark"),
                    SequenceStep(art: .elephant, caption: "The animals come two by two"),
                    SequenceStep(art: .stormCloud, caption: "The rain falls"),
                    SequenceStep(art: .ark, caption: "The ark floats many days"),
                    SequenceStep(art: .rainbow, caption: "Jehovah puts his rainbow in the cloud")
                ]),
                reward: Collectible(id: "c-rainbow", name: "Rainbow", art: .rainbow, kind: .badge),
                scripture: "Genesis 6–9"
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
                id: "noah-color",
                title: "Color the Rainbow",
                subtitle: "Color it — or tap the magic wand!",
                introLine: "After the Flood, Jehovah put his rainbow in the cloud as a sign of his covenant. Let's color it any way you like!",
                completionLine: "What a beautiful rainbow!",
                icon: .rainbow,
                // Band centers measured from the page's pixels (dark-line
                // scan at x = 50%), so each seed lands in its own band.
                spec: .coloring(page: "coloring_rainbow", seeds: [
                    ColorSeed(x: 0.50, y: 0.183, target: .red),      // outer band
                    ColorSeed(x: 0.50, y: 0.264, target: .orange),
                    ColorSeed(x: 0.50, y: 0.344, target: .yellow),
                    ColorSeed(x: 0.50, y: 0.426, target: .green),
                    ColorSeed(x: 0.50, y: 0.507, target: .blue),     // inner band
                    ColorSeed(x: 0.13, y: 0.167, target: .yellow),   // sun
                    ColorSeed(x: 0.60, y: 0.060, target: .blue),     // sky above
                    ColorSeed(x: 0.50, y: 0.667, target: .blue),     // sky under the arch
                    ColorSeed(x: 0.50, y: 0.830, target: .green)     // grassy hill
                ]),
                reward: Collectible(id: "c-rainbow-colors", name: "Rainbow Colors", art: .rainbow, kind: .badge),
                scripture: "Genesis 9:13"
            ),
            Activity(
                id: "noah-color-ark",
                title: "Color the Ark",
                subtitle: "Color it — or tap the magic wand!",
                introLine: "The ark floated safely on the waters, and Noah and the animals were safe inside! Color the ark any way you like!",
                completionLine: "The ark is safe on the water!",
                icon: .ark,
                // Seed spots measured from the page's pixels (dark-line scans).
                // Noah and the dove are left unseeded — the child's free choice.
                spec: .coloring(page: "coloring_ark", seeds: [
                    ColorSeed(x: 0.50, y: 0.112, target: .orange),   // roof, upper band
                    ColorSeed(x: 0.50, y: 0.147, target: .orange),   // roof, lower band
                    ColorSeed(x: 0.12, y: 0.158, target: .orange),   // roof, left slope
                    ColorSeed(x: 0.50, y: 0.228, target: .brown),    // wall top, mid
                    ColorSeed(x: 0.12, y: 0.224, target: .brown),    // wall top, left
                    ColorSeed(x: 0.50, y: 0.298, target: .brown),    // plank strips (mid)
                    ColorSeed(x: 0.50, y: 0.398, target: .brown),
                    ColorSeed(x: 0.50, y: 0.508, target: .brown),
                    ColorSeed(x: 0.50, y: 0.598, target: .brown),
                    ColorSeed(x: 0.12, y: 0.293, target: .brown),    // plank strips (left of door)
                    ColorSeed(x: 0.12, y: 0.391, target: .brown),
                    ColorSeed(x: 0.12, y: 0.496, target: .brown),
                    ColorSeed(x: 0.12, y: 0.592, target: .brown),
                    ColorSeed(x: 0.50, y: 0.735, target: .blue),     // wave bands
                    ColorSeed(x: 0.50, y: 0.829, target: .blue),
                    ColorSeed(x: 0.50, y: 0.945, target: .blue),
                    ColorSeed(x: 0.05, y: 0.050, target: .blue)      // sky
                ]),
                reward: Collectible(id: "c-safe-ark", name: "Safe Ark", art: .ark, kind: .badge),
                scripture: "Genesis 7:17, 18"
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
                        SortItem(art: .bird, categoryID: "sky"),
                        SortItem(art: .bird, categoryID: "sky")
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
                spec: .count(items: [.star], center: nil, labels: nil, littleRange: 3...8, bigRange: 6...12),
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
                    SequenceStep(art: .light, caption: "Jehovah made the light"),
                    SequenceStep(art: .tree, caption: "Jehovah made the plants"),
                    SequenceStep(art: .lion, caption: "Jehovah made the animals"),
                    SequenceStep(art: .people, caption: "Jehovah made people")
                ]),
                reward: Collectible(id: "c-sun", name: "Sun", art: .sun, kind: .badge),
                scripture: "Genesis 1"
            ),
            Activity(
                id: "creation-color",
                title: "Color the Garden",
                subtitle: "Color it — or tap the magic wand!",
                introLine: "Jehovah made a beautiful garden! Let's color it any way you like.",
                completionLine: "The garden looks beautiful!",
                icon: .tree,
                spec: .coloring(page: "coloring_garden", seeds: [
                    ColorSeed(x: 0.45, y: 0.12, target: .green),    // canopy
                    ColorSeed(x: 0.35, y: 0.217, target: .orange),  // fruits
                    ColorSeed(x: 0.593, y: 0.21, target: .orange),
                    ColorSeed(x: 0.477, y: 0.357, target: .orange),
                    ColorSeed(x: 0.33, y: 0.471, target: .orange),
                    ColorSeed(x: 0.627, y: 0.471, target: .orange),
                    ColorSeed(x: 0.48, y: 0.829, target: .brown),   // trunk
                    ColorSeed(x: 0.863, y: 0.16, target: .yellow),  // sun
                    ColorSeed(x: 0.143, y: 0.645, target: .red),    // left flower petals
                    ColorSeed(x: 0.148, y: 0.71, target: .yellow),  // left flower center
                    ColorSeed(x: 0.808, y: 0.638, target: .purple), // right flower petals
                    ColorSeed(x: 0.812, y: 0.703, target: .yellow), // right flower center
                    ColorSeed(x: 0.103, y: 0.857, target: .green),  // left leaves
                    ColorSeed(x: 0.787, y: 0.854, target: .green),  // right leaves
                    ColorSeed(x: 0.50, y: 0.965, target: .green),   // grassy hill
                    ColorSeed(x: 0.07, y: 0.08, target: .blue)      // sky
                ]),
                reward: Collectible(id: "c-garden-tree", name: "Garden Tree", art: .tree, kind: .badge),
                scripture: "Genesis 2:9"
            ),
            Activity(
                id: "creation-name",
                title: "Name the Animals",
                subtitle: "Help Adam find each animal.",
                introLine: "Adam gave names to the animals! Can you find each one?",
                completionLine: "You found all the animals Adam named!",
                icon: .adam,
                spec: .findIt(items: [.lion, .elephant, .sheep, .bird]),
                reward: Collectible(id: "c-adam", name: "Adam", art: .adam, kind: .character),
                scripture: "Genesis 2:19"
            ),
            Activity(
                id: "creation-grow",
                title: "Grow the Garden",
                subtitle: "Help the little tree grow!",
                introLine: "Jehovah makes plants grow! Can you help this tree? Use each tool!",
                completionLine: "You grew a beautiful tree!",
                icon: .sprout,
                spec: .actionSequence(start: .soil, steps: [
                    ActionStep(tool: .seed, prompt: "Plant the seed!", result: .sprout),
                    ActionStep(tool: .wateringCan, prompt: "Water the sprout!", result: .sapling),
                    ActionStep(tool: .sun, prompt: "Let the sun shine!", result: .tree)
                ]),
                reward: Collectible(id: "c-wateringcan", name: "Watering Can", art: .wateringCan, kind: .badge)
            ),
            Activity(
                id: "creation-shadow",
                title: "Shadow Garden",
                subtitle: "Match each creation to its shadow.",
                introLine: "Everything Jehovah made has a shape! Can you match the shadows?",
                completionLine: "You matched every shadow!",
                icon: .moon,
                spec: .shadowMatch(items: [.sun, .tree, .fish]),
                reward: Collectible(id: "c-fish", name: "Fish", art: .fish, kind: .animal)
            ),
            Activity(
                id: "creation-gather",
                title: "Fruit from the Garden",
                subtitle: "Pick good fruit — but not from that tree!",
                introLine: "The garden is full of good fruit! Pick some for Adam and Eve. But remember — Jehovah said not to take from that one tree.",
                completionLine: "You picked such good fruit — and you listened to Jehovah!",
                icon: .fruit,
                spec: .gather(item: .fruit, count: 4, container: .basket,
                              scenery: .tree, decoyGuard: .serpent,
                              decoyLine: "No — Jehovah said not from that tree."),
                reward: Collectible(id: "c-fruit", name: "Fruit", art: .fruit, kind: .badge),
                scripture: "Genesis 2:16, 17"
            )
        ],
        bonusReward: Collectible(id: "c-earth", name: "World", art: .earth, kind: .character)
    )

    // MARK: - David & the Sheep

    static let davidSheep = BibleWorld(
        id: "david",
        title: "David",
        tagline: "Shepherd, singer, brave friend of Jehovah!",
        icon: .david,
        accent: Theme.sunny,
        welcomeLine: "David took good care of his sheep, and Jehovah took good care of David!",
        activities: [
            Activity(
                id: "david-count",
                title: "Count the Sheep",
                subtitle: "Tap each sheep to count!",
                introLine: "David watched over every single sheep. How many can you count?",
                completionLine: "You counted the whole flock!",
                icon: .sheep,
                spec: .count(items: [.sheep], center: .david, labels: nil, littleRange: 3...8, bigRange: 6...12),
                reward: Collectible(id: "c-lamb", name: "Lamb", art: .sheep, kind: .animal),
                scripture: "Psalm 23:1, 2"
            ),
            Activity(
                id: "david-water",
                title: "Water for the Sheep",
                subtitle: "Give every sheep a drink.",
                introLine: "A good shepherd brings water to his sheep. Can you help David?",
                completionLine: "Every sheep had a cool drink!",
                icon: .bucket,
                spec: .deliver(item: .bucket, source: .david,
                               targets: [.sheep, .sheep, .sheep],
                               deliverLine: "A cool drink for the sheep!"),
                reward: Collectible(id: "c-bucket", name: "Water Bucket", art: .bucket, kind: .badge),
                scripture: "Psalm 23:2"
            ),
            Activity(
                id: "david-pen",
                title: "Build the Sheep Pen",
                subtitle: "Use each tool to build!",
                introLine: "Let's build a safe pen for the sheep!",
                completionLine: "The sheep are safe in their pen!",
                icon: .pen,
                spec: .actionSequence(start: .arkPlanks, steps: [
                    ActionStep(tool: .saw, prompt: "Saw the wood!", result: .penFrame),
                    ActionStep(tool: .hammer, prompt: "Hammer the fence!", result: .pen),
                    ActionStep(tool: .staff, prompt: "Bring the sheep home!", result: .penFull)
                ]),
                reward: Collectible(id: "c-pen", name: "Sheep Pen", art: .penFull, kind: .badge),
                scripture: "1 Samuel 16:11"
            ),
            Activity(
                id: "david-order",
                title: "David Is Brave",
                subtitle: "Put the story in order.",
                introLine: "One day a lion carried off a sheep! Let's tell what happened.",
                completionLine: "Jehovah helped David be brave!",
                icon: .david,
                spec: .sequence(steps: [
                    SequenceStep(art: .sheep, caption: "David watched the sheep"),
                    SequenceStep(art: .lion, caption: "A lion carried off a sheep"),
                    SequenceStep(art: .david, caption: "David rescued the sheep"),
                    SequenceStep(art: .heart, caption: "The sheep was safe!")
                ]),
                reward: Collectible(id: "c-courage", name: "Courage", art: .heart, kind: .badge),
                scripture: "1 Samuel 17:34-36"
            ),
            Activity(
                id: "david-match",
                title: "Match David's Things",
                subtitle: "Find the matching pairs!",
                introLine: "David had a harp, a sling, and a staff! Can you find the pairs?",
                completionLine: "You matched them all!",
                icon: .harp,
                spec: .matchPairs(pool: [.sheep, .harp, .sling, .staff, .lion, .bucket]),
                reward: Collectible(id: "c-harp", name: "Harp", art: .harp, kind: .badge),
                scripture: "1 Samuel 16:23; 17:40"
            ),
            Activity(
                id: "david-stones",
                title: "Five Smooth Stones",
                subtitle: "Put five stones in David's bag.",
                introLine: "David chose five smooth stones from the stream. He trusted Jehovah to help him! Can you count out five?",
                completionLine: "Five smooth stones — and David trusted Jehovah!",
                icon: .stone,
                spec: .giveNumber(item: .stone, container: .bag,
                                  distractors: [.fruit, .seed],
                                  littleRange: 5...5, bigRange: 5...5),
                reward: Collectible(id: "c-sling", name: "Sling", art: .sling, kind: .badge),
                scripture: "1 Samuel 17:40"
            ),
            Activity(
                id: "david-lead",
                title: "Lead the Sheep Home",
                subtitle: "Step by step to the pen!",
                introLine: "A good shepherd leads his sheep home. Walk the little sheep past the trees, one step at a time!",
                completionLine: "The sheep followed the shepherd all the way home!",
                icon: .staff,
                spec: .pathway(walker: .sheep, goal: .pen, blocker: .tree, prize: .star),
                reward: Collectible(id: "c-staff", name: "Staff", art: .staff, kind: .badge),
                scripture: "Psalm 23:2, 3"
            ),
            Activity(
                id: "david-flock",
                title: "Gather the Flock",
                subtitle: "Bring every sheep to the pen.",
                introLine: "Night is coming! Help David gather every sheep safely into the pen.",
                completionLine: "The whole flock is safely in the pen!",
                icon: .sheep,
                spec: .gather(item: .sheep, count: 4, container: .pen,
                              scenery: nil, decoyGuard: nil, decoyLine: nil),
                reward: Collectible(id: "c-flock", name: "Flock", art: .sheep, kind: .animal),
                scripture: "Psalm 23:1"
            )
        ],
        bonusReward: Collectible(id: "c-david", name: "David", art: .david, kind: .character)
    )

    // MARK: - Daniel & the Lions

    static let danielLions = BibleWorld(
        id: "daniel",
        title: "Daniel",
        tagline: "Faithful every single day!",
        icon: .daniel,
        accent: Theme.berry,
        welcomeLine: "Daniel loved Jehovah and prayed every single day — no matter what!",
        activities: [
            Activity(
                id: "daniel-pray",
                title: "Three Times a Day",
                subtitle: "Give the window three stars.",
                introLine: "Daniel prayed to Jehovah three times every day. Put a star in the window for each prayer!",
                completionLine: "Three times a day — Daniel always prayed!",
                icon: .window,
                spec: .giveNumber(item: .star, container: .window,
                                  distractors: [.moon, .sun],
                                  littleRange: 3...3, bigRange: 3...3),
                reward: Collectible(id: "c-window", name: "Window", art: .window, kind: .badge),
                scripture: "Daniel 6:10"
            ),
            Activity(
                id: "daniel-order",
                title: "Daniel's Night",
                subtitle: "Put the story in order.",
                introLine: "Daniel kept praying, so he was put with the lions! Let's tell what happened.",
                completionLine: "Jehovah kept Daniel safe all night!",
                icon: .angel,
                spec: .sequence(steps: [
                    SequenceStep(art: .daniel, caption: "Daniel prayed to Jehovah"),
                    SequenceStep(art: .lion, caption: "Daniel was put with the lions"),
                    SequenceStep(art: .angel, caption: "The angel shut their mouths"),
                    SequenceStep(art: .sun, caption: "In the morning, Daniel was safe!")
                ]),
                reward: Collectible(id: "c-morning-sun", name: "Morning", art: .sun, kind: .badge),
                scripture: "Daniel 6:16-22"
            ),
            Activity(
                id: "daniel-angel",
                title: "The Angel Shuts Their Mouths",
                subtitle: "Send the angel to each lion.",
                introLine: "Jehovah sent his angel to protect Daniel and shut the mouths of the lions. Send the angel to each lion!",
                completionLine: "The angel shut every lion's mouth — Daniel was safe!",
                icon: .angel,
                spec: .deliver(item: .angel, source: .daniel,
                               targets: [.lion, .lion, .lion],
                               deliverLine: "The angel shut the lion's mouth!"),
                reward: Collectible(id: "c-angel", name: "Angel", art: .angel, kind: .character),
                scripture: "Daniel 6:22"
            ),
            Activity(
                id: "daniel-count",
                title: "Count the Lions",
                subtitle: "Tap each lion to count!",
                introLine: "Daniel was in the den, and Jehovah kept him safe. How many lions can you count around him?",
                completionLine: "You counted every lion — and Daniel was safe the whole time!",
                icon: .lion,
                spec: .count(items: [.lion], center: .daniel, labels: nil, littleRange: 3...8, bigRange: 6...12),
                reward: Collectible(id: "c-den-lion", name: "Den Lion", art: .lion, kind: .animal),
                scripture: "Daniel 6:16"
            ),
            Activity(
                id: "daniel-match",
                title: "Match the Palace",
                subtitle: "Find the matching pairs!",
                introLine: "Daniel served the king faithfully. Can you find the pairs?",
                completionLine: "You matched them all!",
                icon: .crown,
                spec: .matchPairs(pool: [.lion, .crown, .star, .moon, .angel, .window]),
                reward: Collectible(id: "c-crown", name: "Crown", art: .crown, kind: .badge),
                scripture: "Daniel 6:1-3"
            ),
            Activity(
                id: "daniel-steps",
                title: "Faithful Steps",
                subtitle: "Walk calmly to the window.",
                introLine: "When Daniel learned that the law had been signed, he went home and prayed — just as he had always done. Walk with him, one step at a time.",
                completionLine: "Daniel kept praying to Jehovah!",
                icon: .window,
                spec: .pathway(walker: .daniel, goal: .window, blocker: .villagerA, prize: .star),
                reward: Collectible(id: "c-daniel-moon", name: "Night Moon", art: .moon, kind: .badge),
                scripture: "Daniel 6:10, 11"
            ),
            Activity(
                id: "daniel-sort",
                title: "Morning and Night",
                subtitle: "Sort morning and night!",
                introLine: "Daniel prayed three times each day — every day! What belongs to the morning, and what belongs to the night?",
                completionLine: "You sorted the morning and the night!",
                icon: .moon,
                spec: .sortClassify(
                    categories: [
                        SortCategory(id: "morning", title: "Morning", color: Theme.sunny),
                        SortCategory(id: "night", title: "Night", color: Theme.berry)
                    ],
                    items: [
                        SortItem(art: .sun, categoryID: "morning"),
                        SortItem(art: .bird, categoryID: "morning"),
                        SortItem(art: .fruit, categoryID: "morning"),
                        SortItem(art: .moon, categoryID: "night"),
                        SortItem(art: .star, categoryID: "night"),
                        SortItem(art: .window, categoryID: "night")
                    ]
                ),
                reward: Collectible(id: "c-faithful-heart", name: "Faithful Heart", art: .heart, kind: .badge),
                scripture: "Daniel 6:10"
            ),
            Activity(
                id: "daniel-color",
                title: "Color the Morning",
                subtitle: "Color it — or tap the magic wand!",
                introLine: "At the first light of dawn, the king hurried to the lions' pit — and Daniel was safe! Let's color the happy morning.",
                completionLine: "The night is over — what a beautiful morning!",
                icon: .sun,
                spec: .coloring(page: "coloring_morning", seeds: [
                    ColorSeed(x: 0.22, y: 0.55, target: .purple),   // Daniel's robe
                    ColorSeed(x: 0.31, y: 0.67, target: .yellow),   // sash drape
                    ColorSeed(x: 0.20, y: 0.13, target: .brown),    // hair
                    ColorSeed(x: 0.265, y: 0.345, target: .brown),  // beard
                    ColorSeed(x: 0.68, y: 0.33, target: .yellow),   // rising sun
                    ColorSeed(x: 0.585, y: 0.145, target: .orange), // sunrise sky
                    ColorSeed(x: 0.55, y: 0.415, target: .green),   // hills
                    ColorSeed(x: 0.47, y: 0.57, target: .gray),     // city buildings
                    ColorSeed(x: 0.83, y: 0.52, target: .brown),    // watchtower
                    ColorSeed(x: 0.945, y: 0.30, target: .brown),   // window frame
                    ColorSeed(x: 0.60, y: 0.755, target: .brown),   // window sill
                    ColorSeed(x: 0.07, y: 0.60, target: .green),    // left plant
                    ColorSeed(x: 0.075, y: 0.80, target: .orange),  // left pot
                    ColorSeed(x: 0.755, y: 0.79, target: .green),   // right plant
                    ColorSeed(x: 0.75, y: 0.90, target: .orange)    // right pot
                ]),
                reward: Collectible(id: "c-daniel-star", name: "Bright Star", art: .star, kind: .badge),
                scripture: "Daniel 6:19"
            )
        ],
        bonusReward: Collectible(id: "c-daniel", name: "Daniel", art: .daniel, kind: .character)
    )

    // MARK: - Jonah & the Big Fish

    static let jonahBigFish = BibleWorld(
        id: "jonah",
        title: "Jonah",
        tagline: "A big fish and a big lesson!",
        icon: .jonah,
        accent: Color(red: 0.30, green: 0.62, blue: 0.62),
        welcomeLine: "Jonah learned that it is always best to listen to Jehovah!",
        activities: [
            Activity(
                id: "jonah-order",
                title: "Jonah's Journey",
                subtitle: "Put the story in order.",
                introLine: "Jonah ran away on a boat — but Jehovah had a plan! Let's tell the story.",
                completionLine: "Jonah listened to Jehovah after all!",
                icon: .bigFish,
                spec: .sequence(steps: [
                    SequenceStep(art: .boat, caption: "Jonah sailed away"),
                    SequenceStep(art: .stormCloud, caption: "A big storm came"),
                    SequenceStep(art: .bigFish, caption: "A big fish swallowed Jonah"),
                    SequenceStep(art: .jonah, caption: "Jonah prayed to Jehovah"),
                    SequenceStep(art: .sun, caption: "Jonah was safe on land!")
                ]),
                reward: Collectible(id: "c-bigfish", name: "Big Fish", art: .bigFish, kind: .animal),
                scripture: "Jonah 1, 2"
            ),
            Activity(
                id: "jonah-nights",
                title: "Three Days, Three Nights",
                subtitle: "Give the big fish three moons.",
                introLine: "Jonah was inside the big fish for three days and three nights. Put up a moon for each night!",
                completionLine: "Three nights — and Jonah prayed to Jehovah!",
                icon: .moon,
                spec: .giveNumber(item: .moon, container: .bigFish,
                                  distractors: [.star, .fish],
                                  littleRange: 3...3, bigRange: 3...3),
                reward: Collectible(id: "c-three-moons", name: "Three Nights", art: .moon, kind: .badge),
                scripture: "Jonah 1:17"
            ),
            Activity(
                id: "jonah-preach",
                title: "Jonah Tells Nineveh",
                subtitle: "Share the message with each person.",
                introLine: "Jehovah sent Jonah to the big city of Nineveh. Help Jonah share the message — and this time, the people listened!",
                completionLine: "The people of Nineveh listened and changed!",
                icon: .scroll,
                spec: .deliver(item: .scroll, source: .jonah,
                               targets: [.villagerA, .villagerB, .villagerC],
                               deliverLine: "The people listened!"),
                reward: Collectible(id: "c-changed-heart", name: "Changed Heart", art: .heart, kind: .badge),
                scripture: "Jonah 3:4, 5"
            ),
            Activity(
                id: "jonah-count",
                title: "Count the Fish",
                subtitle: "Tap each fish to count!",
                introLine: "The sea is full of fish that Jehovah made! How many can you count?",
                completionLine: "You counted every fish!",
                icon: .fish,
                spec: .count(items: [.fish], center: nil, labels: nil, littleRange: 3...8, bigRange: 6...12),
                reward: Collectible(id: "c-sea-fish", name: "Sea Fish", art: .fish, kind: .animal),
                scripture: "Genesis 1:20, 21"
            ),
            Activity(
                id: "jonah-plant",
                title: "The Shade Plant",
                subtitle: "Help the plant grow tall!",
                introLine: "Jehovah made a leafy plant grow up over Jonah to give him shade. Help it grow!",
                completionLine: "What wonderful shade — Jehovah is kind!",
                icon: .sprout,
                spec: .actionSequence(start: .soil, steps: [
                    ActionStep(tool: .seed, prompt: "Jehovah made it grow!", result: .sprout),
                    ActionStep(tool: .moon, prompt: "It grew overnight!", result: .sapling),
                    ActionStep(tool: .sun, prompt: "Shade for Jonah!", result: .tree)
                ]),
                reward: Collectible(id: "c-shade-plant", name: "Shade Plant", art: .sprout, kind: .badge),
                scripture: "Jonah 4:6"
            ),
            Activity(
                id: "jonah-find",
                title: "Find It at Sea",
                subtitle: "Find the one that matches!",
                introLine: "Look out at the sea! Can you find each one?",
                completionLine: "You found them all!",
                icon: .stormCloud,
                spec: .findIt(items: [.boat, .bigFish, .fish, .stormCloud]),
                reward: Collectible(id: "c-storm", name: "Storm Cloud", art: .stormCloud, kind: .badge),
                scripture: "Jonah 1:4"
            ),
            Activity(
                id: "jonah-sort",
                title: "Sea and Sky",
                subtitle: "Where does each one belong?",
                introLine: "Some things belong in the sea, and some belong in the sky! Can you sort them?",
                completionLine: "You sorted the sea and the sky!",
                icon: .bird,
                spec: .sortClassify(
                    categories: [
                        SortCategory(id: "sea", title: "Sea", color: Theme.sky),
                        SortCategory(id: "sky", title: "Sky", color: Theme.berry)
                    ],
                    items: [
                        SortItem(art: .fish, categoryID: "sea"),
                        SortItem(art: .bigFish, categoryID: "sea"),
                        SortItem(art: .boat, categoryID: "sea"),
                        SortItem(art: .bird, categoryID: "sky"),
                        SortItem(art: .stormCloud, categoryID: "sky"),
                        SortItem(art: .star, categoryID: "sky")
                    ]
                ),
                reward: Collectible(id: "c-sky-dove", name: "Sky Bird", art: .bird, kind: .badge),
                scripture: "Genesis 1:20, 21"
            ),
            Activity(
                id: "jonah-shadow",
                title: "Sea Shadows",
                subtitle: "Match each one to its shadow.",
                introLine: "The sea makes shadowy shapes! Can you match them?",
                completionLine: "You matched every shadow!",
                icon: .fish,
                spec: .shadowMatch(items: [.bigFish, .boat, .fish]),
                reward: Collectible(id: "c-night-sea", name: "Night Sea", art: .moon, kind: .badge)
            )
        ],
        bonusReward: Collectible(id: "c-jonah", name: "Jonah", art: .jonah, kind: .character)
    )

    // MARK: - Jesus & His Friends

    static let jesusFriends = BibleWorld(
        id: "jesus",
        title: "Jesus",
        tagline: "Learn to be kind like Jesus!",
        icon: .jesus,
        accent: Theme.coral,
        welcomeLine: "Jesus loved people and taught them all about Jehovah!",
        activities: [
            Activity(
                id: "jesus-order",
                title: "Hush! Be Quiet!",
                subtitle: "Put the story in order.",
                introLine: "One evening a great storm rocked the boat — but Jesus calmed it! Let's tell the story.",
                completionLine: "Even the wind and the sea obey Jesus!",
                icon: .boat,
                spec: .sequence(steps: [
                    SequenceStep(art: .boat, caption: "Jesus and his friends sailed"),
                    SequenceStep(art: .stormCloud, caption: "A big storm came"),
                    SequenceStep(art: .jesus, caption: "Jesus said, Hush! Be quiet!"),
                    SequenceStep(art: .sun, caption: "A great calm set in")
                ]),
                reward: Collectible(id: "c-calm-sea", name: "Calm Sea", art: .sun, kind: .badge),
                scripture: "Mark 4:35-41"
            ),
            Activity(
                id: "jesus-bread",
                title: "Bread for Everyone",
                subtitle: "Give bread to each person.",
                introLine: "A big crowd was hungry, and Jesus fed them all! Help share the bread.",
                completionLine: "Everyone had plenty to eat!",
                icon: .bread,
                spec: .deliver(item: .bread, source: .jesus,
                               targets: [.villagerA, .people, .villagerC],
                               deliverLine: "Everyone had plenty to eat!"),
                reward: Collectible(id: "c-bread", name: "Bread", art: .bread, kind: .badge),
                scripture: "Matthew 14:19-21"
            ),
            Activity(
                id: "jesus-wine",
                title: "Water into Wine",
                subtitle: "Help with the very first miracle!",
                introLine: "At a wedding feast, the wine ran out. Jesus performed his very first miracle! Fill the big jars with water and watch what happens.",
                completionLine: "The water became fine wine — Jesus' first miracle!",
                icon: .jar,
                spec: .actionSequence(start: .jars0, steps: [
                    ActionStep(tool: .bucket, prompt: "Fill all the jars with water!", result: .jars3,
                               reps: 3, repResults: [.jars1, .jars2]),
                    ActionStep(tool: .star, prompt: "Jesus performs the miracle!", result: .jarsWine)
                ]),
                reward: Collectible(id: "c-wine-jars", name: "Wine Jars", art: .jarWine, kind: .badge),
                scripture: "John 2:1-11"
            ),
            Activity(
                id: "jesus-gather",
                title: "Gather the Leftovers",
                subtitle: "Fill the basket with bread.",
                introLine: "After everyone ate, there was still bread left over — twelve baskets full! Help gather it up.",
                completionLine: "They gathered twelve baskets of leftovers!",
                icon: .basket,
                spec: .gather(item: .bread, count: 4, container: .basket,
                              scenery: nil, decoyGuard: nil, decoyLine: nil),
                reward: Collectible(id: "c-twelve-baskets", name: "Twelve Baskets", art: .basket, kind: .badge),
                scripture: "Matthew 14:20"
            ),
            Activity(
                id: "jesus-sheep",
                title: "The Lost Sheep",
                subtitle: "Find the one that matches!",
                introLine: "A shepherd looks for his lost sheep until he finds it! Can you find each one?",
                completionLine: "You found the lost sheep — time to celebrate!",
                icon: .sheep,
                spec: .findIt(items: [.sheep, .tree, .star, .basket]),
                reward: Collectible(id: "c-lost-sheep", name: "Lost Sheep", art: .sheep, kind: .badge),
                scripture: "Luke 15:4-7"
            ),
            Activity(
                id: "jesus-apostles",
                title: "Name the Apostles",
                subtitle: "Tap each friend to meet him!",
                introLine: "Jesus chose twelve apostles to be his special helpers. Tap each friend to hear his name!",
                completionLine: "The apostles went out to preach the good news!",
                icon: .jesus,
                spec: .count(items: [.villagerA, .villagerB, .villagerC], center: .jesus,
                             labels: ["Peter", "Andrew", "James", "John", "Philip",
                                      "Bartholomew", "Matthew", "Thomas", "James",
                                      "Simon", "Judas", "Judas Iscariot"],
                             littleRange: 5...8, bigRange: 12...12),
                reward: Collectible(id: "c-twelve", name: "The Twelve", art: .star, kind: .badge),
                scripture: "Luke 6:13-16; 9:1, 2, 6"
            ),
            Activity(
                id: "jesus-come",
                title: "Come to Jesus",
                subtitle: "Walk all the way to Jesus!",
                introLine: "The disciples tried to stop the children from coming. But Jesus said, Let the young children come to me! Walk to Jesus, one step at a time.",
                completionLine: "Jesus warmly welcomed the children!",
                icon: .child,
                spec: .pathway(walker: .child, goal: .jesus, blocker: .villagerA, prize: .heart),
                reward: Collectible(id: "c-jesus-heart", name: "Welcomed", art: .heart, kind: .badge),
                scripture: "Mark 10:13-16"
            ),
            Activity(
                id: "jesus-shadow",
                title: "Galilee Shadows",
                subtitle: "Match each one to its shadow.",
                introLine: "The evening sun makes long shadows by the sea! Can you match them?",
                completionLine: "You matched every shadow!",
                icon: .boat,
                spec: .shadowMatch(items: [.boat, .sheep, .fish]),
                reward: Collectible(id: "c-galilee-boat", name: "Little Boat", art: .boat, kind: .badge),
                scripture: "Matthew 13:1, 2"
            )
        ],
        bonusReward: Collectible(id: "c-jesus", name: "Jesus", art: .jesus, kind: .character)
    )

    // MARK: - Meetings & Conventions

    static let meetings = BibleWorld(
        id: "meetings",
        title: "Meetings",
        tagline: "Get ready — it's meeting day!",
        icon: .hall,
        accent: Theme.wood,
        welcomeLine: "We love going to the meeting to learn about Jehovah with our friends!",
        activities: [
            Activity(
                id: "meet-pack",
                title: "Pack Your Meeting Bag",
                subtitle: "Put each thing in the bag!",
                introLine: "It's almost meeting time! Let's pack your bag. What do we need?",
                completionLine: "Your bag is ready for the meeting!",
                icon: .bag,
                spec: .actionSequence(start: .bag, steps: [
                    ActionStep(tool: .book, prompt: "Pack your Bible!", result: .bagWithBook),
                    ActionStep(tool: .songbook, prompt: "Pack the songbook!", result: .bagPacked)
                ]),
                reward: Collectible(id: "c-bag", name: "Meeting Bag", art: .bagPacked, kind: .badge),
                scripture: "Hebrews 10:24, 25"
            ),
            Activity(
                id: "meet-order",
                title: "Meeting Day!",
                subtitle: "Put meeting day in order.",
                introLine: "What do we do on meeting day? Let's put it in order!",
                completionLine: "What a happy meeting day!",
                icon: .hall,
                spec: .sequence(steps: [
                    SequenceStep(art: .bag, caption: "Pack your bag"),
                    SequenceStep(art: .hall, caption: "Go to the meeting"),
                    SequenceStep(art: .songbook, caption: "Sing together"),
                    SequenceStep(art: .book, caption: "Listen and learn")
                ]),
                reward: Collectible(id: "c-meeting-star", name: "Meeting Star", art: .star, kind: .badge),
                scripture: "Psalm 122:1"
            ),
            Activity(
                id: "meet-share",
                title: "Helping Hands",
                subtitle: "Give a songbook to each friend.",
                introLine: "Helpers make everyone feel welcome! Give a songbook to each friend.",
                completionLine: "Everyone is ready to sing!",
                icon: .songbook,
                spec: .deliver(item: .songbook, source: .friendB,
                               targets: [.friendA, .friendC, .child],
                               deliverLine: "Here's a songbook for you!"),
                reward: Collectible(id: "c-songbook", name: "Songbook", art: .songbook, kind: .badge),
                scripture: "Psalm 133:1"
            ),
            Activity(
                id: "meet-chairs",
                title: "Set Up the Chairs",
                subtitle: "Help set up for the meeting.",
                introLine: "Our friends are coming! Help set up the chairs before the meeting starts.",
                completionLine: "The hall is ready — thank you, little helper!",
                icon: .chair,
                spec: .giveNumber(item: .chair, container: .hall,
                                  distractors: [.songbook, .bag],
                                  littleRange: 3...5, bigRange: 4...8),
                reward: Collectible(id: "c-chair", name: "Chair", art: .chair, kind: .badge),
                scripture: "Hebrews 10:24, 25"
            ),
            Activity(
                id: "meet-sort",
                title: "What Goes in the Bag?",
                subtitle: "Take it along, or leave it home?",
                introLine: "Some things come to the meeting, and some things stay home! Can you sort them?",
                completionLine: "You packed just the right things!",
                icon: .bag,
                spec: .sortClassify(
                    categories: [
                        SortCategory(id: "take", title: "Take Along", color: Theme.leaf),
                        SortCategory(id: "home", title: "Leave Home", color: Theme.wood)
                    ],
                    items: [
                        SortItem(art: .book, categoryID: "take"),
                        SortItem(art: .songbook, categoryID: "take"),
                        SortItem(art: .fruit, categoryID: "take"),
                        SortItem(art: .saw, categoryID: "home"),
                        SortItem(art: .hammer, categoryID: "home"),
                        SortItem(art: .wateringCan, categoryID: "home")
                    ]
                ),
                reward: Collectible(id: "c-ready", name: "All Ready!", art: .star, kind: .badge),
                scripture: "Hebrews 10:24, 25"
            ),
            Activity(
                id: "meet-count",
                title: "Count Your Friends",
                subtitle: "Tap each friend to count!",
                introLine: "Look how many friends came to the meeting! How many can you count?",
                completionLine: "So many friends learning about Jehovah!",
                icon: .friendA,
                spec: .count(items: [.friendA, .friendB, .friendC], center: nil, labels: nil,
                             littleRange: 3...8, bigRange: 6...12),
                reward: Collectible(id: "c-friend", name: "Friend", art: .friendB, kind: .character),
                scripture: "Psalm 133:1"
            ),
            Activity(
                id: "meet-clean",
                title: "Clean the Hall",
                subtitle: "Wipe every spot until it shines!",
                introLine: "Our meeting place should be clean and beautiful! Sweep the floor, wipe the chairs, and wash the windows.",
                completionLine: "The hall is shiny clean and ready!",
                icon: .broom,
                // No floating surface art — the Kingdom Hall world background
                // IS the place being cleaned.
                spec: .cleanUp(surface: nil, tasks: [
                    CleanTask(tool: .broom, messCount: 3, prompt: "Sweep the floor!"),
                    CleanTask(tool: .cloth, messCount: 3, prompt: "Wipe the chairs!", target: .chair),
                    CleanTask(tool: .spray, messCount: 3, prompt: "Wash the windows!", target: .hallWindow)
                ]),
                reward: Collectible(id: "c-hall", name: "Meeting Place", art: .hall, kind: .badge),
                scripture: "1 Corinthians 14:40"
            ),
            Activity(
                id: "meet-speaker",
                title: "Meet the Speaker",
                subtitle: "Walk nicely down the aisle.",
                introLine: "Let's go say hello to the speaker! Walk carefully past our friends.",
                completionLine: "You said such a nice hello — and you walked the whole way!",
                icon: .child,
                spec: .pathway(walker: .child, goal: .speaker, blocker: .friendB, prize: .star),
                reward: Collectible(id: "c-bible", name: "My Bible", art: .book, kind: .badge),
                scripture: "Romans 12:10"
            )
        ],
        bonusReward: Collectible(id: "c-family", name: "My Family", art: .people, kind: .character)
    )

    // MARK: - Christian Qualities

    static let qualities = BibleWorld(
        id: "qualities",
        title: "Christian Qualities",
        tagline: "Grow the fruitage of the spirit!",
        icon: .tree,
        accent: Theme.grassDeep,
        welcomeLine: "Jehovah's spirit helps us develop nine beautiful qualities — love, joy, peace, and more!",
        activities: [
            Activity(
                id: "qual-love",
                title: "Love",
                subtitle: "Give a heart to each friend.",
                introLine: "The first quality is love! Jesus said to love one another. Share a heart with everyone.",
                completionLine: "Love makes every day brighter!",
                icon: .heart,
                spec: .deliver(item: .heart, source: .people,
                               targets: [.villagerA, .villagerB, .villagerC],
                               deliverLine: "That was so loving!"),
                reward: Collectible(id: "c-love", name: "Love", art: .heart, kind: .badge),
                scripture: "John 13:34"
            ),
            Activity(
                id: "qual-joy",
                title: "Joy",
                subtitle: "Color it — or tap the magic wand!",
                introLine: "Joy makes us want to sing! Color the happy picture any way you like.",
                completionLine: "What a joyful picture!",
                icon: .sun,
                spec: .coloring(page: "coloring_joy", seeds: [
                    ColorSeed(x: 0.513, y: 0.227, target: .red),    // left balloon
                    ColorSeed(x: 0.603, y: 0.148, target: .orange), // top balloon
                    ColorSeed(x: 0.687, y: 0.227, target: .purple), // right balloon
                    ColorSeed(x: 0.17, y: 0.20, target: .yellow),   // sun
                    ColorSeed(x: 0.37, y: 0.375, target: .brown),   // hair
                    ColorSeed(x: 0.387, y: 0.614, target: .green),  // shirt
                    ColorSeed(x: 0.397, y: 0.80, target: .blue),    // pants
                    ColorSeed(x: 0.29, y: 0.785, target: .brown),   // shoe
                    ColorSeed(x: 0.46, y: 0.885, target: .brown),   // shoe
                    ColorSeed(x: 0.83, y: 0.35, target: .green),    // tree canopy
                    ColorSeed(x: 0.83, y: 0.60, target: .brown),    // trunk
                    ColorSeed(x: 0.667, y: 0.655, target: .green),  // bushes
                    ColorSeed(x: 0.923, y: 0.655, target: .green),
                    ColorSeed(x: 0.15, y: 0.93, target: .green),    // meadow
                    ColorSeed(x: 0.95, y: 0.06, target: .blue)      // sky
                ]),
                reward: Collectible(id: "c-joy", name: "Joy", art: .sun, kind: .badge),
                scripture: "Psalm 100:2"
            ),
            Activity(
                id: "qual-peace",
                title: "Peace",
                subtitle: "Put peacemaking in order.",
                introLine: "Two friends both want the same fruit. How do peacemakers fix it?",
                completionLine: "Sharing made peace — and everyone is happy!",
                icon: .dove,
                spec: .sequence(steps: [
                    SequenceStep(art: .villagerB, caption: "Both friends want the fruit"),
                    SequenceStep(art: .fruit, caption: "They share it"),
                    SequenceStep(art: .heart, caption: "Both friends are happy"),
                    SequenceStep(art: .dove, caption: "That is peace!")
                ]),
                reward: Collectible(id: "c-peace", name: "Peace", art: .dove, kind: .badge),
                scripture: "Matthew 5:9"
            ),
            Activity(
                id: "qual-patience",
                title: "Patience",
                subtitle: "Plant, water... and wait!",
                introLine: "Patience means waiting nicely. Plant the seed, water it, and wait for it to grow!",
                completionLine: "You waited so patiently — and look how it grew!",
                icon: .sprout,
                spec: .actionSequence(start: .soil, steps: [
                    ActionStep(tool: .seed, prompt: "Plant the seed... and wait!", result: .sprout),
                    ActionStep(tool: .wateringCan, prompt: "Water it... and wait!", result: .sapling),
                    ActionStep(tool: .sun, prompt: "Wait for the sunshine!", result: .tree)
                ]),
                reward: Collectible(id: "c-patience", name: "Patience", art: .tree, kind: .badge),
                scripture: "James 5:7"
            ),
            Activity(
                id: "qual-kindness",
                title: "Kindness",
                subtitle: "Help clean up the spill.",
                introLine: "Uh oh — your friend spilled something! A kind helper cleans up. Take the cloth!",
                completionLine: "Your kindness made your friend smile!",
                icon: .cloth,
                spec: .cleanUp(surface: .people, tasks: [
                    CleanTask(tool: .cloth, messCount: 3, prompt: "Wipe up the spill!")
                ]),
                reward: Collectible(id: "c-kindness", name: "Kindness", art: .cloth, kind: .badge),
                scripture: "Ephesians 4:32"
            ),
            Activity(
                id: "qual-goodness",
                title: "Goodness",
                subtitle: "Fill the basket to share.",
                introLine: "Goodness means doing good things for others! Pick good fruit to share.",
                completionLine: "A whole basket of goodness to give away!",
                icon: .fruit,
                spec: .gather(item: .fruit, count: 4, container: .basket,
                              scenery: .tree, decoyGuard: nil, decoyLine: nil),
                reward: Collectible(id: "c-goodness", name: "Goodness", art: .fruit, kind: .badge),
                scripture: "Galatians 6:10"
            ),
            Activity(
                id: "qual-faith",
                title: "Faith",
                subtitle: "Match the friends of faith!",
                introLine: "Noah, David, Daniel, and Jonah all trusted Jehovah! Match the friends of faith.",
                completionLine: "They all had faith in Jehovah — and you know them all!",
                icon: .star,
                spec: .matchPairs(pool: [.noah, .david, .daniel, .jonah]),
                reward: Collectible(id: "c-faith", name: "Faith", art: .book, kind: .badge),
                scripture: "Hebrews 11:6"
            ),
            Activity(
                id: "qual-mildness",
                title: "Mildness",
                subtitle: "Find each gentle friend.",
                introLine: "Mildness means being gentle, like Jesus! Find each gentle friend.",
                completionLine: "Gentle and mild, just like Jesus!",
                icon: .sheep,
                spec: .findIt(items: [.dove, .sheep, .child, .heart]),
                reward: Collectible(id: "c-mildness", name: "Mildness", art: .sheep, kind: .badge),
                scripture: "Matthew 11:29"
            ),
            Activity(
                id: "qual-selfcontrol",
                title: "Self-Control",
                subtitle: "Take just enough — then stop!",
                introLine: "Self-control means knowing when to stop. Take just enough fruit — and not one more!",
                completionLine: "You stopped at just the right time!",
                icon: .basket,
                spec: .giveNumber(item: .fruit, container: .basket,
                                  distractors: [.star, .heart],
                                  littleRange: 2...3, bigRange: 3...5),
                reward: Collectible(id: "c-self-control", name: "Self-Control", art: .basket, kind: .badge),
                scripture: "Galatians 5:22, 23"
            )
        ],
        bonusReward: Collectible(id: "c-your-light", name: "Your Light", art: .sun, kind: .character)
    )

    // MARK: - Ministry (modern day)

    static let ministry = BibleWorld(
        id: "ministry",
        title: "Ministry",
        tagline: "Share the good news!",
        icon: .book,
        accent: Color(red: 0.42, green: 0.56, blue: 0.80),
        welcomeLine: "We love telling people about Jehovah! What would you like to do in the ministry?",
        activities: [
            Activity(
                id: "ministry-walk",
                title: "Out in the Ministry",
                subtitle: "Walk to the friendly door!",
                introLine: "Let's go in the ministry together! Walk, one step at a time, to the friendly house.",
                completionLine: "How beautiful are the feet that bring good news!",
                icon: .home,
                spec: .pathway(walker: .child, goal: .home, blocker: .tree, prize: .heart),
                reward: Collectible(id: "c-friendly-door", name: "Friendly Door", art: .home, kind: .badge),
                scripture: "Isaiah 52:7"
            ),
            Activity(
                id: "ministry-school",
                title: "Tell Your Schoolmates",
                subtitle: "Share the good news at school.",
                introLine: "You can tell your friends at school about Jehovah! Share the message with each schoolmate.",
                completionLine: "You let your light shine at school!",
                icon: .classmateA,
                spec: .deliver(item: .magazine, source: .child,
                               targets: [.classmateA, .classmateB, .classmateA],
                               deliverLine: "You shared the good news!"),
                reward: Collectible(id: "c-schoolmate", name: "Schoolmate", art: .classmateA, kind: .character),
                scripture: "Matthew 5:16"
            ),
            Activity(
                id: "ministry-present",
                title: "Practice Your Presentation",
                subtitle: "What do we do first?",
                introLine: "Let's practice for the ministry, just like at family worship! What comes first?",
                completionLine: "You are ready to share the good news!",
                icon: .book,
                spec: .sequence(steps: [
                    SequenceStep(art: .child, caption: "Say hello with a smile"),
                    SequenceStep(art: .book, caption: "Read a scripture"),
                    SequenceStep(art: .magazine, caption: "Share the good news"),
                    SequenceStep(art: .hall, caption: "Invite them to the meeting")
                ]),
                reward: Collectible(id: "c-ready-heart", name: "Ready Heart", art: .heart, kind: .badge),
                scripture: "1 Peter 3:15"
            ),
            Activity(
                id: "ministry-match",
                title: "Match the Friends",
                subtitle: "Find the matching pairs!",
                introLine: "All our friends love the good news! Can you find the matching pairs?",
                completionLine: "You matched all the friends!",
                icon: .friendA,
                spec: .matchPairs(pool: [.friendA, .friendB, .friendC, .speaker, .child, .heart]),
                reward: Collectible(id: "c-speaker", name: "Speaker", art: .speaker, kind: .character),
                scripture: "Proverbs 17:17"
            ),
            Activity(
                id: "ministry-bag",
                title: "Ready for the Ministry",
                subtitle: "Pack everything you need!",
                introLine: "Time to get ready for the ministry! Pack your bag.",
                completionLine: "Your bag is packed — let's go!",
                icon: .bag,
                spec: .actionSequence(start: .bag, steps: [
                    ActionStep(tool: .book, prompt: "Pack your Bible!", result: .bagWithBook),
                    ActionStep(tool: .magazine, prompt: "Pack something to share!", result: .bagPacked, reps: 2)
                ]),
                reward: Collectible(id: "c-ministry-bag", name: "Ministry Bag", art: .bagPacked, kind: .badge),
                scripture: "Matthew 28:19, 20"
            ),
            Activity(
                id: "ministry-bring",
                title: "What Do We Bring?",
                subtitle: "Find the one that matches!",
                introLine: "In the ministry we bring love, God's word, good news, and peace! Can you find each one?",
                completionLine: "You bring the very best things!",
                icon: .heart,
                spec: .findIt(items: [.heart, .book, .magazine, .dove]),
                reward: Collectible(id: "c-good-news", name: "Good News", art: .magazine, kind: .badge),
                scripture: "Romans 10:15"
            ),
            Activity(
                id: "ministry-count",
                title: "Count the Schoolmates",
                subtitle: "Tap each schoolmate to count!",
                introLine: "So many friends to share with! How many schoolmates can you count?",
                completionLine: "The good news is for everyone!",
                icon: .classmateB,
                spec: .count(items: [.classmateA], center: nil, labels: nil,
                             littleRange: 3...8, bigRange: 6...12),
                reward: Collectible(id: "c-bright-example", name: "Bright Example", art: .star, kind: .badge),
                scripture: "Matthew 24:14"
            ),
            Activity(
                id: "ministry-give",
                title: "Books to Share",
                subtitle: "Pack just enough books.",
                introLine: "We share Bible truths with others! Pack just enough books — and nothing else.",
                completionLine: "There is more happiness in giving!",
                icon: .book,
                spec: .giveNumber(item: .book, container: .bag,
                                  distractors: [.fruit, .cloth],
                                  littleRange: 2...3, bigRange: 3...5),
                reward: Collectible(id: "c-share-books", name: "Books to Share", art: .book, kind: .badge),
                scripture: "Acts 20:35"
            )
        ],
        bonusReward: Collectible(id: "c-all-the-earth", name: "To All the Earth", art: .earth, kind: .character)
    )

    // MARK: - Christian Activities (modern day)

    static let activities = BibleWorld(
        id: "activities",
        title: "Christian Activities",
        tagline: "Our happy way of life!",
        icon: .home,
        accent: Color(red: 0.85, green: 0.48, blue: 0.55),
        welcomeLine: "Family worship, friends, and helping at home — our life is full of happy things!",
        activities: [
            Activity(
                id: "act-worship",
                title: "Family Worship Night",
                subtitle: "Put the evening in order.",
                introLine: "It's family worship night! What do we do together?",
                completionLine: "What a happy family worship night!",
                icon: .book,
                spec: .sequence(steps: [
                    SequenceStep(art: .book, caption: "Read the Bible together"),
                    SequenceStep(art: .heart, caption: "Talk about Jehovah"),
                    SequenceStep(art: .songbook, caption: "Sing a song"),
                    SequenceStep(art: .fruit, caption: "Enjoy a treat!")
                ]),
                reward: Collectible(id: "c-family-love", name: "Family Love", art: .heart, kind: .badge),
                scripture: "Deuteronomy 6:6, 7"
            ),
            Activity(
                id: "act-welcome",
                title: "Welcome Guests",
                subtitle: "Share the meal with everyone.",
                introLine: "Friends are visiting! Hospitality means sharing. Give everyone some bread.",
                completionLine: "Everyone feels so welcome!",
                icon: .bread,
                spec: .deliver(item: .bread, source: .child,
                               targets: [.friendA, .friendB, .friendC],
                               deliverLine: "Welcome to our home!"),
                reward: Collectible(id: "c-hospitality", name: "Hospitality", art: .bread, kind: .badge),
                scripture: "Romans 12:13"
            ),
            Activity(
                id: "act-table",
                title: "Dinner for Guests",
                subtitle: "Set out just enough.",
                introLine: "Our guests are hungry! Put just enough rolls in the basket.",
                completionLine: "The table is ready — be our guest!",
                icon: .basket,
                spec: .giveNumber(item: .bread, container: .basket,
                                  distractors: [.songbook, .cloth],
                                  littleRange: 3...5, bigRange: 4...8),
                reward: Collectible(id: "c-sharing-table", name: "Sharing Table", art: .fruit, kind: .badge),
                scripture: "1 Peter 4:9"
            ),
            Activity(
                id: "act-tidy",
                title: "Ready for Guests",
                subtitle: "Tidy the house together!",
                introLine: "Friends are coming over! Let's make the house clean and cozy.",
                completionLine: "The house is ready — welcome, friends!",
                icon: .broom,
                spec: .cleanUp(surface: .home, tasks: [
                    CleanTask(tool: .broom, messCount: 3, prompt: "Sweep the floor!"),
                    CleanTask(tool: .cloth, messCount: 3, prompt: "Wipe the table!")
                ]),
                reward: Collectible(id: "c-happy-helper", name: "Happy Helper", art: .broom, kind: .badge),
                scripture: "Colossians 3:23"
            ),
            Activity(
                id: "act-match",
                title: "Match the Happy Things",
                subtitle: "Find the matching pairs!",
                introLine: "Our home is full of happy things! Can you find the pairs?",
                completionLine: "You matched them all!",
                icon: .sun,
                spec: .matchPairs(pool: [.book, .songbook, .bread, .heart, .fruit, .star]),
                reward: Collectible(id: "c-sunny-day", name: "Sunny Day", art: .sun, kind: .badge),
                scripture: "Proverbs 18:24"
            ),
            Activity(
                id: "act-friends",
                title: "Friends Come Over",
                subtitle: "Who's at the door?",
                introLine: "Knock knock! Our friends are here! Can you find each one?",
                completionLine: "A true friend shows love at all times!",
                icon: .friendC,
                spec: .findIt(items: [.friendA, .friendB, .friendC, .speaker]),
                reward: Collectible(id: "c-grandma", name: "Grandma", art: .friendC, kind: .character),
                scripture: "Proverbs 17:17"
            ),
            Activity(
                id: "act-visit",
                title: "Visit Grandma",
                subtitle: "Walk to grandma's house!",
                introLine: "Let's visit Grandma and show her love and respect! Walk to her, one step at a time.",
                completionLine: "You showed Grandma love and respect!",
                icon: .friendC,
                spec: .pathway(walker: .child, goal: .friendC, blocker: .tree, prize: .heart),
                reward: Collectible(id: "c-sister", name: "Sister", art: .friendA, kind: .character),
                scripture: "Leviticus 19:32"
            ),
            Activity(
                id: "act-sort",
                title: "Share It or Put It Away",
                subtitle: "Get ready for company!",
                introLine: "Guests are coming! Some things we set out to share, and some things we put away. Can you sort them?",
                completionLine: "Everything is in its place!",
                icon: .basket,
                spec: .sortClassify(
                    categories: [
                        SortCategory(id: "share", title: "Set Out", color: Theme.leaf),
                        SortCategory(id: "away", title: "Put Away", color: Theme.wood)
                    ],
                    items: [
                        SortItem(art: .bread, categoryID: "share"),
                        SortItem(art: .fruit, categoryID: "share"),
                        SortItem(art: .songbook, categoryID: "share"),
                        SortItem(art: .broom, categoryID: "away"),
                        SortItem(art: .cloth, categoryID: "away"),
                        SortItem(art: .hammer, categoryID: "away")
                    ]
                ),
                reward: Collectible(id: "c-set-to-serve", name: "Set to Serve", art: .basket, kind: .badge),
                scripture: "Hebrews 13:16"
            )
        ],
        bonusReward: Collectible(id: "c-happy-home", name: "Happy Home", art: .home, kind: .character)
    )
}
