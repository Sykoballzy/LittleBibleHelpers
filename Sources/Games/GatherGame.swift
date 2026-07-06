import SwiftUI

/// Template 10 (NEW): Gather. Pick items from the good trees into the basket.
/// Items on the guarded tree gently refuse to be picked — they always spring
/// back with a kind reminder. No failure state: the child simply learns which
/// tree is not for picking. Built for the forbidden-fruit teaching; reusable
/// for any collect-the-right-things activity.
struct GatherGame: View {
    let item: ArtKey
    let count: Int
    let container: ArtKey
    let decoyGuard: ArtKey
    let decoyLine: String
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    @State private var collected: Set<Int> = []
    @State private var dragOffsets: [Int: CGSize] = [:]
    @State private var dragging: Int?
    @State private var guardWiggle = false
    @State private var refusals = 0

    // Unit positions: first `count` are pickable (over the two good trees),
    // the rest are decoys (over the guarded middle tree).
    private let goodPositions: [CGPoint] = [
        CGPoint(x: 0.13, y: 0.26), CGPoint(x: 0.25, y: 0.38),
        CGPoint(x: 0.75, y: 0.38), CGPoint(x: 0.88, y: 0.26)
    ]
    private let decoyPositions: [CGPoint] = [
        CGPoint(x: 0.44, y: 0.22), CGPoint(x: 0.56, y: 0.30)
    ]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let fruitSize = min(w, h) * 0.15
            let basketRect = CGRect(x: w * 0.36, y: h * 0.66, width: w * 0.28, height: h * 0.30)
            let goodCount = min(count, goodPositions.count)

            ZStack {
                // Two good trees.
                ArtView(key: .tree)
                    .frame(width: w * 0.24, height: w * 0.24)
                    .position(x: w * 0.16, y: h * 0.34)
                ArtView(key: .tree)
                    .frame(width: w * 0.24, height: w * 0.24)
                    .position(x: w * 0.84, y: h * 0.34)

                // The one special tree, with the serpent coiled beneath it.
                ArtView(key: .tree)
                    .frame(width: w * 0.22, height: w * 0.22)
                    .saturation(0.75)
                    .position(x: w * 0.50, y: h * 0.28)
                ArtView(key: decoyGuard)
                    .frame(width: w * 0.13, height: w * 0.13)
                    .rotationEffect(.degrees(guardWiggle ? 6 : 0))
                    .position(x: w * 0.50, y: h * 0.47)

                // Basket.
                ArtView(key: container)
                    .frame(width: basketRect.width, height: basketRect.height)
                    .position(x: basketRect.midX, y: basketRect.midY)

                // Collected fruit resting in the basket.
                ForEach(Array(collected).sorted(), id: \.self) { idx in
                    let slot = collected.sorted().firstIndex(of: idx) ?? 0
                    ArtView(key: item)
                        .frame(width: fruitSize * 0.62, height: fruitSize * 0.62)
                        .position(x: basketRect.midX + CGFloat(slot - goodCount / 2) * fruitSize * 0.4,
                                  y: basketRect.minY + basketRect.height * 0.22)
                        .transition(.scale.combined(with: .opacity))
                }

                // Pickable + decoy fruit on the trees.
                ForEach(0..<(goodCount + decoyPositions.count), id: \.self) { idx in
                    let isDecoy = idx >= goodCount
                    if isDecoy || !collected.contains(idx) {
                        let unit = isDecoy ? decoyPositions[idx - goodCount] : goodPositions[idx]
                        let home = CGPoint(x: w * unit.x, y: h * unit.y)
                        ArtView(key: item)
                            .frame(width: fruitSize, height: fruitSize)
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
            // The special tree's fruit always returns — kindly, every time.
            Haptics.gentleError()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.55)) {
                dragOffsets[idx] = .zero
            }
            withAnimation(.spring(response: 0.2, dampingFraction: 0.4)) { guardWiggle = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation { guardWiggle = false }
            }
            if refusals < 2 {
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
            audio.speak("What good fruit!")
            let goodCount = min(count, goodPositions.count)
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
