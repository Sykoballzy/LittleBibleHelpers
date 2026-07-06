import SwiftUI

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
struct ArtView: View {
    let key: ArtKey

    var body: some View {
        switch key {
        case .elephant: ElephantArt()
        case .giraffe: GiraffeArt()
        case .lion: LionArt()
        case .sheep: SheepArt()
        case .dove: DoveArt()
        case .fish: FishArt()
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
