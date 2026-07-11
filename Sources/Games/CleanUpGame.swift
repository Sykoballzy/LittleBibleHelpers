import SwiftUI

/// Template 14 (v2): Clean Up — now a set of chores. Each task brings its own
/// tool and its own spots: sweep the floor with the broom, wipe the chairs
/// with the cloth, wash the windows with the spray. Everything ends sparkling.
struct CleanUpGame: View {
    let surface: ArtKey?
    let tasks: [CleanTask]
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    // Smudge bands per task: floor (low), furniture (middle), windows (high).
    private static let bands: [[CGPoint]] = [
        [CGPoint(x: 0.26, y: 0.68), CGPoint(x: 0.50, y: 0.72), CGPoint(x: 0.74, y: 0.66),
         CGPoint(x: 0.38, y: 0.62)],
        [CGPoint(x: 0.28, y: 0.46), CGPoint(x: 0.54, y: 0.50), CGPoint(x: 0.76, y: 0.44),
         CGPoint(x: 0.42, y: 0.40)],
        [CGPoint(x: 0.30, y: 0.20), CGPoint(x: 0.52, y: 0.15), CGPoint(x: 0.74, y: 0.21),
         CGPoint(x: 0.40, y: 0.26)]
    ]
    private static let wipeLines = ["Scrub, scrub!", "All shiny!", "Wiped clean!"]

    @State private var taskIndex = 0
    @State private var cleaned: Set<Int> = []
    @State private var totalCleaned = 0
    @State private var sparkles: Set<Int> = []
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    @State private var toolPop = false
    @State private var finished = false

    private var task: CleanTask? {
        taskIndex < tasks.count ? tasks[taskIndex] : nil
    }

    private var totalMess: Int {
        tasks.reduce(0) { $0 + $1.messCount }
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let smudgeSize = min(w, h) * 0.14
            let toolSize = min(w, h) * 0.20
            let toolHome = CGPoint(x: w * 0.50, y: h * 0.86)

            ZStack {
                // The place being cared for (omitted when the world
                // background IS the place, e.g. inside the Kingdom Hall).
                if let surface {
                    ArtView(key: surface)
                        .frame(width: min(w, h) * 0.50, height: min(w, h) * 0.50)
                        .opacity(0.9)
                        .position(x: w * 0.5, y: h * 0.40)
                }

                // Current chore prompt.
                if let task {
                    HStack(spacing: 10) {
                        ArtView(key: task.tool).frame(width: 38, height: 38)
                        Text(task.prompt)
                            .font(Theme.body(20))
                            .foregroundColor(Theme.textDark)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.white.opacity(0.85)))
                    .position(x: w / 2, y: h * 0.05)
                }

                // The current task's dirty things: real objects (chairs,
                // windows) when the task has a target, plain smudges when not.
                // Cleaned objects stay on screen, freshly clean.
                if let task {
                    let spots = Array(Self.bands[taskIndex % Self.bands.count].prefix(task.messCount))
                    ForEach(0..<spots.count, id: \.self) { i in
                        let spot = CGPoint(x: w * spots[i].x, y: h * spots[i].y)
                        ZStack {
                            if let target = task.target {
                                ArtView(key: target)
                                    .frame(width: smudgeSize * 1.4, height: smudgeSize * 1.4)
                                    .saturation(cleaned.contains(i) ? 1.0 : 0.55)
                            }
                            if !cleaned.contains(i) {
                                SmudgeView()
                                    .frame(width: smudgeSize, height: smudgeSize)
                                    .offset(y: task.target == nil ? 0 : smudgeSize * 0.1)
                            } else if sparkles.contains(i) {
                                StarShape()
                                    .fill(Theme.sunny)
                                    .frame(width: smudgeSize * 0.6, height: smudgeSize * 0.6)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .position(spot)
                        .allowsHitTesting(false)
                    }
                }

                // The current tool (swaps between chores with a little pop).
                if let task {
                    ArtView(key: task.tool)
                        .frame(width: toolSize, height: toolSize)
                        .scaleEffect(isDragging ? 1.1 : (toolPop ? 1.15 : 1.0))
                        .offset(dragOffset)
                        .position(toolHome)
                        .zIndex(5)
                        .id(taskIndex) // fresh tool per chore
                        .transition(.scale.combined(with: .opacity))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    guard !finished else { return }
                                    isDragging = true
                                    dragOffset = value.translation
                                    let point = CGPoint(x: toolHome.x + value.translation.width,
                                                        y: toolHome.y + value.translation.height)
                                    wipeIfTouching(point, size: geo.size, radius: smudgeSize * 0.8)
                                }
                                .onEnded { _ in
                                    isDragging = false
                                    withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
                                        dragOffset = .zero
                                    }
                                }
                        )
                }

                ProgressPips(filled: totalCleaned, total: totalMess)
                    .position(x: w * 0.5, y: h * 0.96)
            }
        }
        .onAppear {
            if let task {
                audio.speak(task.prompt)
            }
        }
    }

    private func wipeIfTouching(_ point: CGPoint, size: CGSize, radius: CGFloat) {
        guard let task else { return }
        let spots = Array(Self.bands[taskIndex % Self.bands.count].prefix(task.messCount))

        for i in 0..<spots.count where !cleaned.contains(i) {
            let spot = CGPoint(x: size.width * spots[i].x, y: size.height * spots[i].y)
            let dx = point.x - spot.x
            let dy = point.y - spot.y
            guard dx * dx + dy * dy <= radius * radius else { continue }

            Haptics.soft()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                _ = cleaned.insert(i)
                _ = sparkles.insert(i)
            }
            totalCleaned += 1
            audio.speak(Self.wipeLines[totalCleaned % Self.wipeLines.count])
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    _ = sparkles.remove(i)
                }
            }

            if cleaned.count == task.messCount {
                advanceTask()
            }
        }
    }

    private func advanceTask() {
        if taskIndex + 1 < tasks.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                    taskIndex += 1
                    cleaned = []
                    sparkles = []
                    toolPop = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation { toolPop = false }
                }
                if let next = self.task {
                    audio.speak("Now — \(next.prompt)")
                }
            }
        } else {
            finished = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                audio.speak("Everything is clean and ready!")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, execute: onComplete)
        }
    }
}

/// A soft, unscary smudge — dusty blobs on a pale backing glow with an
/// outline, so the mess reads clearly against any painted background.
struct SmudgeView: View {
    private let dust = Color(red: 0.42, green: 0.37, blue: 0.31)

    var body: some View {
        ZStack {
            // Pale halo lifts the smudge off busy backgrounds.
            Ellipse()
                .fill(Color.white.opacity(0.75))
                .frame(width: 66, height: 50)
                .blur(radius: 5)
            Ellipse().fill(dust.opacity(0.75)).frame(width: 54, height: 38)
                .rotationEffect(.degrees(-12))
            Ellipse().fill(dust.opacity(0.65)).frame(width: 40, height: 30)
                .rotationEffect(.degrees(18)).offset(x: 14, y: 8)
            Circle().fill(dust.opacity(0.8)).frame(width: 12).offset(x: -16, y: 10)
            Circle().fill(dust.opacity(0.7)).frame(width: 8).offset(x: 8, y: -12)
            Ellipse()
                .strokeBorder(Theme.outline.opacity(0.55), lineWidth: 3)
                .frame(width: 58, height: 42)
                .rotationEffect(.degrees(-12))
        }
        .frame(width: 70, height: 55)
    }
}
