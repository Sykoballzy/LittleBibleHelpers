import SwiftUI

/// Version 1 content. Future packs append worlds (or add activities to
/// existing worlds) here; nothing else in the app needs to change.
enum ContentLibrary {
    static let worlds: [BibleWorld] = [
        creation,
        noahsArk,
        davidSheep,
        danielLions,
        jonahBigFish,
        jesusFriends,
        meetings,
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
                reward: Collectible(id: "c-ark", name: "Ark", art: .ark, kind: .badge),
                scripture: "Genesis 6:14-16"
            ),
            Activity(
                id: "noah-preach",
                title: "Noah Tells Everyone",
                subtitle: "Share the message with each person.",
                introLine: "Noah told everyone that a flood was coming. Can you help him share the message?",
                completionLine: "Noah told everyone! He was a faithful preacher.",
                icon: .scroll,
                spec: .deliver(item: .scroll, source: .noah,
                               targets: [.villagerA, .villagerB, .villagerC],
                               deliverLine: "Noah shared the warning!"),
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
                completionLine: "All the animals are safe on the ark!",
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
                spec: .count(items: [.elephant, .giraffe, .lion, .sheep, .dove],
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
                    SequenceStep(art: .rainbow, caption: "God sends a rainbow")
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
                spec: .count(items: [.star], littleRange: 3...8, bigRange: 6...12),
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
                    SequenceStep(art: .sun, caption: "Jehovah made the light"),
                    SequenceStep(art: .tree, caption: "Jehovah made the plants"),
                    SequenceStep(art: .lion, caption: "Jehovah made the animals"),
                    SequenceStep(art: .people, caption: "Jehovah made people")
                ]),
                reward: Collectible(id: "c-sun", name: "Sun", art: .sun, kind: .badge),
                scripture: "Genesis 1"
            ),
            Activity(
                id: "creation-match",
                title: "Match the Creations",
                subtitle: "Find the matching pairs!",
                introLine: "God made so many wonderful things! Can you find the matching pairs?",
                completionLine: "You matched them all!",
                icon: .moon,
                spec: .matchPairs(pool: [.sun, .moon, .star, .tree, .fruit, .dove]),
                reward: Collectible(id: "c-moon", name: "Moon", art: .moon, kind: .badge)
            ),
            Activity(
                id: "creation-name",
                title: "Name the Animals",
                subtitle: "Help Adam find each animal.",
                introLine: "Adam gave every animal its name! Can you find each one?",
                completionLine: "You found every animal, just like Adam!",
                icon: .adam,
                spec: .findIt(items: [.lion, .elephant, .sheep, .dove]),
                reward: Collectible(id: "c-adam", name: "Adam", art: .adam, kind: .character),
                scripture: "Genesis 2:19"
            ),
            Activity(
                id: "creation-grow",
                title: "Grow the Garden",
                subtitle: "Help the little tree grow!",
                introLine: "Jehovah makes everything grow! Can you help this tree? Use each tool!",
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
        title: "David & the Sheep",
        tagline: "Care for the flock like David!",
        icon: .sheep,
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
                spec: .count(items: [.sheep], littleRange: 3...8, bigRange: 6...12),
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
                introLine: "The sheep need a safe home for the night. Let's build a pen!",
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
                introLine: "One day a lion tried to take a lamb! Let's tell what happened.",
                completionLine: "Jehovah helped David be brave!",
                icon: .david,
                spec: .sequence(steps: [
                    SequenceStep(art: .sheep, caption: "David watched the sheep"),
                    SequenceStep(art: .lion, caption: "A lion took a lamb"),
                    SequenceStep(art: .david, caption: "Jehovah made David brave"),
                    SequenceStep(art: .heart, caption: "The lamb was safe!")
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
                spec: .matchPairs(pool: [.sheep, .harp, .sling, .staff, .lion, .star]),
                reward: Collectible(id: "c-harp", name: "Harp", art: .harp, kind: .badge),
                scripture: "1 Samuel 16:23"
            ),
            Activity(
                id: "david-find",
                title: "Find It for David",
                subtitle: "Find the one that matches!",
                introLine: "David needs his shepherd things! Can you find each one?",
                completionLine: "You found everything David needs!",
                icon: .staff,
                spec: .findIt(items: [.sheep, .harp, .sling, .staff]),
                reward: Collectible(id: "c-staff", name: "Staff", art: .staff, kind: .badge),
                scripture: "1 Samuel 17:40"
            ),
            Activity(
                id: "david-night",
                title: "Day and Night",
                subtitle: "Sort what David sees.",
                introLine: "David watched the sheep all day and looked at the stars at night. What belongs to the day, and what belongs to the night?",
                completionLine: "You sorted the day and the night!",
                icon: .star,
                spec: .sortClassify(
                    categories: [
                        SortCategory(id: "day", title: "Day", color: Theme.sunny),
                        SortCategory(id: "night", title: "Night", color: Theme.berry)
                    ],
                    items: [
                        SortItem(art: .sun, categoryID: "day"),
                        SortItem(art: .sheep, categoryID: "day"),
                        SortItem(art: .dove, categoryID: "day"),
                        SortItem(art: .moon, categoryID: "night"),
                        SortItem(art: .star, categoryID: "night"),
                        SortItem(art: .star, categoryID: "night")
                    ]
                ),
                reward: Collectible(id: "c-shepherd-star", name: "Night Sky", art: .star, kind: .badge),
                scripture: "Psalm 8:3"
            ),
            Activity(
                id: "david-shadow",
                title: "Shepherd Shadows",
                subtitle: "Match each one to its shadow.",
                introLine: "The sun makes shadows in the field! Can you match them?",
                completionLine: "You matched every shadow!",
                icon: .sling,
                spec: .shadowMatch(items: [.sheep, .harp, .staff]),
                reward: Collectible(id: "c-sling", name: "Sling", art: .sling, kind: .badge),
                scripture: "1 Samuel 17:40"
            )
        ],
        bonusReward: Collectible(id: "c-david", name: "David", art: .david, kind: .character)
    )

    // MARK: - Daniel & the Lions

    static let danielLions = BibleWorld(
        id: "daniel",
        title: "Daniel & the Lions",
        tagline: "Be faithful like Daniel!",
        icon: .lion,
        accent: Theme.berry,
        welcomeLine: "Daniel loved Jehovah and prayed every single day — no matter what!",
        activities: [
            Activity(
                id: "daniel-pray",
                title: "Three Times a Day",
                subtitle: "Give the window three stars.",
                introLine: "Daniel prayed to Jehovah three times every day. Put a star in the window for each prayer!",
                completionLine: "Morning, noon, and night — Daniel always prayed!",
                icon: .window,
                spec: .giveNumber(item: .star, container: .window,
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
                title: "The Angel Helps",
                subtitle: "Bring the angel's light to each lion.",
                introLine: "Jehovah sent his angel to shut the lions' mouths. Bring the light to each lion!",
                completionLine: "The lions could not hurt Daniel!",
                icon: .lion,
                spec: .deliver(item: .star, source: .angel,
                               targets: [.lion, .lion, .lion],
                               deliverLine: "The lion's mouth stayed shut!"),
                reward: Collectible(id: "c-angel", name: "Angel", art: .angel, kind: .character),
                scripture: "Daniel 6:22"
            ),
            Activity(
                id: "daniel-count",
                title: "Count the Lions",
                subtitle: "Tap each lion to count!",
                introLine: "The den was full of lions! How many can you count?",
                completionLine: "You counted every lion!",
                icon: .lion,
                spec: .count(items: [.lion], littleRange: 3...8, bigRange: 6...12),
                reward: Collectible(id: "c-den-lion", name: "Den Lion", art: .lion, kind: .animal),
                scripture: "Daniel 6:16"
            ),
            Activity(
                id: "daniel-match",
                title: "Match the Palace",
                subtitle: "Find the matching pairs!",
                introLine: "Daniel lived near the king's palace. Can you find the pairs?",
                completionLine: "You matched them all!",
                icon: .crown,
                spec: .matchPairs(pool: [.lion, .crown, .star, .moon, .angel, .window]),
                reward: Collectible(id: "c-crown", name: "Crown", art: .crown, kind: .badge),
                scripture: "Daniel 6:25-27"
            ),
            Activity(
                id: "daniel-find",
                title: "Find It in the Palace",
                subtitle: "Find the one that matches!",
                introLine: "Look around the palace! Can you find each one?",
                completionLine: "You found them all!",
                icon: .crown,
                spec: .findIt(items: [.lion, .crown, .angel, .window]),
                reward: Collectible(id: "c-daniel-moon", name: "Night Moon", art: .moon, kind: .badge),
                scripture: "Daniel 6"
            ),
            Activity(
                id: "daniel-sort",
                title: "Morning and Night",
                subtitle: "When do we see it?",
                introLine: "Daniel prayed in the morning and at night. What do we see in the morning? What do we see at night?",
                completionLine: "You sorted the morning and the night!",
                icon: .moon,
                spec: .sortClassify(
                    categories: [
                        SortCategory(id: "morning", title: "Morning", color: Theme.sunny),
                        SortCategory(id: "night", title: "Night", color: Theme.berry)
                    ],
                    items: [
                        SortItem(art: .sun, categoryID: "morning"),
                        SortItem(art: .dove, categoryID: "morning"),
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
                id: "daniel-shadow",
                title: "Palace Shadows",
                subtitle: "Match each one to its shadow.",
                introLine: "The palace lamps make shadows! Can you match them?",
                completionLine: "You matched every shadow!",
                icon: .star,
                spec: .shadowMatch(items: [.lion, .crown, .angel]),
                reward: Collectible(id: "c-daniel-star", name: "Bright Star", art: .star, kind: .badge),
                scripture: "Daniel 6"
            )
        ],
        bonusReward: Collectible(id: "c-daniel", name: "Daniel", art: .daniel, kind: .character)
    )

    // MARK: - Jonah & the Big Fish

    static let jonahBigFish = BibleWorld(
        id: "jonah",
        title: "Jonah & the Big Fish",
        tagline: "A big fish and a big lesson!",
        icon: .bigFish,
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
                completionLine: "Three nights — and Jonah kept praying!",
                icon: .moon,
                spec: .giveNumber(item: .moon, container: .bigFish,
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
                spec: .count(items: [.fish], littleRange: 3...8, bigRange: 6...12),
                reward: Collectible(id: "c-sea-fish", name: "Sea Fish", art: .fish, kind: .animal),
                scripture: "Jonah 1:17"
            ),
            Activity(
                id: "jonah-match",
                title: "Match the Sea",
                subtitle: "Find the matching pairs!",
                introLine: "So many things by the sea! Can you find the pairs?",
                completionLine: "You matched them all!",
                icon: .boat,
                spec: .matchPairs(pool: [.fish, .bigFish, .boat, .stormCloud, .sun, .moon]),
                reward: Collectible(id: "c-boat", name: "Boat", art: .boat, kind: .badge),
                scripture: "Jonah 1:3"
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
                icon: .dove,
                spec: .sortClassify(
                    categories: [
                        SortCategory(id: "sea", title: "Sea", color: Theme.sky),
                        SortCategory(id: "sky", title: "Sky", color: Theme.berry)
                    ],
                    items: [
                        SortItem(art: .fish, categoryID: "sea"),
                        SortItem(art: .bigFish, categoryID: "sea"),
                        SortItem(art: .boat, categoryID: "sea"),
                        SortItem(art: .dove, categoryID: "sky"),
                        SortItem(art: .stormCloud, categoryID: "sky"),
                        SortItem(art: .star, categoryID: "sky")
                    ]
                ),
                reward: Collectible(id: "c-sky-dove", name: "Sky Dove", art: .dove, kind: .badge),
                scripture: "Jonah 1:9"
            ),
            Activity(
                id: "jonah-shadow",
                title: "Sea Shadows",
                subtitle: "Match each one to its shadow.",
                introLine: "The sea makes shadowy shapes! Can you match them?",
                completionLine: "You matched every shadow!",
                icon: .fish,
                spec: .shadowMatch(items: [.bigFish, .boat, .fish]),
                reward: Collectible(id: "c-night-sea", name: "Night Sea", art: .moon, kind: .badge),
                scripture: "Jonah 2:10"
            )
        ],
        bonusReward: Collectible(id: "c-jonah", name: "Jonah", art: .jonah, kind: .character)
    )

    // MARK: - Jesus & His Friends

    static let jesusFriends = BibleWorld(
        id: "jesus",
        title: "Jesus & His Friends",
        tagline: "Learn to be kind like Jesus!",
        icon: .jesus,
        accent: Theme.coral,
        welcomeLine: "Jesus loved people and taught them all about Jehovah!",
        activities: [
            Activity(
                id: "jesus-order",
                title: "Peace! Be Still!",
                subtitle: "Put the story in order.",
                introLine: "One night a big storm rocked the boat — but Jesus was not afraid! Let's tell the story.",
                completionLine: "Even the wind and the sea obey Jesus!",
                icon: .boat,
                spec: .sequence(steps: [
                    SequenceStep(art: .boat, caption: "Jesus and his friends sailed"),
                    SequenceStep(art: .stormCloud, caption: "A big storm came"),
                    SequenceStep(art: .jesus, caption: "Jesus said, Peace! Be still!"),
                    SequenceStep(art: .sun, caption: "The sea became calm")
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
                id: "jesus-fish",
                title: "Two Little Fish",
                subtitle: "Put two fish in the basket.",
                introLine: "A boy shared his food — five loaves and two little fish! Put the two fish in the basket.",
                completionLine: "Jesus made that little lunch feed everyone!",
                icon: .fish,
                spec: .giveNumber(item: .fish, container: .basket,
                                  littleRange: 2...2, bigRange: 2...2),
                reward: Collectible(id: "c-two-fish", name: "Two Fish", art: .fish, kind: .badge),
                scripture: "Matthew 14:17"
            ),
            Activity(
                id: "jesus-gather",
                title: "Gather the Leftovers",
                subtitle: "Fill the basket with bread.",
                introLine: "After everyone ate, there was still bread left over — twelve baskets full! Help gather it up.",
                completionLine: "Nothing was wasted!",
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
                id: "jesus-count",
                title: "Loaves and Fish",
                subtitle: "Tap each one to count!",
                introLine: "Five loaves and two little fish! How many can you count today?",
                completionLine: "You counted the whole meal!",
                icon: .bread,
                spec: .count(items: [.bread, .fish], littleRange: 3...7, bigRange: 5...12),
                reward: Collectible(id: "c-five-loaves", name: "Five Loaves", art: .bread, kind: .badge),
                scripture: "Matthew 14:17"
            ),
            Activity(
                id: "jesus-match",
                title: "Match by the Sea",
                subtitle: "Find the matching pairs!",
                introLine: "Jesus taught his friends by the sea. Can you find the pairs?",
                completionLine: "You matched them all!",
                icon: .heart,
                spec: .matchPairs(pool: [.bread, .fish, .boat, .sheep, .heart, .star]),
                reward: Collectible(id: "c-jesus-heart", name: "Loving Heart", art: .heart, kind: .badge),
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
        title: "Meetings & Conventions",
        tagline: "Get ready for the meeting!",
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
                    SequenceStep(art: .hall, caption: "Go to the Kingdom Hall"),
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
                spec: .deliver(item: .songbook, source: .villagerB,
                               targets: [.villagerA, .people, .villagerC],
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
                completionLine: "So many friends who love Jehovah!",
                icon: .villagerA,
                spec: .count(items: [.villagerA, .villagerB, .villagerC],
                             littleRange: 3...8, bigRange: 6...12),
                reward: Collectible(id: "c-friend", name: "Friend", art: .villagerB, kind: .character),
                scripture: "Psalm 133:1"
            ),
            Activity(
                id: "meet-find",
                title: "Find Your Things",
                subtitle: "Find the one that matches!",
                introLine: "Time to get ready! Can you find each thing we need?",
                completionLine: "You found everything!",
                icon: .book,
                spec: .findIt(items: [.bag, .book, .songbook, .chair]),
                reward: Collectible(id: "c-bible", name: "My Bible", art: .book, kind: .badge),
                scripture: "Psalm 119:105"
            ),
            Activity(
                id: "meet-match",
                title: "Match at the Hall",
                subtitle: "Find the matching pairs!",
                introLine: "So many things at the meeting! Can you find the pairs?",
                completionLine: "You matched them all!",
                icon: .songbook,
                spec: .matchPairs(pool: [.book, .songbook, .bag, .hall, .heart, .chair]),
                reward: Collectible(id: "c-hall", name: "Meeting Place", art: .hall, kind: .badge),
                scripture: "Hebrews 10:24, 25"
            )
        ],
        bonusReward: Collectible(id: "c-family", name: "My Family", art: .people, kind: .character)
    )

    // MARK: - Christian Qualities

    static let qualities = BibleWorld(
        id: "qualities",
        title: "Christian Qualities",
        tagline: "Grow good fruit every day!",
        icon: .heart,
        accent: Theme.grassDeep,
        welcomeLine: "Jehovah's spirit helps us grow love, joy, peace, and kindness!",
        activities: [
            Activity(
                id: "qual-gather",
                title: "Fruit of the Spirit",
                subtitle: "Fill the basket with good fruit.",
                introLine: "Jehovah's spirit helps us grow good fruit — love, joy, and peace! Pick the good fruit.",
                completionLine: "Your basket is full of good fruit!",
                icon: .fruit,
                spec: .gather(item: .fruit, count: 4, container: .basket,
                              scenery: .tree, decoyGuard: nil, decoyLine: nil),
                reward: Collectible(id: "c-good-fruit", name: "Good Fruit", art: .fruit, kind: .badge),
                scripture: "Galatians 5:22, 23"
            ),
            Activity(
                id: "qual-share",
                title: "Share with Friends",
                subtitle: "Give some fruit away.",
                introLine: "Sharing makes everyone happy! Give some of your fruit to your friends.",
                completionLine: "There is more happiness in giving!",
                icon: .heart,
                spec: .giveNumber(item: .fruit, container: .people,
                                  littleRange: 2...4, bigRange: 3...6),
                reward: Collectible(id: "c-sharing", name: "Sharing", art: .heart, kind: .badge),
                scripture: "Acts 20:35"
            ),
            Activity(
                id: "qual-love",
                title: "Share the Love",
                subtitle: "Give a heart to each friend.",
                introLine: "Jesus said to love one another! Share a heart with everyone.",
                completionLine: "Love makes every day brighter!",
                icon: .heart,
                spec: .deliver(item: .heart, source: .people,
                               targets: [.villagerA, .villagerB, .villagerC],
                               deliverLine: "That was so kind!"),
                reward: Collectible(id: "c-kind-dove", name: "Kind Dove", art: .dove, kind: .badge),
                scripture: "John 13:34"
            ),
            Activity(
                id: "qual-order",
                title: "How to Be Kind",
                subtitle: "Put kindness in order.",
                introLine: "When a friend feels sad, we can help! What do we do first?",
                completionLine: "Kindness made your friend smile!",
                icon: .heart,
                spec: .sequence(steps: [
                    SequenceStep(art: .villagerB, caption: "Your friend feels sad"),
                    SequenceStep(art: .fruit, caption: "Bring a kind gift"),
                    SequenceStep(art: .heart, caption: "Now they feel loved!"),
                    SequenceStep(art: .sun, caption: "Kindness shines bright!")
                ]),
                reward: Collectible(id: "c-kindness", name: "Kindness", art: .heart, kind: .badge),
                scripture: "Ephesians 4:32"
            ),
            Activity(
                id: "qual-count",
                title: "Count the Hearts",
                subtitle: "Tap each heart to count!",
                introLine: "So much love to share! How many hearts can you count?",
                completionLine: "You counted all the love!",
                icon: .heart,
                spec: .count(items: [.heart], littleRange: 3...8, bigRange: 6...12),
                reward: Collectible(id: "c-joy-sun", name: "Joy", art: .sun, kind: .badge),
                scripture: "Galatians 5:22"
            ),
            Activity(
                id: "qual-find",
                title: "Find the Good Things",
                subtitle: "Find the one that matches!",
                introLine: "Good things are all around! Can you find each one?",
                completionLine: "You found every good thing!",
                icon: .star,
                spec: .findIt(items: [.heart, .dove, .fruit, .star]),
                reward: Collectible(id: "c-patience-tree", name: "Patience", art: .tree, kind: .badge),
                scripture: "Galatians 5:22, 23"
            ),
            Activity(
                id: "qual-match",
                title: "Match the Good Fruit",
                subtitle: "Find the matching pairs!",
                introLine: "Love, joy, peace — can you find the pairs?",
                completionLine: "You matched them all!",
                icon: .fruit,
                spec: .matchPairs(pool: [.heart, .star, .dove, .fruit, .sun, .tree]),
                reward: Collectible(id: "c-quality-star", name: "Goodness", art: .star, kind: .badge),
                scripture: "Galatians 5:22, 23"
            ),
            Activity(
                id: "qual-shadow",
                title: "Gentle Shadows",
                subtitle: "Match each one to its shadow.",
                introLine: "Even shadows can be gentle! Can you match them?",
                completionLine: "You matched every shadow!",
                icon: .moon,
                spec: .shadowMatch(items: [.heart, .star, .tree]),
                reward: Collectible(id: "c-peace-moon", name: "Peace", art: .moon, kind: .badge),
                scripture: "Galatians 5:22, 23"
            )
        ],
        bonusReward: Collectible(id: "c-your-light", name: "Your Light", art: .sun, kind: .character)
    )
}
