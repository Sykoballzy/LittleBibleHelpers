import SwiftUI

/// Template 6 (NEW): Action Sequence — the tactile "process" game.
/// A central object sits in the middle; drag the correct next tool onto it and
/// it transforms (planks → frame → hull → painted ark). Wrong tool springs back
/// with a gentle hint. The model behind "wash the bear" style play.
struct ActionSequenceGame: View {
    let start: ArtKey
    let steps: [ActionStep]
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    @State private var stepIndex = 0
    @State private var tools: [ArtKey] = []
    @State private var dragOffsets: [ArtKey: CGSize] = [:]
    @State private var dragging: ArtKey?
    @State private var wrongTool: ArtKey?
    @State private var bump = false
    @State private var saidHint = false
    @State private var pulse = false

    private var centralArt: ArtKey {
        stepIndex == 0 ? start : steps[stepIndex - 1].result
    }

    private var currentPrompt: String {
        stepIndex < steps.count ? steps[stepIndex].prompt : "You did it!"
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let centerPoint = CGPoint(x: w / 2, y: h * 0.38)
            let centralSize = min(w, h) * 0.46
            let centralRect = CGRect(x: centerPoint.x - centralSize / 2,
                                     y: centerPoint.y - centralSize / 2,
                                     width: centralSize, height: centralSize)
            let toolSize = min(w, h) * 0.22

            ZStack {
                // Prompt.
                BannerTitle(text: currentPrompt, color: Theme.wood, textSize: 24)
                    .position(x: w / 2, y: h * 0.08)

                // Central object that transforms.
                ArtView(key: centralArt)
                    .frame(width: centralSize, height: centralSize)
                    .scaleEffect(bump ? 1.12 : 1.0)
                    .id(centralArt)
                    .transition(.scale.combined(with: .opacity))
                    .position(centerPoint)

                // Tools to drag (stay available; pick the right next one).
                ForEach(Array(tools.enumerated()), id: \.element) { index, tool in
                    let home = toolPosition(index: index, count: tools.count, size: geo.size)
                    let isNext = stepIndex < steps.count && tool == steps[stepIndex].tool && dragging == nil
                    ArtView(key: tool)
                        .padding(toolSize * 0.16)
                        .frame(width: toolSize, height: toolSize)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.12), radius: 5, y: 3)
                        )
                        .overlay(
                            Circle()
                                .strokeBorder(Theme.sunny, lineWidth: 4)
                                .opacity(isNext ? (pulse ? 0.95 : 0.15) : 0)
                        )
                        .scaleEffect(isNext && pulse ? 1.09 : 1.0)
                        .rotationEffect(.degrees(wrongTool == tool ? 10 : 0))
                        .offset(dragOffsets[tool] ?? .zero)
                        .position(home)
                        .zIndex(dragging == tool ? 5 : 1)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    guard stepIndex < steps.count else { return }
                                    dragging = tool
                                    dragOffsets[tool] = value.translation
                                }
                                .onEnded { value in
                                    let drop = CGPoint(x: home.x + value.translation.width,
                                                       y: home.y + value.translation.height)
                                    if centralRect.insetBy(dx: -30, dy: -30).contains(drop) {
                                        use(tool)
                                    } else {
                                        springHome(tool)
                                    }
                                    dragging = nil
                                }
                        )
                }

                ProgressPips(filled: stepIndex, total: steps.count)
                    .position(x: w / 2, y: h * 0.95)
            }
        }
        .onAppear {
            if tools.isEmpty {
                // Distinct tools, order shuffled so it isn't always left-to-right.
                var seen = Set<ArtKey>()
                tools = steps.map(\.tool).filter { seen.insert($0).inserted }.shuffled()
            }
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }

    private func toolPosition(index: Int, count: Int, size: CGSize) -> CGPoint {
        let fraction = count > 1 ? CGFloat(index) / CGFloat(count - 1) : 0.5
        let x = size.width * (0.20 + 0.60 * fraction)
        return CGPoint(x: x, y: size.height * 0.78)
    }

    private func use(_ tool: ArtKey) {
        guard stepIndex < steps.count else { return }
        springHome(tool)
        if tool == steps[stepIndex].tool {
            Haptics.success()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) { bump = true }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) { stepIndex += 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation { bump = false }
            }
            if stepIndex < steps.count {
                audio.speak(steps[stepIndex].prompt)
            } else {
                audio.speak("You did it! You built the ark!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.4, execute: onComplete)
            }
        } else {
            Haptics.gentleError()
            withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { wrongTool = tool }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation { wrongTool = nil }
            }
            if !saidHint {
                saidHint = true
                audio.speak("Try another tool!")
            }
        }
    }

    private func springHome(_ tool: ArtKey) {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
            dragOffsets[tool] = .zero
        }
    }
}
