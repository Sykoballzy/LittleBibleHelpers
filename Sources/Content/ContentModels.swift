import SwiftUI

/// Every piece of artwork in the app is referenced by key, so illustrations
/// can be swapped from programmatic vectors to commissioned assets without
/// touching content or game code.
enum ArtKey: String, CaseIterable, Hashable {
    case elephant, giraffe, lion, sheep, dove, fish
    case ark, noah, rainbow, stormCloud, sun, heart, hall, star
    case moon, tree, earth
    case saw, hammer, brush, arkPlanks, arkFrame, arkHull
    case villagerA, villagerB, villagerC, scroll, adam, people
    case soil, seed, sprout, sapling, wateringCan, fruit, basket, serpent
    case david, sling, harp, staff, bucket, penFrame, pen, penFull
    case daniel, angel, crown, window
    case jonah, boat, bigFish
    case jesus, bread
    case bag, bagWithBook, bagPacked, book, songbook, chair
    case child, cloth, stone

    var displayName: String {
        switch self {
        case .elephant: return "elephant"
        case .giraffe: return "giraffe"
        case .lion: return "lion"
        case .sheep: return "sheep"
        case .dove: return "dove"
        case .fish: return "fish"
        case .ark: return "ark"
        case .noah: return "Noah"
        case .rainbow: return "rainbow"
        case .stormCloud: return "storm cloud"
        case .sun: return "sun"
        case .heart: return "heart"
        case .hall: return "meeting place"
        case .star: return "star"
        case .moon: return "moon"
        case .tree: return "tree"
        case .earth: return "world"
        case .saw: return "saw"
        case .hammer: return "hammer"
        case .brush: return "paintbrush"
        case .arkPlanks: return "wood"
        case .arkFrame: return "ark frame"
        case .arkHull: return "ark"
        case .villagerA: return "neighbor"
        case .villagerB: return "friend"
        case .villagerC: return "neighbor"
        case .scroll: return "message"
        case .adam: return "Adam"
        case .people: return "Adam and Eve"
        case .soil: return "soil"
        case .seed: return "seed"
        case .sprout: return "sprout"
        case .sapling: return "little tree"
        case .wateringCan: return "watering can"
        case .fruit: return "fruit"
        case .basket: return "basket"
        case .serpent: return "serpent"
        case .david: return "David"
        case .sling: return "sling"
        case .harp: return "harp"
        case .staff: return "staff"
        case .bucket: return "water bucket"
        case .penFrame: return "fence"
        case .pen: return "sheep pen"
        case .penFull: return "sheep pen"
        case .daniel: return "Daniel"
        case .angel: return "angel"
        case .crown: return "crown"
        case .window: return "window"
        case .jonah: return "Jonah"
        case .boat: return "boat"
        case .bigFish: return "big fish"
        case .jesus: return "Jesus"
        case .bread: return "bread"
        case .bag: return "meeting bag"
        case .bagWithBook: return "meeting bag"
        case .bagPacked: return "meeting bag"
        case .book: return "Bible"
        case .songbook: return "songbook"
        case .chair: return "chair"
        case .child: return "child"
        case .cloth: return "cleaning cloth"
        case .stone: return "smooth stone"
        }
    }
}

// MARK: - Tap-to-Color support

/// The child-facing palette. Each colorable picture uses only the colors that
/// belong in it, so the finished picture always looks right.
enum PaletteColor: String, CaseIterable, Hashable {
    case red, orange, yellow, green, blue, purple, brown, gray

    var color: Color {
        switch self {
        case .red: return Color(red: 0.87, green: 0.34, blue: 0.30)
        case .orange: return Color(red: 0.93, green: 0.60, blue: 0.20)
        case .yellow: return Theme.sunny
        case .green: return Theme.leaf
        case .blue: return Theme.sky
        case .purple: return Theme.berry
        case .brown: return Theme.wood
        case .gray: return Color(red: 0.62, green: 0.66, blue: 0.72)
        }
    }

    var spokenName: String { rawValue.capitalized }
}

/// A single fillable region of a colorable picture, positioned in the
/// 200x140 picture design space.
enum RegionShape: Hashable {
    case circle(diameter: CGFloat)
    case ellipse(width: CGFloat, height: CGFloat)
    /// A top-half rainbow band (ring segment): outer diameter + band thickness.
    case arcBand(outer: CGFloat, thickness: CGFloat)
}

struct ColorRegion: Hashable {
    let shape: RegionShape
    let x: CGFloat
    let y: CGFloat
    let target: PaletteColor
}

enum CollectibleKind: String, Hashable {
    case animal, character, badge
}

struct Collectible: Identifiable, Hashable {
    let id: String
    let name: String
    let art: ArtKey
    let kind: CollectibleKind
}

struct SequenceStep: Hashable {
    let art: ArtKey
    let caption: String
}

/// One step of the Action Sequence ("process") template: drag `tool` onto the
/// central object, which then becomes `result`.
struct ActionStep: Hashable {
    let tool: ArtKey
    let prompt: String
    let result: ArtKey
}

/// A bin in the Sort & Classify game (e.g. Land / Sea / Sky).
struct SortCategory: Identifiable, Hashable {
    let id: String
    let title: String
    let color: Color
}

/// An item to be sorted, tagged with the category it belongs to.
struct SortItem: Hashable {
    let art: ArtKey
    let categoryID: String
}

/// The reusable game templates. New content packs reuse these cases with
/// different parameters; new templates get added here.
enum GameSpec: Hashable {
    case matchPairs(pool: [ArtKey])
    case boardTheArk(animals: [ArtKey])
    case count(items: [ArtKey], littleRange: ClosedRange<Int>, bigRange: ClosedRange<Int>)
    case sequence(steps: [SequenceStep])
    case sortClassify(categories: [SortCategory], items: [SortItem])
    case actionSequence(start: ArtKey, steps: [ActionStep])
    case findIt(items: [ArtKey])
    case shadowMatch(items: [ArtKey])
    /// Drag copies of `item` from `source` to every target (Noah preaching;
    /// later: pass the bread, hand out songbooks).
    case deliver(item: ArtKey, source: ArtKey, targets: [ArtKey], deliverLine: String)
    /// Collect `count` items into `container`. Optional `scenery` (e.g. trees)
    /// frames the scene; an optional `decoyGuard` marks items that gently
    /// refuse to be taken (forbidden fruit). Plain gathers omit both.
    case gather(item: ArtKey, count: Int, container: ArtKey,
                scenery: ArtKey?, decoyGuard: ArtKey?, decoyLine: String?)
    /// "Give N": a big target number; the child counts out exactly that many
    /// items into the container from a tray with extras (Daniel prayed 3
    /// times; 2 little fish).
    case giveNumber(item: ArtKey, container: ArtKey,
                    littleRange: ClosedRange<Int>, bigRange: ClosedRange<Int>)
    /// Tap-to-Color: pick a color chip, tap the matching region. The palette
    /// holds only the colors that belong in the picture — no mess, no failure.
    case tapColor(regions: [ColorRegion])
    /// Step-by-step grid walk: tap an open neighboring tile to move the walker
    /// past friendly blockers to the goal, collecting prizes. Teaches walking
    /// calmly (never running) — Meet the Speaker, Come to Jesus.
    case pathway(walker: ArtKey, goal: ArtKey, blocker: ArtKey, prize: ArtKey)
    /// Wipe the smudges: drag the cloth onto each spot until everything
    /// sparkles clean (clean the hall; kindness clean-up).
    case cleanUp(tool: ArtKey, surface: ArtKey, messCount: Int)
}

struct Activity: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let introLine: String
    let completionLine: String
    let icon: ArtKey
    let spec: GameSpec
    let reward: Collectible
    /// NWT citation for family worship — a parent reads the account, then the
    /// child plays. Shown as a small pill; non-readers simply don't notice it.
    var scripture: String? = nil
}

struct BibleWorld: Identifiable, Hashable {
    let id: String
    let title: String
    let tagline: String
    let icon: ArtKey
    let accent: Color
    let welcomeLine: String
    let activities: [Activity]
    /// Unlocked when every activity in the world is completed.
    let bonusReward: Collectible?

    var isAvailable: Bool { !activities.isEmpty }
}
