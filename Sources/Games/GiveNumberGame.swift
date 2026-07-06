import SwiftUI

/// Template 11 (NEW): Give the Number. A big friendly numeral asks for exactly
/// N items; the child drags them one at a time from a tray (which holds a few
/// extras) into the container. Teaches counting OUT a quantity — the skill
/// after counting up. No failure state: the game simply completes at N.
struct GiveNumberGame: View {
    let item: ArtKey
    let container: ArtKey
    let range: ClosedRange<Int>
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    @State private var target = 0
    @State private var trayCount = 0
    @State private var givenIndices: [Int] = []   // tray indices, in give order
    @State private var dragOffsets: [Int: CGSize] = [:]
    @State private var dragging: Int?
    @State private var finished = false

    var body: some View {
        GeometryReader { geo in
            if target > 0 {
                let w = geo.size.width
                let h = geo.size.height
                let itemSize = min(w, h) * 0.15
                let containerRect = CGRect(x: w * 0.58, y: h * 0.12, width: w * 0.34, height: h * 0.48)

                ZStack {
                    // The ask: big numeral + dots that fill.
                    VStack(spacing: 14) {
                        Text("Give \(target)")
                            .font(.system(size: 46, weight: .heavy, design: .rounded))
                            .foregroundColor(Theme.textDark)
                        HStack(spacing: 10) {
                            ForEach(0..<target, id: \.self) { i in
                                Circle()
                                    .fill(i < givenIndices.count ? Theme.leaf : Color.white.opacity(0.85))
                                    .overlay(Circle().strokeBorder(Theme.outline.opacity(0.22), lineWidth: 2))
                                    .frame(width: 26, height: 26)
                            }
                        }
                        ArtView(key: item)
                            .frame(width: itemSize * 0.9, height: itemSize * 0.9)
                    }
                    .padding(22)
                    .background(
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .fill(Color.white.opacity(0.85))
                            .shadow(color: .black.opacity(0.08), radius: 8, y: 5)
                    )
                    .position(x: w * 0.26, y: h * 0.34)

                    // The container receiving the items.
                    ArtView(key: container)
                        .frame(width: containerRect.width, height: containerRect.height)
                        .position(x: containerRect.midX, y: containerRect.midY)

                    // Items already given, resting on the container.
                    ForEach(Array(givenIndices.enumerated()), id: \.element) { order, _ in
                        ArtView(key: item)
                            .frame(width: itemSize * 0.66, height: itemSize * 0.66)
                            .position(x: containerRect.minX + containerRect.width * (0.22 + 0.28 * CGFloat(order % 3)),
                                      y: containerRect.minY + containerRect.height * (0.30 + 0.34 * CGFloat(order / 3)))
                            .transition(.scale.combined(with: .opacity))
                    }

                    // The tray (target + extras).
                    ForEach(0..<trayCount, id: \.self) { i in
                        if !givenIndices.contains(i) {
                            let home = trayPosition(index: i, count: trayCount, size: geo.size)
                            ArtView(key: item)
                                .frame(width: itemSize, height: itemSize)
                                .offset(dragOffsets[i] ?? .zero)
                                .position(home)
                                .zIndex(dragging == i ? 5 : 1)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            guard !finished else { return }
                                            dragging = i
                                            dragOffsets[i] = value.translation
                                        }
                                        .onEnded { value in
                                            let drop = CGPoint(x: home.x + value.translation.width,
                                                               y: home.y + value.translation.height)
                                            handleDrop(i, at: drop, containerRect: containerRect)
                                            dragging = nil
                                        }
                                )
                        }
                    }
                }
            }
        }
        .onAppear {
            if target == 0 {
                target = Int.random(in: range)
                trayCount = min(target + 3, 9)
            }
        }
    }

    private func trayPosition(index: Int, count: Int, size: CGSize) -> CGPoint {
        let fraction = count > 1 ? CGFloat(index) / CGFloat(count - 1) : 0.5
        let x = size.width * (0.10 + 0.80 * fraction)
        return CGPoint(x: x, y: size.height * 0.82)
    }

    private func handleDrop(_ index: Int, at point: CGPoint, containerRect: CGRect) {
        guard !finished else { return }
        if containerRect.insetBy(dx: -26, dy: -26).contains(point) {
            Haptics.soft()
            dragOffsets[index] = .zero
            withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                givenIndices.append(index)
            }
            audio.speak("\(givenIndices.count)")
            if givenIndices.count == target {
                finished = true
                Haptics.success()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    audio.speak("\(target)! Just right!")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6, execute: onComplete)
            }
        } else {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
                dragOffsets[index] = .zero
            }
        }
    }
}
