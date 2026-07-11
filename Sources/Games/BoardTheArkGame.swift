import SwiftUI

/// Template 2 (v3): "Two by Two" — a matching game with a destination.
/// The animal pairs wait in the meadow; the child TAPS one animal, then taps
/// its partner, and the completed pair walks itself to the ramp and up into
/// the ark. No dragging. When the last pair is aboard the rain comes and a
/// rainbow appears.
struct BoardTheArkGame: View {
    let animals: [ArtKey]
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    private struct Passenger: Identifiable, Equatable {
        let id = UUID()
        let art: ArtKey
    }

    /// Where a passenger currently stands. Walking is a chain of animated
    /// spot changes: meadow → ramp base → door → a deck slot.
    private enum Spot: Equatable {
        case meadow
        case rampBase
        case door
        case deck(Int)
    }

    private enum Phase { case boarding, payoff }

    @State private var passengers: [Passenger] = []
    @State private var spots: [UUID: Spot] = [:]
    @State private var selectedID: UUID?
    @State private var walkingIDs: Set<UUID> = []
    @State private var nudged: UUID?
    @State private var boardedCount = 0
    @State private var nextDeckSlot = 0
    @State private var phase: Phase = .boarding
    @State private var showRainbow = false
    @State private var bob = false
    @State private var wiggle = false
    @State private var arkBounce = false

    private var total: Int { passengers.count }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let arkRect = CGRect(x: w * 0.30, y: h * 0.04, width: w * 0.40, height: h * 0.52)
            let animalSize = min(w, h) * 0.19

            ZStack {
                // Water beneath the ark.
                Ellipse()
                    .fill(Color(red: 0.55, green: 0.78, blue: 0.92).opacity(0.65))
                    .frame(width: arkRect.width * 1.5, height: h * 0.14)
                    .position(x: arkRect.midX, y: arkRect.maxY + h * 0.02)

                // Rain during the payoff.
                if phase == .payoff {
                    StormCloudArt()
                        .frame(width: w * 0.3, height: w * 0.3)
                        .position(x: arkRect.midX, y: arkRect.minY - h * 0.02)
                        .transition(.opacity)
                }

                // Boarding ramp up to the ark.
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(LinearGradient(colors: [Theme.wood, Theme.woodDeep],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: arkRect.width * 0.55, height: 16)
                    .rotationEffect(.degrees(26))
                    .position(x: arkRect.midX - arkRect.width * 0.05, y: arkRect.maxY + h * 0.05)

                ArtView(key: .ark)
                    .frame(width: arkRect.width, height: arkRect.height)
                    .scaleEffect(arkBounce ? 1.05 : 1.0)
                    .position(x: arkRect.midX, y: arkRect.midY)

                // Rainbow payoff arcs over the ark.
                if showRainbow {
                    RainbowArt()
                        .frame(width: arkRect.width * 1.6, height: arkRect.width * 1.0)
                        .position(x: arkRect.midX, y: arkRect.minY + h * 0.02)
                        .transition(.scale(scale: 0.4).combined(with: .opacity))
                }

                // Every animal, wherever it currently stands.
                ForEach(Array(passengers.enumerated()), id: \.element.id) { index, passenger in
                    let spot = spots[passenger.id] ?? .meadow
                    let isWalking = walkingIDs.contains(passenger.id)
                    let isSelected = selectedID == passenger.id
                    let onDeck = isOnDeck(spot)
                    let size = onDeck ? arkRect.width * 0.20 : animalSize

                    ZStack {
                        if isSelected {
                            Circle()
                                .fill(Theme.sunny.opacity(0.45))
                                .frame(width: size * 1.25, height: size * 1.25)
                                .blur(radius: 4)
                        }
                        ArtView(key: passenger.art)
                            .frame(width: size, height: size)
                    }
                    .scaleEffect(isSelected ? 1.15 : 1.0)
                    .rotationEffect(.degrees(
                        isWalking ? (wiggle ? 7 : -7) : (nudged == passenger.id ? 8 : 0)
                    ))
                    .offset(y: spot == .meadow && !isSelected ? (bob ? -5 : 0) : 0)
                    .position(position(for: spot, homeIndex: index,
                                       arkRect: arkRect, size: geo.size))
                    .zIndex(isWalking ? 6 : (onDeck ? 2 : 3))
                    .onTapGesture { tap(passenger) }
                    .allowsHitTesting(spot == .meadow && !isWalking && phase == .boarding)
                }

                // Progress: how many aboard.
                ProgressPips(filled: boardedCount, total: total)
                    .position(x: w / 2, y: h * 0.95)
            }
        }
        .onAppear {
            setUp()
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) { bob = true }
            withAnimation(.easeInOut(duration: 0.22).repeatForever(autoreverses: true)) { wiggle = true }
        }
    }

    private func setUp() {
        guard passengers.isEmpty else { return }
        // Two of each animal — two by two.
        passengers = animals.flatMap { [Passenger(art: $0), Passenger(art: $0)] }.shuffled()
        for p in passengers { spots[p.id] = .meadow }
    }

    // MARK: Layout

    private func isOnDeck(_ spot: Spot) -> Bool {
        if case .deck = spot { return true }
        return false
    }

    private func position(for spot: Spot, homeIndex: Int,
                          arkRect: CGRect, size: CGSize) -> CGPoint {
        switch spot {
        case .meadow:
            let count = max(total, 1)
            if count <= 6 {
                let fraction = count > 1 ? CGFloat(homeIndex) / CGFloat(count - 1) : 0.5
                return CGPoint(x: size.width * (0.10 + 0.80 * fraction),
                               y: size.height * 0.82)
            }
            // Two rows when the meadow is crowded.
            let perRow = (count + 1) / 2
            let row = homeIndex / perRow
            let col = homeIndex % perRow
            let fraction = perRow > 1 ? CGFloat(col) / CGFloat(perRow - 1) : 0.5
            return CGPoint(x: size.width * (0.10 + 0.80 * fraction),
                           y: size.height * (row == 0 ? 0.72 : 0.88))
        case .rampBase:
            return CGPoint(x: arkRect.midX - arkRect.width * 0.32,
                           y: arkRect.maxY + size.height * 0.11)
        case .door:
            return CGPoint(x: arkRect.midX + arkRect.width * 0.12,
                           y: arkRect.maxY - size.height * 0.02)
        case .deck(let slot):
            let perRow = 4
            let col = slot % perRow
            let row = slot / perRow
            return CGPoint(
                x: arkRect.minX + arkRect.width * (0.18 + 0.21 * CGFloat(col)),
                y: arkRect.minY + arkRect.height * (0.34 + 0.20 * CGFloat(row))
            )
        }
    }

    // MARK: Interaction

    private func tap(_ passenger: Passenger) {
        guard phase == .boarding else { return }

        // Tapping the picked animal again puts it back down.
        if selectedID == passenger.id {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { selectedID = nil }
            return
        }

        guard let currentID = selectedID,
              let current = passengers.first(where: { $0.id == currentID }) else {
            // First of the pair.
            Haptics.soft()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                selectedID = passenger.id
            }
            audio.speak("A \(passenger.art.displayName)! Where is the other \(passenger.art.displayName)?")
            return
        }

        if current.art == passenger.art {
            boardPair(current, passenger)
        } else {
            // Wrong partner: a friendly nudge, the first pick stays chosen.
            Haptics.gentleError()
            withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { nudged = passenger.id }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation { nudged = nil }
            }
            audio.speak("That's the \(passenger.art.displayName)! Let's find the other \(current.art.displayName)!")
        }
    }

    /// The pair walks itself aboard: meadow → ramp base → door → deck,
    /// the partner half a step behind.
    private func boardPair(_ first: Passenger, _ second: Passenger) {
        Haptics.success()
        selectedID = nil
        audio.speak("Two \(first.art.pluralName)! Up the ramp they go!")

        let firstSlot = nextDeckSlot
        let secondSlot = nextDeckSlot + 1
        nextDeckSlot += 2

        walk(first, delay: 0.0, deckSlot: firstSlot)
        walk(second, delay: 0.35, deckSlot: secondSlot)

        // After both land on deck.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            boardedCount += 2
            withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) { arkBounce = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { arkBounce = false }
            }
            audio.speak("Two \(first.art.pluralName) are safe on the ark!")

            if boardedCount == total {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: startPayoff)
            }
        }
    }

    private func walk(_ passenger: Passenger, delay: Double, deckSlot: Int) {
        walkingIDs.insert(passenger.id)
        withAnimation(.easeInOut(duration: 0.55).delay(delay)) {
            spots[passenger.id] = .rampBase
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.55) {
            withAnimation(.easeInOut(duration: 0.65)) {
                spots[passenger.id] = .door
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 1.20) {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                spots[passenger.id] = .deck(deckSlot)
            }
            walkingIDs.remove(passenger.id)
        }
    }

    private func startPayoff() {
        withAnimation(.easeInOut(duration: 0.5)) { phase = .payoff }
        audio.speak("Everyone is safe inside!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
                phase = .boarding // clear the rain
                showRainbow = true
            }
            audio.speak("Look — a beautiful rainbow!")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2, execute: onComplete)
    }
}

/// A row of pips that fill as items are placed — reusable progress indicator.
struct ProgressPips: View {
    let filled: Int
    let total: Int

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<total, id: \.self) { i in
                Circle()
                    .fill(i < filled ? Theme.leaf : Color.white.opacity(0.8))
                    .overlay(Circle().strokeBorder(Theme.outline.opacity(0.2), lineWidth: 2))
                    .frame(width: 22, height: 22)
                    .scaleEffect(i < filled ? 1.0 : 0.8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: filled)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(Capsule().fill(Color.white.opacity(0.5)))
    }
}
