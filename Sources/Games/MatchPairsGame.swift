import SwiftUI

/// Template 1: flip cards to find matching pairs.
/// Ages 2–3 play 3 pairs; ages 4–5 play 4 pairs.
struct MatchPairsGame: View {
    let pool: [ArtKey]
    let onComplete: () -> Void

    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var audio: AudioService

    private struct Card: Identifiable {
        let id = UUID()
        let art: ArtKey
    }

    @State private var cards: [Card] = []
    @State private var faceUpIDs: [UUID] = []
    @State private var matchedIDs: Set<UUID> = []
    @State private var isEvaluating = false

    var body: some View {
        GeometryReader { geo in
            if cards.count >= 2 {
                let cols = cards.count / 2
                let spacing: CGFloat = 20
                let cardHeight = (geo.size.height - spacing - 28) / 2
                let cardWidth = min(cardHeight * 0.8,
                                    (geo.size.width - 120 - spacing * CGFloat(cols - 1)) / CGFloat(cols))
                VStack(spacing: spacing) {
                    ForEach(0..<2, id: \.self) { row in
                        HStack(spacing: spacing) {
                            ForEach(0..<cols, id: \.self) { col in
                                let card = cards[row * cols + col]
                                MatchCardView(
                                    art: card.art,
                                    isFaceUp: faceUpIDs.contains(card.id) || matchedIDs.contains(card.id),
                                    isMatched: matchedIDs.contains(card.id)
                                )
                                .frame(width: cardWidth, height: cardWidth / 0.8)
                                .onTapGesture { tap(card) }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear(perform: setUp)
    }

    private func setUp() {
        guard cards.isEmpty else { return }
        let pairCount = settings.ageBand == .littleOnes ? min(3, pool.count) : min(4, pool.count)
        let chosen = Array(pool.shuffled().prefix(pairCount))
        cards = (chosen + chosen).map { Card(art: $0) }.shuffled()
    }

    private func tap(_ card: Card) {
        guard !isEvaluating,
              !matchedIDs.contains(card.id),
              !faceUpIDs.contains(card.id) else { return }
        Haptics.soft()
        withAnimation { faceUpIDs.append(card.id) }
        guard faceUpIDs.count == 2 else { return }

        isEvaluating = true
        let first = faceUpIDs[0]
        let second = faceUpIDs[1]
        let firstArt = cards.first { $0.id == first }?.art
        let isMatch = firstArt == cards.first { $0.id == second }?.art

        DispatchQueue.main.asyncAfter(deadline: .now() + (isMatch ? 0.4 : 0.95)) {
            if isMatch {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    matchedIDs.insert(first)
                    matchedIDs.insert(second)
                }
                Haptics.success()
                if let art = firstArt {
                    audio.speak("You found the \(art.displayName)s!")
                }
            } else {
                withAnimation { faceUpIDs = [] }
            }
            faceUpIDs = []
            isEvaluating = false
            if matchedIDs.count == cards.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1, execute: onComplete)
            }
        }
    }
}

struct MatchCardView: View {
    let art: ArtKey
    let isFaceUp: Bool
    let isMatched: Bool

    var body: some View {
        ZStack {
            // back
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(LinearGradient(colors: [Theme.sky, Theme.sky.opacity(0.78)],
                                     startPoint: .top, endPoint: .bottom))
                .overlay(
                    StarShape()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 46, height: 46)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.5), lineWidth: 3)
                        .padding(3)
                )
                .opacity(isFaceUp ? 0 : 1)
                .rotation3DEffect(.degrees(isFaceUp ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            // front
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .overlay(ArtView(key: art).padding(10))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(isMatched ? Theme.leaf : Theme.creamDeep, lineWidth: 3.5)
                )
                .opacity(isFaceUp ? 1 : 0)
                .rotation3DEffect(.degrees(isFaceUp ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .scaleEffect(isMatched ? 1.05 : 1)
        .shadow(color: .black.opacity(0.10), radius: 6, y: 4)
        .animation(.spring(response: 0.45, dampingFraction: 0.7), value: isFaceUp)
        .animation(.spring(response: 0.35, dampingFraction: 0.5), value: isMatched)
    }
}
