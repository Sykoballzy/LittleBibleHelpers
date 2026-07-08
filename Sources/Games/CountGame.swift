import SwiftUI

/// Template 3 (v4): counting by type, one kind at a time.
/// All the items appear together (optionally around a central figure — Daniel
/// in the lions' pit, David with his flock). The child counts one TYPE at a
/// time: "Count the sheep!" — tap them all, hear the total, watch them pop
/// away — then the next type. Single-type games finish with the classic
/// "How many did you find?" numeral pick.
struct CountGame: View {
    let items: [ArtKey]
    let center: ArtKey?
    let labels: [String]?
    let range: ClosedRange<Int>
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    private struct Countable: Identifiable {
        let id = UUID()
        let art: ArtKey
        let position: CGPoint   // unit coordinates
    }

    @State private var countables: [Countable] = []
    @State private var typeOrder: [ArtKey] = []
    @State private var roundIndex = 0
    @State private var tappedIDs: [UUID] = []
    @State private var removedTypes: Set<ArtKey> = []
    @State private var wiggleID: UUID?
    @State private var saidWrongType = false
    @State private var options: [Int] = []
    @State private var wrongPick: Int?
    @State private var totalCount = 0

    private var currentType: ArtKey? {
        roundIndex < typeOrder.count ? typeOrder[roundIndex] : nil
    }

    /// With labels (naming the apostles), every item counts in one continuous
    /// pass regardless of type — no per-type rounds.
    private var isMultiType: Bool { labels == nil && typeOrder.count > 1 }
    private var hasLabels: Bool { labels != nil }

    var body: some View {
        GeometryReader { geo in
            if !countables.isEmpty {
                let w = geo.size.width
                let h = geo.size.height
                let size = itemSize(count: countables.count, in: geo.size)

                ZStack {
                    // Central figure (Daniel in the pit, David with the flock).
                    if let center {
                        ArtView(key: center)
                            .frame(width: min(w, h) * 0.30, height: min(w, h) * 0.30)
                            .position(x: w * 0.5, y: h * 0.38)
                            .allowsHitTesting(false)
                    }

                    // Round prompt: what are we counting right now?
                    if let currentType, options.isEmpty, !hasLabels {
                        HStack(spacing: 10) {
                            ArtView(key: currentType).frame(width: 40, height: 40)
                            Text("Count the \(currentType.pluralName)!")
                                .font(Theme.body(20))
                                .foregroundColor(Theme.textDark)
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.white.opacity(0.85)))
                        .position(x: w / 2, y: h * 0.06)
                    }

                    // The countable items.
                    ForEach(countables) { countable in
                        if !removedTypes.contains(countable.art) {
                            let isTapped = tappedIDs.contains(countable.id)
                            let isActive = countable.art == currentType || !isMultiType
                            ZStack(alignment: .topTrailing) {
                                ArtView(key: countable.art)
                                    .frame(width: size, height: size)
                                if let order = tappedIDs.firstIndex(of: countable.id) {
                                    NumberBadge(number: order + 1)
                                        .offset(x: 4, y: -4)
                                }
                            }
                            .opacity(isActive ? 1 : 0.5)
                            .scaleEffect(isTapped ? 1.10 : 1.0)
                            .rotationEffect(.degrees(wiggleID == countable.id ? 7 : 0))
                            .animation(.spring(response: 0.35, dampingFraction: 0.55), value: isTapped)
                            .position(x: w * countable.position.x, y: h * countable.position.y)
                            .onTapGesture { tap(countable) }
                            .transition(.scale.combined(with: .opacity))
                        }
                    }

                    // Running total for the current round.
                    if options.isEmpty {
                        RunningTotal(count: tappedIDs.count)
                            .position(x: w / 2, y: h * 0.93)
                    }

                    // Final numeral pick (single-type games only).
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
        .onAppear(perform: setUp)
    }

    // MARK: Setup

    private func setUp() {
        guard countables.isEmpty else { return }
        totalCount = Int.random(in: range)

        // Assign types by cycling the pool, then keep round order stable.
        var arts: [ArtKey] = []
        while arts.count < totalCount { arts += items }
        arts = Array(arts.shuffled().prefix(totalCount))
        typeOrder = items.filter { arts.contains($0) }

        let positions = gridPositions(count: totalCount, avoidCenter: center != nil)
        countables = zip(arts, positions).map { Countable(art: $0, position: $1) }
    }

    private func gridPositions(count: Int, avoidCenter: Bool) -> [CGPoint] {
        let cols = count <= 4 ? count : (count <= 9 ? 3 : 4)
        let rows = Int(ceil(Double(count) / Double(cols)))
        let top: CGFloat = 0.14
        let bottom: CGFloat = 0.62
        let left: CGFloat = 0.12
        let right: CGFloat = 0.88

        return (0..<count).map { i in
            let r = i / cols
            let c = i % cols
            let itemsInRow = (r == rows - 1) ? (count - cols * (rows - 1)) : cols
            let colFrac = itemsInRow > 1 ? CGFloat(c) / CGFloat(itemsInRow - 1) : 0.5
            let rowFrac = rows > 1 ? CGFloat(r) / CGFloat(rows - 1) : 0.5
            var x = left + (right - left) * colFrac
            let y = top + (bottom - top) * rowFrac
            // Push items out of the central figure's space.
            if avoidCenter, abs(x - 0.5) < 0.16, y > 0.18, y < 0.58 {
                x = x < 0.5 ? 0.5 - 0.24 : 0.5 + 0.24
            }
            return CGPoint(x: x, y: y)
        }
    }

    private func itemSize(count: Int, in size: CGSize) -> CGFloat {
        let base = min(size.width, size.height)
        switch count {
        case 0...4: return base * 0.21
        case 5...8: return base * 0.16
        default: return base * 0.13
        }
    }

    // MARK: Interaction

    private func tap(_ countable: Countable) {
        guard options.isEmpty, let currentType else { return }
        guard !tappedIDs.contains(countable.id) else { return }

        // Wrong type: gentle wiggle + one teaching line per round.
        guard countable.art == currentType || !isMultiType || hasLabels else {
            Haptics.gentleError()
            withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { wiggleID = countable.id }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation { wiggleID = nil }
            }
            if !saidWrongType {
                saidWrongType = true
                audio.speak("That's a \(countable.art.displayName) — we're counting \(currentType.pluralName)!")
            }
            return
        }

        Haptics.soft()
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            tappedIDs.append(countable.id)
        }

        // Labels mode: speak the NAME (Peter! Andrew!) and count everyone
        // in one continuous pass.
        if let labels {
            let index = tappedIDs.count - 1
            if tappedIDs.count < countables.count {
                audio.speak(index < labels.count ? labels[index] : "\(tappedIDs.count)")
                return
            }
            audio.speak("\(countables.count)! You counted them all!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6, execute: onComplete)
            return
        }

        let remainingOfType = countables.filter {
            $0.art == currentType && !removedTypes.contains($0.art) && !tappedIDs.contains($0.id)
        }
        guard remainingOfType.isEmpty else {
            audio.speak("\(tappedIDs.count)")
            return
        }

        // Round complete.
        let roundTotal = tappedIDs.count
        audio.speak("\(roundTotal) \(roundTotal == 1 ? currentType.displayName : currentType.pluralName)!")

        if isMultiType {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                    _ = removedTypes.insert(currentType)
                }
                tappedIDs = []
                saidWrongType = false
                roundIndex += 1
                if let next = self.currentType {
                    audio.speak("Now count the \(next.pluralName)!")
                } else {
                    audio.speak("You counted everything!")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4, execute: onComplete)
                }
            }
        } else {
            options = Self.buildOptions(correct: totalCount)
            audio.speak("How many did you find?")
        }
    }

    private func pickNumber(_ value: Int) {
        if value == totalCount {
            Haptics.success()
            audio.speak("Yes! You counted \(totalCount)!")
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
