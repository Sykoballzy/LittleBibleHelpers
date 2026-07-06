import SwiftUI

/// Template 7 (NEW): Find It. Each round names one item ("Find the hammer!")
/// and the child taps the matching card among a few. Teaches identification.
/// One round per item, asked in random order.
struct FindItGame: View {
    let items: [ArtKey]
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    @State private var order: [ArtKey] = []
    @State private var roundIndex = 0
    @State private var layout: [ArtKey] = []
    @State private var wrong: ArtKey?
    @State private var found: ArtKey?

    private var target: ArtKey? {
        roundIndex < order.count ? order[roundIndex] : nil
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let cardSize = min(w / CGFloat(max(layout.count, 1)) - 30, h * 0.5)

            VStack(spacing: 22) {
                if let target {
                    // Reference the child matches against — no reading needed.
                    VStack(spacing: 8) {
                        BannerTitle(text: "Find this one!", color: Theme.coral, textSize: 26)
                        ArtView(key: target)
                            .padding(14)
                            .frame(width: cardSize * 0.52, height: cardSize * 0.52)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.12), radius: 6, y: 4)
                            )
                            .overlay(
                                Circle().strokeBorder(Theme.coral.opacity(0.5), lineWidth: 4)
                            )
                    }
                }

                HStack(spacing: 26) {
                    ForEach(layout, id: \.self) { item in
                        Button {
                            tap(item)
                        } label: {
                            ArtView(key: item)
                                .padding(18)
                                .frame(width: cardSize, height: cardSize)
                                .background(
                                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                                        .fill(Color.white)
                                        .shadow(color: .black.opacity(0.10), radius: 7, y: 4)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                                        .strokeBorder(found == item ? Theme.leaf : Color.clear, lineWidth: 5)
                                )
                                .rotationEffect(.degrees(wrong == item ? 6 : 0))
                                .scaleEffect(found == item ? 1.08 : 1.0)
                        }
                        .buttonStyle(SquishyButtonStyle())
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            if order.isEmpty {
                order = items.shuffled()
                layout = items.shuffled()
            }
        }
    }

    private func tap(_ item: ArtKey) {
        guard found == nil, let target else { return }
        if item == target {
            Haptics.success()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) { found = item }
            audio.speak("You found the \(target.displayName)!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                found = nil
                if roundIndex + 1 < order.count {
                    roundIndex += 1
                    layout.shuffle()
                    if let next = self.target {
                        audio.speak("Find the \(next.displayName)!")
                    }
                } else {
                    onComplete()
                }
            }
        } else {
            Haptics.gentleError()
            withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { wrong = item }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation { wrong = nil }
            }
            audio.speak("That's the \(item.displayName). Try again!")
        }
    }
}
