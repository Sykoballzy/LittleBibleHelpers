import SwiftUI

/// Every piece of artwork in the app is referenced by key, so illustrations
/// can be swapped from programmatic vectors to commissioned assets without
/// touching content or game code.
enum ArtKey: String, CaseIterable, Hashable {
    case elephant, giraffe, lion, sheep, dove, fish
    case ark, noah, rainbow, stormCloud, sun, heart, hall, star
    case moon, tree, earth
    case saw, hammer, brush, arkPlanks, arkFrame, arkHull

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
        }
    }
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
    case count(item: ArtKey, littleRange: ClosedRange<Int>, bigRange: ClosedRange<Int>)
    case sequence(steps: [SequenceStep])
    case sortClassify(categories: [SortCategory], items: [SortItem])
    case actionSequence(start: ArtKey, steps: [ActionStep])
    case findIt(items: [ArtKey])
    case shadowMatch(items: [ArtKey])
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
