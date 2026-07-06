import SwiftUI

/// Template 3 (v3): a two-phase counting game with a randomized target.
/// Phase 1 — tap each item to count it (badge pops on, running total updates).
/// Phase 2 — "How many did you find?" pick the matching numeral.
/// The target is chosen per play from the age-appropriate range, and items lay
/// out in a countable grid that scales up to ~12.
struct CountGame: View {
    let items: [ArtKey]
    let range: ClosedRange<Int>
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    private enum Phase { case counting, choosing }

    @State private var target = 0
    @State private var arts: [ArtKey] = []
    @State private var tappedOrder: [Int] = []
    @State private var options: [Int] = []
    @State private var wrongPick: Int?

    var body: some View {
        GeometryReader { geo in
            if target > 0 {
                let w = geo.size.width
                let h = geo.size.height
                let positions = gridPositions(count: target, size: geo.size)
                let size = itemSize(count: target, in: geo.size)

                ZStack {
                    // Items being counted.
                    ForEach(0..<target, id: \.self) { i in
                        let isTapped = tappedOrder.contains(i)
                        ZStack(alignment: .topTrailing) {
                            ArtView(key: arts.indices.contains(i) ? arts[i] : (items.first ?? .star))
                                .frame(width: size, height: size)
                            if let order = tappedOrder.firstIndex(of: i) {
                                NumberBadge(number: order + 1)
                                    .offset(x: 4, y: -4)
                            }
                        }
                        .scaleEffect(isTapped ? 1.10 : 1.0)
                        .animation(.spring(response: 0.35, dampingFraction: 0.55), value: isTapped)
                        .position(positions[i])
                        .onTapGesture { if target > 0 { tap(i) } }
                    }

                    // Phase 1: running total.
                    if wrongPick == nil, tappedOrder.count < target || options.isEmpty {
                        RunningTotal(count: tappedOrder.count)
                            .position(x: w / 2, y: h * 0.93)
                    }

                    // Phase 2: prompt + number choices.
                    if !options.isEmpty {
                        VStack(spacing: 16) {
                            BannerTitle(text: "How many did you find?", color: Theme.berry, textSize: 24)
                            HStack(spacing: 22) {
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
        .onAppear {
            if target == 0 {
                let t = Int.random(in: range)
                arts = Self.buildArts(count: t, from: items)
                target = t
            }
        }
    }

    /// Fills `count` positions from the item pool (repeating + shuffled for variety).
    private static func buildArts(count: Int, from items: [ArtKey]) -> [ArtKey] {
        guard !items.isEmpty else { return [] }
        var pool: [ArtKey] = []
        while pool.count < count { pool += items }
        return Array(pool.shuffled().prefix(count))
    }

    // MARK: Layout

    private func gridPositions(count: Int, size: CGSize) -> [CGPoint] {
        let cols = count <= 4 ? count : (count <= 9 ? 3 : 4)
        let rows = Int(ceil(Double(count) / Double(cols)))
        let top = size.height * 0.10
        let bottom = size.height * 0.60
        let left = size.width * 0.12
        let right = size.width * 0.88

        return (0..<count).map { i in
            let r = i / cols
            let c = i % cols
            let itemsInRow = (r == rows - 1) ? (count - cols * (rows - 1)) : cols
            let colFrac = itemsInRow > 1 ? CGFloat(c) / CGFloat(itemsInRow - 1) : 0.5
            let rowFrac = rows > 1 ? CGFloat(r) / CGFloat(rows - 1) : 0.5
            let x = left + (right - left) * colFrac
            let y = top + (bottom - top) * rowFrac
            return CGPoint(x: x, y: y)
        }
    }

    private func itemSize(count: Int, in size: CGSize) -> CGFloat {
        let base = min(size.width, size.height)
        switch count {
        case 0...4: return base * 0.22
        case 5...8: return base * 0.17
        default: return base * 0.13
        }
    }

    // MARK: Interaction

    private func tap(_ index: Int) {
        guard !tappedOrder.contains(index) else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            tappedOrder.append(index)
        }
        Haptics.soft()
        let count = tappedOrder.count
        audio.speak("\(count)")
        if count == target {
            options = Self.buildOptions(correct: target)
            audio.speak("How many did you find?")
        }
    }

    private func pickNumber(_ value: Int) {
        if value == target {
            Haptics.success()
            audio.speak("Yes! You counted \(target)!")
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
        var candidates = [correct - 1, correct + 1, correct - 2, correct + 2, correct - 3, correct + 3]
            .filter { $0 >= 1 && $0 <= 20 }
        candidates.shuffle()
        for c in candidates where set.count < 3 { set.insert(c) }
        var n = 1
        while set.count < 3 { set.insert(n); n += 1 }
        return Array(set).shuffled()
    }
}

/// Big friendly running tally for the counting phase.
struct RunningTotal: View {
    let count: Int

    var body: some View {
        HStack(spacing: 12) {
            Text("You counted")
                .font(Theme.body(22))
                .foregroundColor(Theme.textDark)
            ZStack {
                Circle().fill(Theme.leaf)
                Circle().strokeBorder(Color.white, lineWidth: 3)
                Text("\(count)")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
            }
            .frame(width: 58, height: 58)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 8)
        .background(Capsule().fill(Color.white.opacity(0.65)))
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
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(width: 36, height: 36)
        .shadow(color: .black.opacity(0.15), radius: 3, y: 2)
        .transition(.scale.combined(with: .opacity))
    }
}
