import SwiftUI

/// The Bible journey map: a winding path through time. Creation is stop 1,
/// then Noah, David, Jonah, Daniel, Jesus — and on to meeting life and the
/// qualities we grow today. Scroll along the road, tap a stop to visit it.
struct WorldMapView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var audio: AudioService
    @EnvironmentObject private var progress: ProgressStore

    private let stopSpacing: CGFloat = 215
    private let edgePadding: CGFloat = 130

    var body: some View {
        ZStack {
            MeadowBackground()

            VStack(spacing: 8) {
                HStack {
                    RoundIconButton(systemName: "arrow.backward", color: Theme.sunny) {
                        router.go(.home)
                    }
                    Spacer()
                    BannerTitle(text: "The Bible Journey", color: Theme.berry)
                    Spacer()
                    Color.clear.frame(width: 64, height: 64)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                GeometryReader { geo in
                    let worlds = ContentLibrary.worlds
                    let contentWidth = edgePadding * 2 + stopSpacing * CGFloat(worlds.count - 1)
                    let points = stopPoints(count: worlds.count, height: geo.size.height)

                    ScrollView(.horizontal, showsIndicators: false) {
                        ZStack(alignment: .topLeading) {
                            // The road through time.
                            JourneyPath(points: points)
                                .stroke(Theme.woodDeep.opacity(0.55),
                                        style: StrokeStyle(lineWidth: 7, lineCap: .round, dash: [1, 16]))

                            // The stops.
                            ForEach(Array(worlds.enumerated()), id: \.element.id) { index, world in
                                JourneyStop(world: world,
                                            number: index + 1,
                                            completed: progress.completedCount(in: world)) {
                                    router.go(.storyHub(worldID: world.id))
                                }
                                .position(points[index])
                            }
                        }
                        .frame(width: contentWidth, height: geo.size.height)
                    }
                }
                .padding(.bottom, 8)
            }
        }
        .onAppear {
            audio.speakOnce("Let's travel through the Bible! Where would you like to visit?",
                            key: "world-map")
        }
    }

    /// Stops zigzag gently above and below the midline.
    private func stopPoints(count: Int, height: CGFloat) -> [CGPoint] {
        (0..<count).map { i in
            CGPoint(x: edgePadding + CGFloat(i) * stopSpacing,
                    y: height * 0.5 + (i.isMultiple(of: 2) ? -height * 0.16 : height * 0.16))
        }
    }
}

/// The dotted road connecting the stops with gentle S-curves.
struct JourneyPath: Shape {
    let points: [CGPoint]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let first = points.first else { return path }
        path.move(to: first)
        for i in 1..<points.count {
            let previous = points[i - 1]
            let current = points[i]
            let midX = (previous.x + current.x) / 2
            path.addCurve(to: current,
                          control1: CGPoint(x: midX, y: previous.y),
                          control2: CGPoint(x: midX, y: current.y))
        }
        return path
    }
}

/// One stop on the journey: numbered circle with the world's art, its title,
/// and how much of it has been played.
struct JourneyStop: View {
    let world: BibleWorld
    let number: Int
    let completed: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack(alignment: .topLeading) {
                    ZStack {
                        Circle().fill(Color.black.opacity(0.15)).offset(y: 5)
                        Circle().fill(Color.white)
                        Circle().fill(world.accent.opacity(0.16)).padding(6)
                        ArtView(key: world.icon).padding(20)
                        Circle().strokeBorder(world.accent, lineWidth: 4)
                    }
                    .frame(width: 132, height: 132)

                    // Stop number.
                    ZStack {
                        Circle().fill(world.accent)
                        Circle().strokeBorder(Color.white, lineWidth: 3)
                        Text("\(number)")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .frame(width: 38, height: 38)
                    .offset(x: -6, y: -6)
                }

                Text(world.title)
                    .font(Theme.body(20))
                    .foregroundColor(Theme.textDark)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                    .frame(maxWidth: 170)

                HStack(spacing: 5) {
                    StarShape()
                        .fill(completed > 0 ? Theme.sunny : Theme.creamDeep)
                        .frame(width: 16, height: 16)
                    Text("\(completed) of \(world.activities.count)")
                        .font(Theme.body(14))
                        .foregroundColor(Theme.textDark.opacity(0.6))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Capsule().fill(Color.white.opacity(0.8)))
            }
        }
        .buttonStyle(SquishyButtonStyle())
    }
}
