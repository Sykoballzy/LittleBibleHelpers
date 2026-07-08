import SwiftUI

/// Template 9 (NEW): Deliver. The source character offers an item; the child
/// drags a copy to each waiting person. Each recipient reacts and gently walks
/// away, and a fresh item pops back at the source. Built for Noah preaching;
/// reusable for any hand-something-to-everyone activity (pass the bread,
/// share songbooks).
struct DeliverGame: View {
    let item: ArtKey
    let source: ArtKey
    let targets: [ArtKey]
    let deliverLine: String
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    @State private var deliveredCount = 0
    @State private var reacting: Int?     // target index mid-reaction
    @State private var departed: Set<Int> = []
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    @State private var bob = false

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let personSize = min(w, h) * 0.30
            let itemSize = min(w, h) * 0.17
            let itemHome = CGPoint(x: w * 0.24, y: h * 0.30)

            ZStack {
                // Noah is mid-build: the ark frame sits behind him.
                ArkFrameArt()
                    .frame(width: w * 0.26, height: w * 0.26)
                    .opacity(0.85)
                    .position(x: w * 0.10, y: h * 0.38)
                    .allowsHitTesting(false)

                // Source character.
                ArtView(key: source)
                    .frame(width: personSize, height: personSize)
                    .position(x: w * 0.15, y: h * 0.68)
                    .allowsHitTesting(false)

                // Waiting townspeople — with a pulsing "bring it here" ring.
                ForEach(Array(targets.enumerated()), id: \.offset) { index, person in
                    let base = targetPosition(index: index, count: targets.count, size: geo.size)
                    let gone = departed.contains(index)
                    let isReacting = reacting == index
                    ZStack {
                        if !gone {
                            Circle()
                                .strokeBorder(Theme.sunny, lineWidth: 4)
                                .frame(width: personSize * 1.05, height: personSize * 1.05)
                                .opacity(bob ? 0.75 : 0.15)
                                .scaleEffect(bob ? 1.04 : 0.96)
                        }
                        ArtView(key: person)
                            .frame(width: personSize, height: personSize)
                            .rotationEffect(.degrees(isReacting ? 7 : 0))
                    }
                    .offset(x: gone ? w * 0.35 : 0,
                            y: gone ? h * 0.06 : (bob && !isReacting ? -4 : 0))
                    .opacity(gone ? 0 : 1)
                    .position(base)
                    .allowsHitTesting(false)
                }

                // Until the first delivery lands, a little arrow glides from
                // the item toward the first person — no reading needed.
                // IMPORTANT: it must stay in the view tree during a drag
                // (fading via opacity), otherwise removing it cancels the
                // drag gesture mid-flight.
                if deliveredCount == 0 {
                    let firstTarget = targetPosition(index: 0, count: targets.count, size: geo.size)
                    let t: CGFloat = bob ? 0.62 : 0.28
                    let hintPoint = CGPoint(x: itemHome.x + (firstTarget.x - itemHome.x) * t,
                                            y: itemHome.y + (firstTarget.y - itemHome.y) * t)
                    Image(systemName: "arrow.forward")
                        .font(.system(size: 34, weight: .heavy))
                        .foregroundColor(Theme.coral)
                        .rotationEffect(.radians(Double(atan2(firstTarget.y - itemHome.y,
                                                              firstTarget.x - itemHome.x))))
                        .opacity(isDragging ? 0 : (bob ? 0.9 : 0.25))
                        .position(hintPoint)
                        .allowsHitTesting(false)
                }

                // The draggable item (one at a time), popping fresh at the source.
                if deliveredCount < targets.count {
                    ArtView(key: item)
                        .padding(itemSize * 0.12)
                        .frame(width: itemSize, height: itemSize)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.12), radius: 5, y: 3)
                        )
                        .contentShape(Circle().inset(by: -24)) // generous grab area
                        .scaleEffect(isDragging ? 1.1 : 1.0)
                        .offset(dragOffset)
                        .position(itemHome)
                        .zIndex(5)
                        .id(deliveredCount) // fresh pop per delivery
                        .transition(.scale.combined(with: .opacity))
                        .gesture(
                            DragGesture(minimumDistance: 1)
                                .onChanged { value in
                                    isDragging = true
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    isDragging = false
                                    let drop = CGPoint(x: itemHome.x + value.translation.width,
                                                       y: itemHome.y + value.translation.height)
                                    handleDrop(at: drop, personSize: personSize, size: geo.size)
                                }
                        )
                }

                ProgressPips(filled: deliveredCount, total: targets.count)
                    .position(x: w / 2, y: h * 0.95)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) { bob = true }
        }
    }

    private func targetPosition(index: Int, count: Int, size: CGSize) -> CGPoint {
        let fraction = count > 1 ? CGFloat(index) / CGFloat(count - 1) : 0.5
        let x = size.width * (0.48 + 0.38 * fraction)
        let y = size.height * (index.isMultiple(of: 2) ? 0.42 : 0.68)
        return CGPoint(x: x, y: y)
    }

    private func handleDrop(at point: CGPoint, personSize: CGFloat, size: CGSize) {
        // Find an un-served target under the drop point.
        for (index, _) in targets.enumerated() where !departed.contains(index) && reacting != index {
            let base = targetPosition(index: index, count: targets.count, size: size)
            let rect = CGRect(x: base.x - personSize / 2, y: base.y - personSize / 2,
                              width: personSize, height: personSize)
                .insetBy(dx: -24, dy: -24)
            if rect.contains(point) {
                deliver(to: index)
                return
            }
        }
        // Missed — glide the item home.
        withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
            dragOffset = .zero
        }
    }

    private func deliver(to index: Int) {
        Haptics.success()
        audio.speak(deliverLine)

        // Recipient reacts, then wanders off; a fresh item pops at the source.
        withAnimation(.spring(response: 0.2, dampingFraction: 0.4)) { reacting = index }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            deliveredCount += 1
            dragOffset = .zero
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            withAnimation(.easeIn(duration: 0.9)) {
                _ = departed.insert(index)
            }
            if reacting == index { reacting = nil }
        }

        if deliveredCount == targets.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8, execute: onComplete)
        }
    }
}
