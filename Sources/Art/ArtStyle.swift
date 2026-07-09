import SwiftUI
import UIKit

/// All artwork is designed in a fixed 120x120 unit space and scaled to fit
/// whatever frame the caller provides. Offsets are measured from center.
struct ArtCanvas<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        GeometryReader { geo in
            let scale = min(geo.size.width, geo.size.height) / 120
            ZStack { content() }
                .frame(width: 120, height: 120)
                .scaleEffect(scale)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }
}

/// Routes an art key to its illustration.
///
/// Art-pass pipeline: if a bundled image named `art_<key>` exists (e.g.
/// `art_lion.png` in Resources/), it automatically REPLACES the programmatic
/// vector below — no code change needed per asset. See ART_SPEC.md.
struct ArtView: View {
    let key: ArtKey

    @EnvironmentObject private var settings: SettingsStore

    private var imageName: String {
        // The player's stand-in is the family's own child: boy or girl,
        // chosen in the Parent Area.
        if key == .child {
            return settings.childGender == .girl ? "art_femalechild" : "art_malechild"
        }
        return "art_\(key.rawValue)"
    }

    var body: some View {
        if let image = UIImage(named: imageName) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                // Generated assets are cropped tight to the artwork; a touch
                // of breathing room keeps them from butting against frames.
                .scaleEffect(0.94)
        } else {
            vectorBody
        }
    }

    @ViewBuilder
    private var vectorBody: some View {
        switch key {
        case .elephant: ElephantArt()
        case .giraffe: GiraffeArt()
        case .lion: LionArt()
        case .sheep: SheepArt()
        case .bird: DoveArt()
        case .dove: DoveArt()
        case .fish: FishArt()
        case .speaker: SpeakerArt()
        case .hallWindow: HallWindowArt()
        // Modern congregation friends (PNGs expected; villager vectors as fallback).
        case .friendA: VillagerArt(robe: Theme.sunny, hair: Theme.woodDeep)
        case .friendB: VillagerArt(robe: Theme.sky, hair: Theme.outline)
        case .friendC: VillagerArt(robe: Theme.berry, hair: Color(red: 0.75, green: 0.75, blue: 0.78))
        case .home: HomeArt()
        case .classmateA: ClassmateArt(shirt: Theme.coral, hair: Theme.outline)
        case .classmateB: ClassmateArt(shirt: Theme.leaf, hair: Color(red: 0.55, green: 0.35, blue: 0.16))
        case .ark: ArkArt()
        case .noah: NoahArt()
        case .rainbow: RainbowArt()
        case .stormCloud: StormCloudArt()
        case .sun: SunArt()
        case .heart: HeartArt()
        case .hall: HallArt()
        case .star: StarArt()
        case .moon: MoonArt()
        case .tree: TreeArt()
        case .earth: EarthArt()
        case .saw: SawArt()
        case .hammer: HammerArt()
        case .brush: BrushArt()
        case .arkPlanks: ArkPlanksArt()
        case .arkFrame: ArkFrameArt()
        case .arkHull: ArkHullArt()
        case .villagerA: VillagerArt(robe: Theme.sky, hair: Theme.outline)
        case .villagerB: VillagerArt(robe: Theme.coral, hair: Theme.woodDeep)
        case .villagerC: VillagerArt(robe: Theme.berry, hair: Color(red: 0.42, green: 0.30, blue: 0.18))
        case .scroll: ScrollArt()
        case .adam: AdamArt()
        case .people: PeopleArt()
        case .soil: SoilArt()
        case .seed: SeedArt()
        case .sprout: SproutArt()
        case .sapling: SaplingArt()
        case .wateringCan: WateringCanArt()
        case .fruit: FruitArt()
        case .basket: BasketArt()
        case .serpent: SerpentArt()
        case .david: DavidArt()
        case .sling: SlingArt()
        case .harp: HarpArt()
        case .staff: StaffArt()
        case .bucket: BucketArt()
        case .penFrame: PenFrameArt()
        case .pen: PenArt()
        case .penFull: PenFullArt()
        case .daniel: DanielArt()
        case .angel: AngelArt()
        case .crown: CrownArt()
        case .window: WindowArt()
        case .jonah: JonahArt()
        case .boat: BoatArt()
        case .bigFish: BigFishArt()
        case .jesus: JesusArt()
        case .bread: BreadArt()
        case .bag: BagArt(contents: 0)
        case .bagWithBook: BagArt(contents: 1)
        case .bagPacked: BagArt(contents: 2)
        case .book: BookArt()
        case .songbook: SongbookArt()
        case .chair: ChairArt()
        case .child: ChildArt()
        case .cloth: ClothArt()
        case .stone: StoneArt()
        case .broom: BroomArt()
        case .spray: SprayArt()
        case .jar: JarArt(fill: .empty)
        case .jarWater: JarArt(fill: .water)
        case .jarWine: JarArt(fill: .wine)
        case .jars0: JarTrioArt(filled: 0, wine: false)
        case .jars1: JarTrioArt(filled: 1, wine: false)
        case .jars2: JarTrioArt(filled: 2, wine: false)
        case .jars3: JarTrioArt(filled: 3, wine: false)
        case .jarsWine: JarTrioArt(filled: 3, wine: true)
        }
    }
}

// MARK: - Shared facial features

struct CuteEyes: View {
    var spacing: CGFloat = 20
    var size: CGFloat = 11

    var body: some View {
        HStack(spacing: spacing) {
            eye
            eye
        }
    }

    private var eye: some View {
        ZStack {
            Circle().fill(Theme.outline)
            Circle()
                .fill(Color.white)
                .frame(width: size * 0.38, height: size * 0.38)
                .offset(x: -size * 0.14, y: -size * 0.14)
        }
        .frame(width: size, height: size)
    }
}

struct Blush: View {
    var spacing: CGFloat = 44

    var body: some View {
        HStack(spacing: spacing) {
            cheek
            cheek
        }
    }

    private var cheek: some View {
        Ellipse()
            .fill(Color(red: 0.98, green: 0.66, blue: 0.62).opacity(0.5))
            .frame(width: 13, height: 8)
    }
}

// MARK: - Shared shapes

struct StarShape: Shape {
    var points = 5

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outer = min(rect.width, rect.height) / 2
        let inner = outer * 0.45
        var path = Path()
        for i in 0..<(points * 2) {
            let radius = i.isMultiple(of: 2) ? outer : inner
            let angle = (Double(i) / Double(points)) * .pi - .pi / 2
            let point = CGPoint(x: center.x + CGFloat(cos(angle)) * radius,
                                y: center.y + CGFloat(sin(angle)) * radius)
            if i == 0 { path.move(to: point) } else { path.addLine(to: point) }
        }
        path.closeSubpath()
        return path
    }
}

struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        p.move(to: CGPoint(x: w / 2, y: h))
        p.addCurve(to: CGPoint(x: 0, y: h / 4),
                   control1: CGPoint(x: w * 0.1, y: h * 0.72),
                   control2: CGPoint(x: 0, y: h / 2))
        p.addArc(center: CGPoint(x: w / 4, y: h / 4), radius: w / 4,
                 startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        p.addArc(center: CGPoint(x: 3 * w / 4, y: h / 4), radius: w / 4,
                 startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        p.addCurve(to: CGPoint(x: w / 2, y: h),
                   control1: CGPoint(x: w, y: h / 2),
                   control2: CGPoint(x: w * 0.9, y: h * 0.72))
        p.closeSubpath()
        return p
    }
}

struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}
