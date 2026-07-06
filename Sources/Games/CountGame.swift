import SwiftUI

/// Template 3: tap each item to count it. A number badge pops onto every
/// tapped item and progress dots fill along the bottom.
struct CountGame: View {
    let item: ArtKey
    let target: Int
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService
    @State private var tappedOrder: [Int] = []

    private static let unitPositions: [CGPoint] = [
        CGPoint(x: 0.18, y: 0.30), CGPoint(x: 0.42, y: 0.18), CGPoint(x: 0.68, y: 0.30),
        CGPoint(x: 0.28, y: 0.62), CGPoint(x: 0.52, y: 0.66), CGPoint(x: 0.80, y: 0.60)
    ]
    private static let numberWords = ["One", "Two", "Three", "Four", "Five", "Six"]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let size = min(w, h) * 0.24

            ZStack {
                ForEach(0..<min(target, Self.unitPositions.count), id: \.self) { i in
                    let position = Self.unitPositions[i]
                    let isTapped = tappedOrder.contains(i)
                    ZStack(alignment: .topTrailing) {
                        ArtView(key: item)
                            .frame(width: size, height: size)
                        if let order = tappedOrder.firstIndex(of: i) {
                            NumberBadge(number: order + 1)
                                .offset(x: 6, y: -6)
                        }
                    }
                    .scaleEffect(isTapped ? 1.10 : 1.0)
                    .animation(.spring(response: 0.35, dampingFraction: 0.55), value: isTapped)
                    .position(x: w * position.x, y: h * position.y)
                    .onTapGesture { tap(i) }
                }

                // progress dots
                HStack(spacing: 14) {
                    ForEach(1...target, id: \.self) { n in
                        ZStack {
                            Circle()
                                .fill(n <= tappedOrder.count ? Theme.leaf : Color.white.opacity(0.85))
                                .overlay(Circle().strokeBorder(Theme.outline.opacity(0.22), lineWidth: 2))
                            Text("\(n)")
                                .font(Theme.body(22))
                                .foregroundColor(n <= tappedOrder.count ? .white : Theme.textDark.opacity(0.4))
                        }
                        .frame(width: 46, height: 46)
                    }
                }
                .position(x: w / 2, y: h * 0.92)
            }
        }
    }

    private func tap(_ index: Int) {
        guard !tappedOrder.contains(index) else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            tappedOrder.append(index)
        }
        Haptics.soft()
        let count = tappedOrder.count
        if count == target {
            audio.speak("\(Self.numberWords[count - 1])! You counted \(target) \(item.displayName)s!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.9, execute: onComplete)
        } else {
            audio.speak(Self.numberWords[count - 1])
        }
    }
}

struct NumberBadge: View {
    let number: Int

    var body: some View {
        ZStack {
            Circle().fill(Theme.coral)
            Circle().strokeBorder(Color.white, lineWidth: 3)
            Text("\(number)")
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(width: 40, height: 40)
        .shadow(color: .black.opacity(0.15), radius: 3, y: 2)
        .transition(.scale.combined(with: .opacity))
    }
}
