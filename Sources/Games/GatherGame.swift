import SwiftUI

/// Template 10: Gather. Collect items into the container. Optional `scenery`
/// (e.g. trees) frames the scene; when a `decoyGuard` is present, the middle
/// scenery holds decoy items that gently refuse to be taken — no failure
/// state, the rule itself is the lesson (forbidden fruit). Without a guard
/// it's a pure joyful gather (leftover bread, good fruit).
struct GatherGame: View {
    let item: ArtKey
    let count: Int
    let container: ArtKey
    let scenery: ArtKey?
    let decoyGuard: ArtKey?
    let decoyLine: String?
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    @State private var collected: Set<Int> = []
    @State private var dragOffsets: [Int: CGSize] = [:]
    @State private var dragging: Int?
    @State private var guardWiggle = false
    @State private var refusals = 0

    // First `count` positions are pickable; the last two are decoys
    // (only used when a decoyGuard is present).
    private let goodPositions: [CGPoint] = [
        CGPoint(x: 0.13, y: 0.26), CGPoint(x: 0.25, y: 0.38),
        CGPoint(x: 0.75, y: 0.38), CGPoint(x: 0.88, y: 0.26)
    ]
    private let decoyPositions: [CGPoint] = [
        CGPoint(x: 0.44, y: 0.22), CGPoint(x: 0.56, y: 0.30)
    ]

    private var goodCount: Int { min(count, goodPositions.count) }
    private var hasDecoys: Bool { decoyGuard != nil }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let itemSize = min(w, h) * 0.15
            let basketRect = CGRect(x: w * 0.36, y: h * 0.66, width: w * 0.28, height: h * 0.30)

            ZStack {
                // Scenery framing the pickable items.
                if let scenery {
                    ArtView(key: scenery)
                        .frame(width: w * 0.24, height: w * 0.24)
                        .position(x: w * 0.16, y: h * 0.34)
                    ArtView(key: scenery)
                        .frame(width: w * 0.24, height: w * 0.24)
                        .position(x: w * 0.84, y: h * 0.34)
                    if hasDecoys {
                        ArtView(key: scenery)
                            .frame(width: w * 0.22, height: w * 0.22)
                            .saturation(0.75)
                            .position(x: w * 0.50, y: h * 0.28)
                    }
                }

                if let decoyGuard {
                    ArtView(key: decoyGuard)
                        .frame(width: w * 0.13, height: w * 0.13)
                        .rotationEffect(.degrees(guardWiggle ? 6 : 0))
                        .position(x: w * 0.50, y: h * 0.47)
                }

                // Container.
                ArtView(key: container)
                    .frame(width: basketRect.width, height: basketRect.height)
                    .position(x: basketRect.midX, y: basketRect.midY)

                // Collected items resting in the container.
                ForEach(Array(collected).sorted(), id: \.self) { idx in
                    let slot = Array(collected).sorted().firstIndex(of: idx) ?? 0
                    ArtView(key: item)
                        .frame(width: itemSize * 0.62, height: itemSize * 0.62)
                        .position(x: basketRect.midX + CGFloat(slot - goodCount / 2) * itemSize * 0.4,
                                  y: basketRect.minY + basketRect.height * 0.22)
                        .transition(.scale.combined(with: .opacity))
                }

                // Pickable + decoy items.
                ForEach(0..<(goodCount + (hasDecoys ? decoyPositions.count : 0)), id: \.self) { idx in
                    let isDecoy = idx >= goodCount
                    if isDecoy || !collected.contains(idx) {
                        let unit = isDecoy ? decoyPositions[idx - goodCount] : goodPositions[idx]
                        let home = CGPoint(x: w * unit.x, y: h * unit.y)
                        ArtView(key: item)
                            .frame(width: itemSize, height: itemSize)
                            .saturation(isDecoy ? 0.7 : 1)
                            .offset(dragOffsets[idx] ?? .zero)
                            .position(home)
                            .zIndex(dragging == idx ? 5 : 1)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragging = idx
                                        dragOffsets[idx] = value.translation
                                    }
                                    .onEnded { value in
                                        let drop = CGPoint(x: home.x + value.translation.width,
                                                           y: home.y + value.translation.height)
                                        handleDrop(idx, isDecoy: isDecoy, at: drop, basketRect: basketRect)
                                        dragging = nil
                                    }
                            )
                    }
                }
            }
        }
    }

    private func handleDrop(_ idx: Int, isDecoy: Bool, at point: CGPoint, basketRect: CGRect) {
        if isDecoy {
            // Guarded items always return — kindly, every time.
            Haptics.gentleError()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.55)) {
                dragOffsets[idx] = .zero
            }
            withAnimation(.spring(response: 0.2, dampingFraction: 0.4)) { guardWiggle = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation { guardWiggle = false }
            }
            if refusals < 2, let decoyLine {
                refusals += 1
                audio.speak(decoyLine)
            }
            return
        }

        if basketRect.insetBy(dx: -24, dy: -24).contains(point) {
            Haptics.success()
            dragOffsets[idx] = .zero
            withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                _ = collected.insert(idx)
            }
            audio.speak("What good \(item.displayName)!")
            if collected.count == goodCount {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: onComplete)
            }
        } else {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
                dragOffsets[idx] = .zero
            }
        }
    }
}
