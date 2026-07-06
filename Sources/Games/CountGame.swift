import SwiftUI

/// Template 3 (v2): a two-phase counting game.
/// Phase 1 — tap each item to count it (number badge pops on, dots fill).
/// Phase 2 — "How many did you find?" pick the matching numeral.
/// This teaches the count → symbol mapping, not just tapping.
struct CountGame: View {
    let item: ArtKey
    let target: Int
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    private enum Phase { case counting, choosing }

    @State private var phase: Phase = .counting
    @State private var tappedOrder: [Int] = []
    @State private var options: [Int] = []
    @State private var wrongPick: Int?

    private static let unitPositions: [CGPoint] = [
        CGPoint(x: 0.18, y: 0.30), CGPoint(x: 0.42, y: 0.18), CGPoint(x: 0.68, y: 0.30),
        CGPoint(x: 0.28, y: 0.62), CGPoint(x: 0.52, y: 0.66), CGPoint(x: 0.80, y: 0.60)
    ]
    private static let numberWords = ["One", "Two", "Three", "Four", "Five", "Six"]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let size = min(w, h) * 0.22

            ZStack {
                // The items being counted (shown in both phases).
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
                    .position(x: w * position.x, y: h * position.y * (phase == .choosing ? 0.72 : 1.0))
                    .onTapGesture { if phase == .counting { tap(i) } }
                }

                // Phase 1: progress dots.
                if phase == .counting {
                    dots
                        .position(x: w / 2, y: h * 0.92)
                }

                // Phase 2: prompt + number choices.
                if phase == .choosing {
                    VStack(spacing: 18) {
                        BannerTitle(text: "How many did you find?", color: Theme.berry, textSize: 24)
                        HStack(spacing: 24) {
                            ForEach(options, id: \.self) { value in
                                NumberChoice(value: value, isWrong: wrongPick == value) {
                                    pickNumber(value)
                                }
                            }
                        }
                    }
                    .position(x: w / 2, y: h * 0.86)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }

    private var dots: some View {
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
    }

    private func tap(_ index: Int) {
        guard !tappedOrder.contains(index) else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            tappedOrder.append(index)
        }
        Haptics.soft()
        let count = tappedOrder.count
        audio.speak(Self.numberWords[count - 1])
        if count == target {
            // Move to the "pick the number" phase.
            options = Self.buildOptions(correct: target)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    phase = .choosing
                }
                audio.speak("How many did you find?")
            }
        }
    }

    private func pickNumber(_ value: Int) {
        if value == target {
            Haptics.success()
            audio.speak("Yes! \(Self.numberWords[target - 1]) \(item.displayName)s!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4, execute: onComplete)
        } else {
            Haptics.gentleError()
            withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { wrongPick = value }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation { wrongPick = nil }
            }
            audio.speak("Let's count again. How many?")
        }
    }

    /// Correct answer plus two nearby distractors, shuffled.
    private static func buildOptions(correct: Int) -> [Int] {
        var set: Set<Int> = [correct]
        var candidates = [correct - 1, correct + 1, correct - 2, correct + 2]
            .filter { $0 >= 1 && $0 <= 9 }
        candidates.shuffle()
        for c in candidates where set.count < 3 { set.insert(c) }
        var n = 2
        while set.count < 3 { set.insert(n); n += 1 }
        return Array(set).shuffled()
    }
}

struct NumberChoice: View {
    let value: Int
    let isWrong: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(value)")
                .font(.system(size: 44, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 96, height: 96)
                .background(
                    ZStack {
                        Circle().fill(Color.black.opacity(0.18)).offset(y: 4)
                        Circle().fill(isWrong ? Theme.coral : Theme.sky)
                        Circle().strokeBorder(Color.white.opacity(0.4), lineWidth: 3).padding(3)
                    }
                )
        }
        .buttonStyle(SquishyButtonStyle())
        .rotationEffect(.degrees(isWrong ? 6 : 0))
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
