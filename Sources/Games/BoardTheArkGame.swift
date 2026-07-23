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

    /// The scene anchored to the ark art's VISIBLE pixels — the ark PNG is a
    /// wide, short strip inside a taller canvas, so anchoring to its frame
    /// puts ramps in mid-air and deck slots in the sky.
    private struct SceneLayout {
        let arkFrame: CGRect   // the frame the ark view is given
        let ark: CGRect        // where the ark's opaque pixels actually land
        let rampTop: CGPoint   // ramp meets the ark by the door
        let rampBase: CGPoint  // ramp meets the ground
    }

    private func layout(in size: CGSize) -> SceneLayout {
        let w = size.width
        let h = size.height
        let frame = CGRect(x: w * 0.24, y: h * 0.02, width: w * 0.52, height: h * 0.56)
        let ark = visibleArkRect(in: frame)
        let rampTop = CGPoint(x: ark.minX + ark.width * 0.42, y: ark.maxY - 2)
        let rampBase = CGPoint(x: rampTop.x - ark.width * 0.22, y: rampTop.y + h * 0.11)
        return SceneLayout(arkFrame: frame, ark: ark, rampTop: rampTop, rampBase: rampBase)
    }

    /// Aspect-fits the ark image into its frame (matching ArtView's
    /// scaledToFit + 0.94 breathing room), then crops to the opaque bounds.
    private func visibleArkRect(in frame: CGRect) -> CGRect {
        guard let img = bundledArtImage("art_ark"), img.size.width > 0, img.size.height > 0 else {
            return frame // vector fallback roughly fills its frame
        }
        let unit = ArtOpaqueBounds.unitBounds(named: "art_ark")
        let scale = min(frame.width / img.size.width, frame.height / img.size.height) * 0.94
        let fw = img.size.width * scale
        let fh = img.size.height * scale
        let fitted = CGRect(x: frame.midX - fw / 2, y: frame.midY - fh / 2, width: fw, height: fh)
        return CGRect(x: fitted.minX + unit.minX * fw,
                      y: fitted.minY + unit.minY * fh,
                      width: unit.width * fw,
                      height: unit.height * fh)
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let scene = layout(in: geo.size)
            let ark = scene.ark
            let animalSize = min(w, h) * 0.19
            let rampDX = scene.rampBase.x - scene.rampTop.x
            let rampDY = scene.rampBase.y - scene.rampTop.y

            ZStack {
                // Water beneath the ark.
                Ellipse()
                    .fill(Color(red: 0.55, green: 0.78, blue: 0.92).opacity(0.65))
                    .frame(width: ark.width * 1.15, height: h * 0.10)
                    .position(x: ark.midX, y: ark.maxY + h * 0.01)

                // Rain during the payoff.
                if phase == .payoff {
                    StormCloudArt()
                        .frame(width: w * 0.3, height: w * 0.3)
                        .position(x: ark.midX, y: ark.minY - h * 0.12)
                        .transition(.opacity)
                }

                // Boarding ramp: a plank actually connecting ground to door.
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(LinearGradient(colors: [Theme.wood, Theme.woodDeep],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: hypot(rampDX, rampDY) + 12, height: 14)
                    .rotationEffect(.radians(atan2(rampDY, rampDX)))
                    .position(x: (scene.rampTop.x + scene.rampBase.x) / 2,
                              y: (scene.rampTop.y + scene.rampBase.y) / 2)

                ArtView(key: .ark)
                    .frame(width: scene.arkFrame.width, height: scene.arkFrame.height)
                    .scaleEffect(arkBounce ? 1.05 : 1.0)
                    .position(x: scene.arkFrame.midX, y: scene.arkFrame.midY)

                // Rainbow payoff arcs over the ark.
                if showRainbow {
                    RainbowArt()
                        .frame(width: ark.width * 1.1, height: ark.width * 0.65)
                        .position(x: ark.midX, y: ark.minY - h * 0.08)
                        .transition(.scale(scale: 0.4).combined(with: .opacity))
                }

                // Every animal, wherever it currently stands.
                ForEach(Array(passengers.enumerated()), id: \.element.id) { index, passenger in
                    let spot = spots[passenger.id] ?? .meadow
                    let isWalking = walkingIDs.contains(passenger.id)
                    let isSelected = selectedID == passenger.id
                    let onDeck = isOnDeck(spot)
                    let size = onDeck ? max(ark.width * 0.13, 34) : animalSize

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
                                       scene: scene, size: geo.size))
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
                          scene: SceneLayout, size: CGSize) -> CGPoint {
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
            return CGPoint(x: scene.rampBase.x, y: scene.rampBase.y - 8)
        case .door:
            return CGPoint(x: scene.rampTop.x, y: scene.rampTop.y - 14)
        case .deck(let slot):
            // One row standing along the roof, boarding left to right.
            let ark = scene.ark
            let count = max(total, 1)
            let fraction = count > 1 ? CGFloat(slot) / CGFloat(count - 1) : 0.5
            let deckSize = max(ark.width * 0.13, 34)
            return CGPoint(x: ark.minX + ark.width * (0.08 + 0.84 * fraction),
                           y: ark.minY - deckSize * 0.30)
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
