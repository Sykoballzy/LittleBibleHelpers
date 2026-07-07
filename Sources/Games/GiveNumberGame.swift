import SwiftUI

/// Template 11 (v2): Give the Number — now with decoys.
/// Exactly N of the right item sit in the tray, mixed with items of other
/// kinds. The child must find and give ALL the right ones — and nothing else.
/// Decoys dropped on the container bounce back kindly. Teaches counting out
/// a quantity AND telling the kinds apart.
struct GiveNumberGame: View {
    let item: ArtKey
    let container: ArtKey
    let distractors: [ArtKey]
    let range: ClosedRange<Int>
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    private struct TrayItem: Identifiable {
        let id = UUID()
        let art: ArtKey
        let isTarget: Bool
    }

    @State private var target = 0
    @State private var tray: [TrayItem] = []
    @State private var givenIDs: [UUID] = []
    @State private var dragOffsets: [UUID: CGSize] = [:]
    @State private var dragging: UUID?
    @State private var wiggleID: UUID?
    @State private var decoyRefusals = 0
    @State private var finished = false

    var body: some View {
        GeometryReader { geo in
            if target > 0 {
                let w = geo.size.width
                let h = geo.size.height
                let itemSize = min(w, h) * 0.15
                let containerRect = CGRect(x: w * 0.58, y: h * 0.12, width: w * 0.34, height: h * 0.48)

                ZStack {
                    // The ask: big numeral, filling dots, the item to look for.
                    VStack(spacing: 14) {
                        Text("Give \(target)")
                            .font(.system(size: 46, weight: .heavy, design: .rounded))
                            .foregroundColor(Theme.textDark)
                        HStack(spacing: 10) {
                            ForEach(0..<target, id: \.self) { i in
                                Circle()
                                    .fill(i < givenIDs.count ? Theme.leaf : Color.white.opacity(0.85))
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
                    ForEach(Array(givenIDs.enumerated()), id: \.element) { order, _ in
                        ArtView(key: item)
                            .frame(width: itemSize * 0.66, height: itemSize * 0.66)
                            .position(x: containerRect.minX + containerRect.width * (0.22 + 0.28 * CGFloat(order % 3)),
                                      y: containerRect.minY + containerRect.height * (0.30 + 0.34 * CGFloat(order / 3)))
                            .transition(.scale.combined(with: .opacity))
                    }

                    // The mixed tray: the N right items plus decoys.
                    ForEach(Array(tray.enumerated()), id: \.element.id) { index, trayItem in
                        if !givenIDs.contains(trayItem.id) {
                            let home = trayPosition(index: index, count: tray.count, size: geo.size)
                            ArtView(key: trayItem.art)
                                .frame(width: itemSize, height: itemSize)
                                .rotationEffect(.degrees(wiggleID == trayItem.id ? 8 : 0))
                                .offset(dragOffsets[trayItem.id] ?? .zero)
                                .position(home)
                                .zIndex(dragging == trayItem.id ? 5 : 1)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            guard !finished else { return }
                                            dragging = trayItem.id
                                            dragOffsets[trayItem.id] = value.translation
                                        }
                                        .onEnded { value in
                                            let drop = CGPoint(x: home.x + value.translation.width,
                                                               y: home.y + value.translation.height)
                                            handleDrop(trayItem, at: drop, containerRect: containerRect)
                                            dragging = nil
                                        }
                                )
                        }
                    }
                }
            }
        }
        .onAppear(perform: setUp)
    }

    private func setUp() {
        guard target == 0 else { return }
        target = Int.random(in: range)

        // Exactly `target` right items, plus decoys cycling the other kinds.
        var built: [TrayItem] = (0..<target).map { _ in TrayItem(art: item, isTarget: true) }
        let decoySlots = min(max(2, distractors.count), max(8 - target, 2))
        if !distractors.isEmpty {
            for i in 0..<decoySlots {
                built.append(TrayItem(art: distractors[i % distractors.count], isTarget: false))
            }
        }
        tray = built.shuffled()
    }

    private func trayPosition(index: Int, count: Int, size: CGSize) -> CGPoint {
        // Two rows when the tray is crowded.
        let perRow = count > 5 ? Int(ceil(Double(count) / 2.0)) : count
        let row = index / perRow
        let col = index % perRow
        let itemsInRow = row == 0 ? perRow : count - perRow
        let fraction = itemsInRow > 1 ? CGFloat(col) / CGFloat(itemsInRow - 1) : 0.5
        let x = size.width * (0.10 + 0.80 * fraction)
        let y = size.height * (count > 5 ? (row == 0 ? 0.74 : 0.90) : 0.82)
        return CGPoint(x: x, y: y)
    }

    private func handleDrop(_ trayItem: TrayItem, at point: CGPoint, containerRect: CGRect) {
        guard !finished else { return }
        guard containerRect.insetBy(dx: -26, dy: -26).contains(point) else {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
                dragOffsets[trayItem.id] = .zero
            }
            return
        }

        if trayItem.isTarget {
            Haptics.soft()
            dragOffsets[trayItem.id] = .zero
            withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                givenIDs.append(trayItem.id)
            }
            if givenIDs.count == target {
                finished = true
                Haptics.success()
                audio.speak("\(target)! You found every \(item.displayName)!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6, execute: onComplete)
            } else {
                audio.speak("\(givenIDs.count)")
            }
        } else {
            // A decoy: bounce home with a kind reminder.
            Haptics.gentleError()
            withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { wiggleID = trayItem.id }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                dragOffsets[trayItem.id] = .zero
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation { wiggleID = nil }
            }
            if decoyRefusals < 2 {
                decoyRefusals += 1
                audio.speak("That's a \(trayItem.art.displayName) — we only need \(item.pluralName)!")
            }
        }
    }
}
