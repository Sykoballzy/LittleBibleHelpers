import SwiftUI

/// Template 8 (NEW): Shadow Match. Silhouettes sit along the top; drag each
/// colored animal onto its own shadow. Correct match locks in; a wrong shadow
/// springs the animal back. Teaches shape recognition.
struct ShadowMatchGame: View {
    let items: [ArtKey]
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService
    @Namespace private var matching

    @State private var shadowOrder: [ArtKey] = []
    @State private var trayOrder: [ArtKey] = []
    @State private var matched: Set<ArtKey> = []
    @State private var dragOffsets: [ArtKey: CGSize] = [:]
    @State private var dragging: ArtKey?
    @State private var wrong: ArtKey?

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let slotSize = min(w / CGFloat(max(items.count, 1)) - 30, h * 0.34)
            let shadowRects = rowRects(count: shadowOrder.count, size: geo.size,
                                       yFraction: 0.28, itemSize: slotSize)

            ZStack {
                // Shadow slots (top).
                ForEach(Array(shadowOrder.enumerated()), id: \.element) { index, item in
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.4))
                        if matched.contains(item) {
                            ArtView(key: item)
                                .padding(12)
                                .matchedGeometryEffect(id: item, in: matching)
                        } else {
                            ArtView(key: item)
                                .padding(14)
                                .colorMultiply(.black)
                                .opacity(0.22)
                        }
                    }
                    .frame(width: slotSize, height: slotSize)
                    .position(x: shadowRects[index].midX, y: shadowRects[index].midY)
                }

                // Draggable animals (bottom).
                ForEach(Array(trayOrder.enumerated()), id: \.element) { index, item in
                    if !matched.contains(item) {
                        let home = rowRects(count: trayOrder.count, size: geo.size,
                                            yFraction: 0.76, itemSize: slotSize)[index]
                        ArtView(key: item)
                            .frame(width: slotSize * 0.9, height: slotSize * 0.9)
                            .matchedGeometryEffect(id: item, in: matching)
                            .rotationEffect(.degrees(wrong == item ? 8 : 0))
                            .offset(dragOffsets[item] ?? .zero)
                            .position(x: home.midX, y: home.midY)
                            .zIndex(dragging == item ? 5 : 1)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragging = item
                                        dragOffsets[item] = value.translation
                                    }
                                    .onEnded { value in
                                        let drop = CGPoint(x: home.midX + value.translation.width,
                                                           y: home.midY + value.translation.height)
                                        handleDrop(item, at: drop, shadowRects: shadowRects)
                                        dragging = nil
                                    }
                            )
                    }
                }
            }
        }
        .onAppear {
            if shadowOrder.isEmpty {
                shadowOrder = items.shuffled()
                trayOrder = items.shuffled()
            }
        }
    }

    private func rowRects(count: Int, size: CGSize, yFraction: CGFloat, itemSize: CGFloat) -> [CGRect] {
        guard count > 0 else { return [] }
        return (0..<count).map { i in
            let fraction = count > 1 ? CGFloat(i) / CGFloat(count - 1) : 0.5
            let x = size.width * (0.14 + 0.72 * fraction)
            let y = size.height * yFraction
            return CGRect(x: x - itemSize / 2, y: y - itemSize / 2, width: itemSize, height: itemSize)
        }
    }

    private func handleDrop(_ item: ArtKey, at point: CGPoint, shadowRects: [CGRect]) {
        if let idx = shadowOrder.firstIndex(of: item),
           shadowRects[idx].insetBy(dx: -24, dy: -24).contains(point) {
            Haptics.success()
            dragOffsets[item] = .zero
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                _ = matched.insert(item)
            }
            audio.speak("The \(item.displayName) matches!")
            if matched.count == items.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1, execute: onComplete)
            }
        } else {
            Haptics.gentleError()
            withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { wrong = item }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) { dragOffsets[item] = .zero }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation { wrong = nil }
            }
        }
    }
}
