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
        title: "Noah",
        tagline: "He built, he preached, he trusted Jehovah!",
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
                spec: .count(items: [.elephant, .giraffe, .lion, .sheep, .dove], center: nil,
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
                id: "noah-color",
                title: "Color the Rainbow",
                subtitle: "Tap a color, then tap the picture!",
                introLine: "After the flood, Jehovah put a beautiful rainbow in the sky! Let's color it.",
                completionLine: "What a beautiful rainbow!",
                icon: .rainbow,
                spec: .tapColor(regions: [
                    ColorRegion(shape: .arcBand(outer: 170, thickness: 20), x: 100, y: 118, target: .red),
                    ColorRegion(shape: .arcBand(outer: 130, thickness: 20), x: 100, y: 118, target: .yellow),
                    ColorRegion(shape: .arcBand(outer: 90, thickness: 20), x: 100, y: 118, target: .blue),
                    ColorRegion(shape: .circle(diameter: 30), x: 172, y: 26, target: .yellow),
                    ColorRegion(shape: .ellipse(width: 44, height: 24), x: 28, y: 30, target: .gray),
                    ColorRegion(shape: .ellipse(width: 200, height: 24), x: 100, y: 134, target: .green)
                ]),
                reward: Collectible(id: "c-rainbow-colors", name: "Rainbow Colors", art: .rainbow, kind: .badge),
                scripture: "Genesis 9:13"
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
                spec: .count(items: [.star], center: nil, littleRange: 3...8, bigRange: 6...12),
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
                id: "creation-color",
                title: "Color the Garden",
                subtitle: "Tap a color, then tap the picture!",
                introLine: "Jehovah made a beautiful garden! Let's color it together.",
                completionLine: "The garden looks beautiful!",
                icon: .tree,
                spec: .tapColor(regions: [
                    ColorRegion(shape: .circle(diameter: 56), x: 58, y: 52, target: .green),
                    ColorRegion(shape: .ellipse(width: 20, height: 44), x: 58, y: 96, target: .brown),
                    ColorRegion(shape: .circle(diameter: 16), x: 46, y: 44, target: .orange),
                    ColorRegion(shape: .circle(diameter: 16), x: 72, y: 60, target: .orange),
                    ColorRegion(shape: .circle(diameter: 32), x: 168, y: 28, target: .yellow),
                    ColorRegion(shape: .circle(diameter: 16), x: 148, y: 104, target: .purple),
                    ColorRegion(shape: .ellipse(width: 190, height: 26), x: 100, y: 128, target: .green)
                ]),
                reward: Collectible(id: "c-garden-tree", name: "Garden Tree", art: .tree, kind: .badge),
                scripture: "Genesis 2:9"
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
                spec: .count(items: [.sheep], center: .david, littleRange: 3...8, bigRange: 6...12),
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
                id: "david-stones",
                title: "Five Smooth Stones",
                subtitle: "Put five stones in David's bag.",
                introLine: "David chose five smooth stones from the stream. Jehovah would help him be brave! Can you count out five?",
                completionLine: "Five smooth stones — and Jehovah made David brave!",
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
                completionLine: "The whole flock is safe — not one is missing!",
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
                completionLine: "Morning, noon, and night — Daniel always prayed!",
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
                spec: .count(items: [.lion], center: .daniel, littleRange: 3...8, bigRange: 6...12),
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
                id: "daniel-steps",
                title: "Faithful Steps",
                subtitle: "Walk calmly to the window.",
                introLine: "Some men watched Daniel, hoping he would stop praying. But Daniel walked calmly home to his window — just like always! Walk with him, one step at a time.",
                completionLine: "Daniel was never afraid to pray!",
                icon: .window,
                spec: .pathway(walker: .daniel, goal: .window, blocker: .villagerA, prize: .star),
                reward: Collectible(id: "c-daniel-moon", name: "Night Moon", art: .moon, kind: .badge),
                scripture: "Daniel 6:10, 11"
            ),
            Activity(
                id: "daniel-sort",
                title: "Morning and Night",
                subtitle: "Daniel prayed at both!",
                introLine: "Daniel prayed when the sun came up, at midday, and when the moon rose — every day! What belongs to the morning, and what belongs to the night?",
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
                id: "daniel-color",
                title: "Color the Morning",
                subtitle: "Tap a color, then tap the picture!",
                introLine: "At the first light of dawn, the king ran to the den — and Daniel was safe! Let's color the happy morning.",
                completionLine: "The night is over — what a beautiful morning!",
                icon: .sun,
                spec: .tapColor(regions: [
                    ColorRegion(shape: .arcBand(outer: 150, thickness: 18), x: 100, y: 120, target: .orange),
                    ColorRegion(shape: .circle(diameter: 56), x: 100, y: 100, target: .yellow),
                    ColorRegion(shape: .ellipse(width: 42, height: 22), x: 34, y: 30, target: .gray),
                    ColorRegion(shape: .ellipse(width: 200, height: 26), x: 100, y: 134, target: .brown)
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
                spec: .count(items: [.fish], center: nil, littleRange: 3...8, bigRange: 6...12),
                reward: Collectible(id: "c-sea-fish", name: "Sea Fish", art: .fish, kind: .animal),
                scripture: "Jonah 1:17"
            ),
            Activity(
                id: "jonah-plant",
                title: "The Shade Plant",
                subtitle: "Help the plant grow tall!",
                introLine: "Jehovah made a leafy plant grow up over Jonah to give him shade. Help it grow!",
                completionLine: "What wonderful shade — Jehovah is kind!",
                icon: .sprout,
                spec: .actionSequence(start: .soil, steps: [
                    ActionStep(tool: .seed, prompt: "Jehovah planted it!", result: .sprout),
                    ActionStep(tool: .moon, prompt: "It grew overnight!", result: .tree)
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
        title: "Jesus",
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
                id: "jesus-wine",
                title: "Water into Wine",
                subtitle: "Help with the very first miracle!",
                introLine: "At a wedding feast, the wine ran out. Jesus performed his very first miracle! Fill the big jars with water and watch what happens.",
                completionLine: "The water became the finest wine — Jesus' first miracle!",
                icon: .jar,
                spec: .actionSequence(start: .jar, steps: [
                    ActionStep(tool: .bucket, prompt: "Fill the jars with water!", result: .jarWater),
                    ActionStep(tool: .star, prompt: "Jesus performs the miracle!", result: .jarWine)
                ]),
                reward: Collectible(id: "c-wine-jars", name: "Wine Jars", art: .jarWine, kind: .badge),
                scripture: "John 2:1-11"
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
                id: "jesus-apostles",
                title: "Count the Apostles",
                subtitle: "Count Jesus' special friends!",
                introLine: "Jesus chose twelve apostles to be his special helpers. Count his friends!",
                completionLine: "Jesus' friends helped him preach everywhere!",
                icon: .jesus,
                spec: .count(items: [.villagerA, .villagerB, .villagerC], center: .jesus,
                             littleRange: 4...8, bigRange: 12...12),
                reward: Collectible(id: "c-twelve", name: "The Twelve", art: .star, kind: .badge),
                scripture: "Luke 6:13"
            ),
            Activity(
                id: "jesus-come",
                title: "Come to Jesus",
                subtitle: "Walk all the way to Jesus!",
                introLine: "Some friends said the children should stay away. But Jesus said, Let the young children come to me! Walk to Jesus, one step at a time.",
                completionLine: "Jesus was so happy to see you!",
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
                completionLine: "So many friends who love Jehovah!",
                icon: .villagerA,
                spec: .count(items: [.villagerA, .villagerB, .villagerC], center: nil,
                             littleRange: 3...8, bigRange: 6...12),
                reward: Collectible(id: "c-friend", name: "Friend", art: .villagerB, kind: .character),
                scripture: "Psalm 133:1"
            ),
            Activity(
                id: "meet-clean",
                title: "Clean the Hall",
                subtitle: "Wipe every spot until it shines!",
                introLine: "Our meeting place should be clean and beautiful! Sweep the floor, wipe the chairs, and wash the windows.",
                completionLine: "The hall is shiny clean and ready!",
                icon: .broom,
                spec: .cleanUp(surface: .hall, tasks: [
                    CleanTask(tool: .broom, messCount: 3, prompt: "Sweep the floor!"),
                    CleanTask(tool: .cloth, messCount: 3, prompt: "Wipe the chairs!"),
                    CleanTask(tool: .spray, messCount: 3, prompt: "Wash the windows!")
                ]),
                reward: Collectible(id: "c-hall", name: "Meeting Place", art: .hall, kind: .badge),
                scripture: "1 Corinthians 14:40"
            ),
            Activity(
                id: "meet-speaker",
                title: "Meet the Speaker",
                subtitle: "Walk nicely down the aisle.",
                introLine: "Let's go say hello to the speaker! Walk nicely past our friends — we never run at the meeting.",
                completionLine: "You said such a nice hello — and you walked the whole way!",
                icon: .child,
                spec: .pathway(walker: .child, goal: .villagerC, blocker: .villagerA, prize: .star),
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
        icon: .fruit,
        accent: Theme.grassDeep,
        welcomeLine: "Jehovah's spirit helps us grow nine good fruits — love, joy, peace, and more!",
        activities: [
            Activity(
                id: "qual-love",
                title: "Love",
                subtitle: "Give a heart to each friend.",
                introLine: "The first fruit is love! Jesus said to love one another. Share a heart with everyone.",
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
                subtitle: "Tap a color, then tap the picture!",
                introLine: "Joy makes us want to sing! Color the happy picture.",
                completionLine: "What a joyful picture!",
                icon: .sun,
                spec: .tapColor(regions: [
                    ColorRegion(shape: .circle(diameter: 26), x: 42, y: 46, target: .red),
                    ColorRegion(shape: .circle(diameter: 26), x: 158, y: 44, target: .blue),
                    ColorRegion(shape: .circle(diameter: 22), x: 64, y: 26, target: .purple),
                    ColorRegion(shape: .circle(diameter: 40), x: 104, y: 40, target: .yellow),
                    ColorRegion(shape: .ellipse(width: 190, height: 26), x: 100, y: 128, target: .green)
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
                introLine: "Mildness means being soft and gentle — like a little lamb! Find each gentle friend.",
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
}
